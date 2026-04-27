#!/bin/bash
# =============================================================================
# Developer Secure PR Review Workflow
# =============================================================================
# Run this script before opening a pull request to get an AI-assisted
# security review of your changes.
# =============================================================================

set -euo pipefail

# Configuration
BASE_BRANCH="${BASE_BRANCH:-main}"
DIFF_RANGE="${1:-HEAD}"
REVIEW_OUTPUT="${REVIEW_OUTPUT:-./.pr-security-review.md}"

echo "========================================"
echo "Secure PR Review"
echo "Base: $BASE_BRANCH"
echo "Diff: $DIFF_RANGE"
echo "========================================"

# =============================================================================
# 1. GENERATE DIFF
# =============================================================================
echo ""
echo "[1/5] Generating diff against $BASE_BRANCH..."
git diff "$BASE_BRANCH...$DIFF_RANGE" > /tmp/pr-diff.patch

CHANGED_FILES=$(git diff --name-only "$BASE_BRANCH...$DIFF_RANGE" | tr '\n' ' ')
echo "Changed files: $CHANGED_FILES"

# =============================================================================
# 2. EXPLORER — Secret & Pattern Scan
# =============================================================================
echo ""
echo "[2/5] Explorer: scanning for secrets and insecure patterns..."

# Run truffleHog on changed files only
echo "Running secret detection..."
trufflehog git "file:///tmp/pr-diff.patch" --only-verified --json > /tmp/pr-secrets.json 2>/dev/null || true

# Check for common insecure patterns
echo "Checking for insecure code patterns..."
grep -n -E \
  '(eval\s*\(|exec\s*\(|subprocess\.call.*shell=True|os\.system\s*\(|innerHTML\s*=|dangerouslySetInnerHTML|\.html\s*\()' \
  $CHANGED_FILES 2>/dev/null > /tmp/pr-insecure-patterns.txt || true

# =============================================================================
# 3. LIBRARIAN — Dependency CVE Check
# =============================================================================
echo ""
echo "[3/5] Librarian: checking dependencies for CVEs..."

# Detect package managers and run appropriate scanners
if [ -f "package-lock.json" ] && git diff --name-only "$BASE_BRANCH...$DIFF_RANGE" | grep -q "package"; then
    echo "Node.js dependencies changed — running npm audit..."
    npm audit --json > /tmp/pr-npm-audit.json 2>/dev/null || true
fi

if [ -f "Pipfile.lock" ] || [ -f "requirements.txt" ]; then
    if git diff --name-only "$BASE_BRANCH...$DIFF_RANGE" | grep -qE "requirements|Pipfile"; then
        echo "Python dependencies changed — running safety check..."
        safety check --json > /tmp/pr-safety.json 2>/dev/null || true
    fi
fi

if [ -f "go.mod" ] && git diff --name-only "$BASE_BRANCH...$DIFF_BRANCH" | grep -q "go.mod"; then
    echo "Go dependencies changed — running govulncheck..."
    govulncheck -json ./... > /tmp/pr-govulncheck.json 2>/dev/null || true
fi

# =============================================================================
# 4. ORACLE — Threat Model the Delta
# =============================================================================
echo ""
echo "[4/5] Oracle: threat modeling the feature delta..."

# If oh-my-opencode is available, run the full workflow
if command -v oh-my-opencode &> /dev/null; then
    echo "Running oh-my-opencode secure-pr-review workflow..."
    oh-my-opencode --workflow secure-pr-review \
        --diff "$BASE_BRANCH...$DIFF_RANGE" \
        > "$REVIEW_OUTPUT" 2>/dev/null || true
    echo "Review saved to: $REVIEW_OUTPUT"
else
    echo "oh-my-opencode not found. Falling back to manual checks."
    echo "Install with: bunx oh-my-opencode-slim@latest install"
fi

# =============================================================================
# 5. SUMMARY
# =============================================================================
echo ""
echo "========================================"
echo "Secure PR Review Complete"
echo "========================================"
echo ""

# Report findings
if [ -s /tmp/pr-secrets.json ]; then
    echo "⚠️  SECRETS DETECTED — review /tmp/pr-secrets.json"
    cat /tmp/pr-secrets.json | jq -r '.SourceMetadata.Data.git.commit' 2>/dev/null || true
fi

if [ -s /tmp/pr-insecure-patterns.txt ]; then
    echo "⚠️  INSECURE PATTERNS FOUND — review /tmp/pr-insecure-patterns.txt"
fi

if [ -s "$REVIEW_OUTPUT" ]; then
    echo "📝 Full AI review: $REVIEW_OUTPUT"
    echo ""
    echo "Preview:"
    head -30 "$REVIEW_OUTPUT"
fi

echo ""
echo "Next steps:"
echo "1. Review findings above"
echo "2. Apply any auto-fixes from the AI review"
echo "3. Paste the security summary block into your PR description"
echo "4. Request human security review if Oracle flagged high-risk changes"
