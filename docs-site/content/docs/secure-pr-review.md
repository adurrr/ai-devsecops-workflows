---
title: "Secure PR Review Workflow"
linkTitle: "Secure PR Review"
weight: 6
---

# Secure PR Review Workflow

> Run this workflow before opening a pull request to catch security issues early.

---

## What It Does

The `secure-pr-review` workflow runs a 5-step AI-assisted security review over your branch changes before they reach code review.

| Step | Agent | Task |
|------|-------|------|
| 1 | **Explorer** | Scan changed files for secrets, hardcoded credentials, and insecure patterns |
| 2 | **Librarian** | Check new or updated dependencies for known CVEs and advisories |
| 3 | **Oracle** | Threat model the feature delta — assess security impact of the changes |
| 4 | **Fixer** | Auto-fix detectable issues and write security tests *(requires approval)* |
| 5 | **Designer** | Generate a security summary markdown block for the PR description |

---

## Prerequisites

- Git repo with a base branch (default: `main`)
- Optional but recommended: `trufflehog`, `npm audit`, `safety`, or `govulncheck` installed
- For AI analysis: [opencode](https://github.com/charmbracelet/crush) (formerly OpenCode) with [oh-my-opencode-slim](https://github.com/alvinunreal/oh-my-opencode-slim) plugin

---

## Usage

### Option 1: Standalone Script (Recommended)

The standalone script runs all security scanners locally and can optionally invoke AI analysis via `opencode`:

```bash
# Make executable
chmod +x examples/developer-security/secure-pr-review.sh

# Run against current branch vs main
./examples/developer-security/secure-pr-review.sh

# Run against a specific commit range
./examples/developer-security/secure-pr-review.sh HEAD~5..HEAD

# Use a different base branch
BASE_BRANCH=develop ./examples/developer-security/secure-pr-review.sh
```

The script will:
1. Generate a diff against the base branch
2. Run secret detection with TruffleHog
3. Scan for insecure code patterns (`eval`, `exec`, `innerHTML`, etc.)
4. Run package-manager-specific CVE checks (`npm audit`, `safety`, `govulncheck`)
5. Invoke AI analysis if `opencode` is available

### Option 2: Via opencode TUI (Interactive)

If you have `opencode` with the oh-my-opencode-slim plugin installed:

```bash
# Start opencode in the project directory
opencode

# Inside the TUI, ask:
# "Run a secure PR review on the diff between main and HEAD"
# or
# "Review my branch changes for security issues before I open a PR"
```

The orchestrator will route the request through the appropriate agents (Explorer, Librarian, Oracle, etc.) according to the workflow defined in `configs/oh-my-opencode-slim/devsecops.json`.

### Option 3: One-off with `opencode run`

```bash
# Quick one-shot analysis (no TUI)
opencode run "Review the security of changes in main..HEAD. Check for secrets, dependency CVEs, and threat model the feature delta."
```

---

## What It Produces

### Console Output

```
========================================
Secure PR Review
Base: main
Diff: HEAD
========================================

[1/5] Generating diff against main...
Changed files: src/auth.js src/login.py package.json

[2/5] Explorer: scanning for secrets and insecure patterns...
Running secret detection...
Checking for insecure code patterns...

[3/5] Librarian: checking dependencies for CVEs...
Node.js dependencies changed — running npm audit...

[4/5] Oracle: threat modeling the feature delta...
Running opencode secure-pr-review workflow...
Review saved to: ./.pr-security-review.md

[5/5] Summary
📝 Full AI review: ./.pr-security-review.md
```

### Output File (`.pr-security-review.md`)

The AI-generated markdown includes:

- **Secrets scan** — any leaked credentials or API keys found
- **Dependency report** — CVEs with CVSS scores, affected versions, and upgrade paths
- **Threat model** — attack vectors introduced by the feature delta
- **Auto-fixes** — proposed code changes with diff view
- **Security tests** — new test cases to validate the fix
- **PR description block** — ready-to-paste markdown for your pull request

---

## Interpreting Results

### No Issues Found

```
✅ No secrets detected
✅ No insecure patterns found
✅ No dependency vulnerabilities
✅ Oracle threat model: Low risk
```

Proceed to open your PR. Paste the security summary block into the description.

### Issues Found

```
⚠️  SECRETS DETECTED — review /tmp/pr-secrets.json
⚠️  INSECURE PATTERNS FOUND — review /tmp/pr-insecure-patterns.txt
```

**Do not open the PR yet.**

1. Review the findings in `.pr-security-review.md`
2. Apply suggested auto-fixes from the Fixer agent *(requires approval)*
3. Run the workflow again until clean
4. If Oracle flagged **high-risk changes**, request a human security review

---

## CI/CD Integration

### GitHub Actions (Pre-PR Check)

```yaml
# .github/workflows/secure-pr-review.yml
name: Secure PR Review
on:
  pull_request:
    branches: [main]

jobs:
  security-review:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Run Secure PR Review
        run: |
          ./examples/developer-security/secure-pr-review.sh \
            ${{ github.event.pull_request.base.sha }}..${{ github.sha }}

      - name: Upload Review
        uses: actions/upload-artifact@v4
        with:
          name: pr-security-review
          path: .pr-security-review.md

      - name: Comment PR
        uses: actions/github-script@v7
        with:
          script: |
            const fs = require('fs');
            const review = fs.readFileSync('.pr-security-review.md', 'utf8');
            github.rest.issues.createComment({
              issue_number: context.issue.number,
              owner: context.repo.owner,
              repo: context.repo.repo,
              body: `## 🔒 AI Security Review\n\n${review}`
            });
