#!/bin/bash
# =============================================================================
# Infrastructure as Code Security Scanner
# =============================================================================
# Multi-tool IaC scanning with AI-powered analysis and remediation
# =============================================================================

set -euo pipefail

SCAN_DIR="${1:-.}"
OUTPUT_DIR="${2:-./iac-scan-results}"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

mkdir -p "$OUTPUT_DIR"

echo "========================================"
echo "IaC Security Scanner"
echo "Target: $SCAN_DIR"
echo "Output: $OUTPUT_DIR"
echo "Timestamp: $TIMESTAMP"
echo "========================================"

# =============================================================================
# 1. TERRAFORM SCANNING
# =============================================================================
echo ""
echo "[1/5] Scanning Terraform configurations..."

if command -v checkov &> /dev/null; then
    checkov -d "$SCAN_DIR" --compact --quiet --framework terraform \
        --output json > "$OUTPUT_DIR/checkov-terraform-$TIMESTAMP.json" 2>/dev/null || true
    echo "✓ Checkov complete"
fi

if command -v tfsec &> /dev/null; then
    tfsec "$SCAN_DIR" --format json --out "$OUTPUT_DIR/tfsec-$TIMESTAMP.json" 2>/dev/null || true
    echo "✓ TFSec complete"
fi

# =============================================================================
# 2. KUBERNETES MANIFEST SCANNING
# =============================================================================
echo ""
echo "[2/5] Scanning Kubernetes manifests..."

if command -v checkov &> /dev/null; then
    checkov -d "$SCAN_DIR" --compact --quiet --framework kubernetes \
        --output json > "$OUTPUT_DIR/checkov-k8s-$TIMESTAMP.json" 2>/dev/null || true
    echo "✓ Checkov (K8s) complete"
fi

if command -v kube-score &> /dev/null; then
    find "$SCAN_DIR" -name "*.yaml" -o -name "*.yml" | \
        xargs kube-score score 2>/dev/null > "$OUTPUT_DIR/kube-score-$TIMESTAMP.txt" || true
    echo "✓ Kube-score complete"
fi

# =============================================================================
# 3. DOCKERFILE SCANNING
# =============================================================================
echo ""
echo "[3/5] Scanning Dockerfiles..."

if command -v checkov &> /dev/null; then
    checkov -d "$SCAN_DIR" --compact --quiet --framework dockerfile \
        --output json > "$OUTPUT_DIR/checkov-dockerfile-$TIMESTAMP.json" 2>/dev/null || true
    echo "✓ Checkov (Dockerfile) complete"
fi

if command -v hadolint &> /dev/null; then
    find "$SCAN_DIR" -name "Dockerfile*" | \
        xargs -I {} hadolint {} 2>/dev/null > "$OUTPUT_DIR/hadolint-$TIMESTAMP.txt" || true
    echo "✓ Hadolint complete"
fi

# =============================================================================
# 4. CLOUDFORMATION SCANNING
# =============================================================================
echo ""
echo "[4/5] Scanning CloudFormation templates..."

if command -v checkov &> /dev/null; then
    checkov -d "$SCAN_DIR" --compact --quiet --framework cloudformation \
        --output json > "$OUTPUT_DIR/checkov-cf-$TIMESTAMP.json" 2>/dev/null || true
    echo "✓ Checkov (CloudFormation) complete"
fi

if command -v cfn-lint &> /dev/null; then
    cfn-lint "$SCAN_DIR" --format json > "$OUTPUT_DIR/cfn-lint-$TIMESTAMP.json" 2>/dev/null || true
    echo "✓ cfn-lint complete"
fi

# =============================================================================
# 5. AI-POWERED ANALYSIS
# =============================================================================
echo ""
echo "[5/5] AI-powered analysis and remediation..."

# Consolidate results for AI analysis
cat > "$OUTPUT_DIR/consolidated-findings.txt" << EOF
IaC Security Scan Results
Generated: $(date)
Target: $SCAN_DIR

EOF

# Add Checkov results if available
if [ -f "$OUTPUT_DIR/checkov-terraform-$TIMESTAMP.json" ]; then
    echo "=== CHECKOV TERRAFORM FINDINGS ===" >> "$OUTPUT_DIR/consolidated-findings.txt"
    cat "$OUTPUT_DIR/checkov-terraform-$TIMESTAMP.json" | \
        jq -r '.results.failed_checks[] | "\(.check_id): \(.check_name) at \(.file_path):\(.file_line_range[0])"' \
        >> "$OUTPUT_DIR/consolidated-findings.txt" 2>/dev/null || true
fi

# AI Analysis
echo "Running AI analysis..."
cat "$OUTPUT_DIR/consolidated-findings.txt" | \
    sgpt --role terraform_security "analyze these IaC security findings, prioritize by severity, suggest fixes with code examples" \
    > "$OUTPUT_DIR/ai-analysis-$TIMESTAMP.txt"

# Generate remediation plan with Fixer agent
if command -v oh-my-opencode &> /dev/null; then
    oh-my-opencode --agent fixer "create remediation plan for IaC issues in $SCAN_DIR based on findings" \
        > "$OUTPUT_DIR/remediation-plan-$TIMESTAMP.txt" 2>/dev/null || true
    echo "✓ Fixer agent remediation plan created"
fi

# =============================================================================
# SUMMARY
# =============================================================================
echo ""
echo "========================================"
echo "Scan Complete"
echo "========================================"
echo ""
echo "Generated files:"
ls -lah "$OUTPUT_DIR/" | grep "$TIMESTAMP"
echo ""
echo "AI Analysis: $OUTPUT_DIR/ai-analysis-$TIMESTAMP.txt"
echo ""
echo "Next steps:"
echo "1. Review AI analysis: cat $OUTPUT_DIR/ai-analysis-$TIMESTAMP.txt"
echo "2. Check remediation plan: cat $OUTPUT_DIR/remediation-plan-$TIMESTAMP.txt"
echo "3. Implement fixes with approval"
