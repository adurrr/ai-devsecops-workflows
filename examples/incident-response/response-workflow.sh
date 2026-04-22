#!/bin/bash
# =============================================================================
# Security Incident Response Workflow
# =============================================================================
# This script demonstrates using AI assistants for security incident response
# following NIST SP 800-61 guidelines
# =============================================================================

set -euo pipefail

# Configuration
INCIDENT_LOG_DIR="${INCIDENT_LOG_DIR:-./incident-logs}"
INCIDENT_ID="INC-$(date +%Y%m%d-%H%M%S)"
SEVERITY="${1:-unknown}"

echo "========================================"
echo "Security Incident Response - $INCIDENT_ID"
echo "Severity: $SEVERITY"
echo "Started: $(date -u +"%Y-%m-%dT%H:%M:%SZ")"
echo "========================================"

# Create incident directory
mkdir -p "$INCIDENT_LOG_DIR/$INCIDENT_ID"
cd "$INCIDENT_LOG_DIR/$INCIDENT_ID"

# =============================================================================
# PHASE 1: DETECTION & ANALYSIS
# =============================================================================
echo ""
echo "[PHASE 1] Detection & Analysis"
echo "----------------------------------------"

# 1.1 Gather initial indicators
echo "Collecting initial indicators..."
kubectl get events --all-namespaces --sort-by='.lastTimestamp' > k8s-events.log 2>/dev/null || true
kubectl get pods --all-namespaces -o wide > k8s-pods.log 2>/dev/null || true
docker ps -a > docker-containers.log 2>/dev/null || true
systemctl status > systemd-status.log 2>/dev/null || true

# 1.2 AI-assisted analysis
echo "Running AI analysis on events..."
cat k8s-events.log | sgpt --role incident_responder "analyze for security anomalies, suspicious patterns, or indicators of compromise" > ai-analysis-phase1.txt

echo "Phase 1 analysis saved to ai-analysis-phase1.txt"

# =============================================================================
# PHASE 2: CONTAINMENT
# =============================================================================
echo ""
echo "[PHASE 2] Containment"
echo "----------------------------------------"
echo "REVIEW AI ANALYSIS BEFORE PROCEEDING"
echo ""
echo "Suggested containment actions from AI:"
grep -A 20 "CONTAINMENT" ai-analysis-phase1.txt || echo "See full analysis in ai-analysis-phase1.txt"

# Interactive containment
echo ""
read -p "Proceed with containment? (requires manual approval) [y/N]: " confirm
if [[ $confirm == [yY] ]]; then
    echo "Executing containment..."
    
    # Example: Isolate suspicious pods
    # kubectl label pods -l app=suspicious isolated=true
    # kubectl patch networkpolicy default-deny -p '{"spec":{"podSelector":{"matchLabels":{"isolated":"true"}}}}'
    
    echo "Containment executed at $(date -u +"%Y-%m-%dT%H:%M:%SZ")" >> containment-log.txt
else
    echo "Containment skipped pending investigation"
fi

# =============================================================================
# PHASE 3: ERADICATION
# =============================================================================
echo ""
echo "[PHASE 3] Eradication"
echo "----------------------------------------"

# AI-assisted remediation planning
oh-my-opencode --agent oracle "based on incident $INCIDENT_ID, create eradication plan: remove threat, patch vulnerabilities, harden configurations" > eradication-plan.txt

echo "Eradication plan created: eradication-plan.txt"
echo "REVIEW AND APPROVE BEFORE EXECUTION"

# =============================================================================
# PHASE 4: RECOVERY
# =============================================================================
echo ""
echo "[PHASE 4] Recovery"
echo "----------------------------------------"

# Generate recovery procedures
oh-my-opencode --agent fixer "generate step-by-step recovery procedures for incident $INCIDENT_ID including verification steps" > recovery-procedures.txt

echo "Recovery procedures: recovery-procedures.txt"

# =============================================================================
# PHASE 5: POST-INCIDENT
# =============================================================================
echo ""
echo "[PHASE 5] Post-Incident Activities"
echo "----------------------------------------"

# Generate timeline
cat > timeline.md << EOF
# Incident Timeline - $INCIDENT_ID

## Detection
- $(date -u +"%Y-%m-%dT%H:%M:%SZ"): Incident detected

## Response Phases
- Phase 1 (Detection): Completed
- Phase 2 (Containment): $(if [[ $confirm == [yY] ]]; then echo "Executed"; else echo "Pending"; fi)
- Phase 3 (Eradication): Planned
- Phase 4 (Recovery): Procedures created

## AI Assistance Used
- Initial analysis: ShellGPT with incident_responder role
- Strategic planning: oh-my-opencode Oracle agent
- Remediation: oh-my-opencode Fixer agent
EOF

# Generate lessons learned template
cat > lessons-learned-template.md << 'EOF'
# Lessons Learned - INC-XXXX

## What Went Well
- 

## What Could Be Improved
- 

## Action Items
- [ ] 

## AI Assistant Performance
- Accuracy of initial analysis: 
- Usefulness of recommendations: 
- Time saved vs. manual investigation: 

## Policy/Procedure Updates Needed
- 
EOF

echo ""
echo "========================================"
echo "Incident Response Complete"
echo "ID: $INCIDENT_ID"
echo "Location: $INCIDENT_LOG_DIR/$INCIDENT_ID"
echo "========================================"
echo ""
echo "Generated artifacts:"
ls -la