```

### Git Hook (Local)

```bash
# .git/hooks/pre-push
#!/bin/bash
if ! ./examples/developer-security/secure-pr-review.sh HEAD~$(git rev-list --count @{u}..HEAD)..HEAD; then
    echo "Security review failed. Fix issues before pushing."
    exit 1
fi
```

---

## Customization

### Change the Base Branch

```bash
export BASE_BRANCH=develop
./examples/developer-security/secure-pr-review.sh
```

### Adjust Risk Threshold

In `configs/oh-my-opencode-slim/devsecops.json`:

```json
{
  "workflows": {
    "secure-pr-review": {
      "steps": [
        { "agent": "oracle", "task": "...", "risk_threshold": "medium" }
      ]
    }
  }
}
```

---

## Troubleshooting

| Problem | Cause | Fix |
|---------|-------|-----|
| `opencode: command not found` | Not installed | `go install github.com/charmbracelet/crush@latest` |
| `trufflehog: command not found` | Secret scanner missing | `brew install trufflesecurity/trufflehog/trufflehog` or `pip install truffleHog` |
| Empty review output | No changes vs base branch | Ensure you have commits ahead of `main` |
| False positives on secrets | Pattern matching too broad | Review `/tmp/pr-secrets.json` and verify each finding |
| Fixer changes not applied | Approval gate enabled | Review and approve each fix in the AI interface |

---

## Security Notes

- The workflow **never auto-executes** destructive operations
- Fixer changes require **explicit human approval**
- Secret scans run **locally** — no code leaves your machine for this step
- AI analysis follows the data classification rules in `AGENTS.md`

---

## See Also

- [AGENTS.md](./AGENTS.md) — Full agent configuration and delegation rules
- [configs/oh-my-opencode-slim/devsecops.json](configs/oh-my-opencode-slim/devsecops.json) — Workflow definition
- [configs/oh-my-opencode-slim/devsecops-go.json](configs/oh-my-opencode-slim/devsecops-go.json) — opencode-go subscription config
- [examples/developer-security/secure-pr-review.sh](examples/developer-security/secure-pr-review.sh) — Standalone script source
