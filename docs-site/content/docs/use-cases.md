---
title: "Practical Use Cases & Patterns"
linkTitle: "Use Cases"
weight: 5
description: >
  Practical examples and patterns for incident response, IaC security,
  secret management, compliance, container security, CI/CD, and threat hunting.
tags: ["use-cases", "patterns", "incident-response", "iac", "compliance", "containers", "cicd"]
---

## Incident Response

### Scenario: Container Escape Detection

**Situation:** Monitoring alert indicates potential container escape attempt

**Workflow:**
```bash
# Step 1: Initial reconnaissance (CLI)
kubectl get events --sort-by='.lastTimestamp' | \
  sgpt "filter for security events, suspicious activity"

# Step 2: Deep investigation (Pair programming)
aider
> "Analyze this pod's security context. Check for privileged mode, 
>  hostPath mounts, and dangerous capabilities"

# Step 3: Remediation planning (Multi-Agent)
# Oracle: Assess blast radius
# Fixer: Generate hardened pod spec
# Council: Validate fix approach
```

**Commands:**
```bash
# Get pod security context
kubectl get pod suspicious-pod -o json | \
  jq '.spec.containers[].securityContext'

# Check for privileged containers
kubectl get pods --all-namespaces -o json | \
  jq '.items[] | select(.spec.containers[].securityContext.privileged == true)'
```

---

## Infrastructure as Code Security

### Scenario: Terraform Security Review

**Workflow:**
```bash
# 1. Discovery (Explorer agent)
find . -name "*.tf" -o -name "*.tfvars" | \
  oh-my-opencode --agent explorer "map all Terraform files and their purposes"

# 2. Security scan (Oracle agent)
oh-my-opencode --agent oracle "review all Terraform for security issues:
   - Public S3 buckets
   - Open security groups
   - Hardcoded secrets
   - Missing encryption"

# 3. Remediation (Fixer agent)
oh-my-opencode --agent fixer "fix identified issues, create PR"
```

**Common Issues to Check:**
```hcl
# DANGER: Public S3 bucket
resource "aws_s3_bucket" "data" {
  # Missing ACL or public_access_block
}

# SAFE: Private S3 bucket
resource "aws_s3_bucket_public_access_block" "data" {
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# DANGER: Open security group
resource "aws_security_group" "web" {
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Too open!
  }
}
```

---

## Secret Management

### Scenario: Secret Rotation

**Workflow:**
```bash
# 1. Find all secret references (Explorer)
grep -r "password\|secret\|token\|key" --include="*.yaml" --include="*.json" --include="*.tf" . | \
  sgpt "categorize by secret type and location"

# 2. Identify rotation requirements (Librarian)
# Research: Which secrets need rotation? What's the schedule?

# 3. Plan rotation (Oracle)
# Assess: Zero-downtime rotation strategy

# 4. Execute (Fixer + human approval)
# Update Kubernetes secrets
# Update CI/CD variables
# Update Terraform state
# Verify application health
```

**Secret Scanner Script:**
```bash
#!/bin/bash
# scan-secrets.sh

echo "Scanning for secrets..."

# Use truffleHog or gitLeaks
trufflehog filesystem . --json | \
  jq -r '. | select(.Verified == true)'

# Check Kubernetes secrets
kubectl get secrets --all-namespaces -o json | \
  jq '.items[] | select(.type == "Opaque") | {name: .metadata.name, namespace: .metadata.namespace}'

# Check for base64 encoded secrets
grep -r "^[A-Za-z0-9+/]*={0,2}$" --include="*.yaml" . | \
  sgpt "identify potential base64-encoded secrets"
```

---

## Compliance Automation

### Scenario: CIS Benchmark Assessment

**Workflow:**
```bash
# 1. Research requirements (Librarian)
oh-my-opencode --agent librarian "fetch CIS Kubernetes Benchmark v1.8 requirements"

# 2. Automated assessment (Explorer + custom scripts)
#!/bin/bash
# cis-check.sh

echo "=== CIS Kubernetes Benchmark Check ==="

# 1.1.1 Ensure that the API server pod specification file permissions are set to 600
stat -c %a /etc/kubernetes/manifests/kube-apiserver.yaml

# 1.2.1 Ensure that anonymous requests are authorized
kubectl get configmap kube-apiserver -n kube-system -o json | \
  jq -r '.data["request-timeout"]'

# Run assessment
./cis-check.sh | \
  oh-my-opencode --agent oracle "assess compliance against CIS benchmark"

# 3. Generate report (Designer)
oh-my-opencode --agent designer "create compliance dashboard markdown"

# 4. Remediation (Fixer)
oh-my-opencode --agent fixer "generate Ansible playbooks for failed checks"
```

---

## Container Security

### Scenario: Image Vulnerability Management

**Workflow:**
```bash
# 1. Scan all images (CLI + Trivy)
kubectl get pods --all-namespaces -o json | \
  jq -r '.items[].spec.containers[].image' | sort -u | \
  while read image; do
    trivy image "$image" --severity HIGH,CRITICAL
  done

# 2. Analyze results (Multi-Agent)
# Explorer: Map vulnerable images to deployments
# Librarian: Research CVE details and patches
# Oracle: Prioritize by exploitability
# Fixer: Update base images, rebuild

# 3. Automated patching
oh-my-opencode --agent fixer "update Dockerfile base images to patched versions"
```

**Trivy Integration:**
```yaml
# trivy-scan.yaml
name: Container Security Scan
on: [push, pull_request]

jobs:
  scan:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Build image
        run: docker build -t app:${{ github.sha }} .
      
      - name: Scan with Trivy
        uses: aquasecurity/trivy-action@master
        with:
          image-ref: 'app:${{ github.sha }}'
          format: 'sarif'
          output: 'trivy-results.sarif'
      
      - name: AI Analysis
        run: |
          cat trivy-results.sarif | \
            sgpt "summarize vulnerabilities, prioritize by severity, suggest fixes"
```

---

## Network Security

### Scenario: Firewall Rule Analysis

**Workflow:**
```bash
# 1. Collect network policies (CLI)
kubectl get networkpolicies --all-namespaces -o yaml > network-policies.yaml

aws ec2 describe-security-groups > security-groups.json

# 2. Security analysis (Multi-Agent)
oh-my-opencode --agent oracle "analyze network policies for:
   - Overly permissive rules
   - Missing deny-all defaults
   - Unused rules
   - Shadowed rules"

# 3. Optimization (Fixer)
oh-my-opencode --agent fixer "consolidate redundant rules, tighten CIDR ranges"
```

---

## Log Analysis & Monitoring

### Scenario: Anomaly Detection

**Workflow:**
```bash
# 1. Real-time log analysis
kubectl logs -f deployment/api | \
  sgpt --stream "detect anomalies, flag suspicious patterns"

# 2. Historical analysis
journalctl --since "24 hours ago" -u ssh | \
  sgpt "find brute force attempts, successful logins from new IPs"

# 3. Pattern extraction
cat /var/log/nginx/access.log | \
  sgpt "extract top 10 user agents, identify potential scanners"
```

**Splunk/ELK Queries:**
```bash
# Generate Splunk SPL from natural language
echo "Find failed logins from same IP with different usernames" | \
  sgpt "generate Splunk SPL query"

# Output:
# index=auth eventtype=failed_login 
# | stats dc(username) as unique_users by src_ip 
# | where unique_users > 5
```

---

## CI/CD Security

### Scenario: Pipeline Security Hardening

**Workflow:**
```bash
# 1. Audit existing pipelines (Explorer)
find .github/workflows -name "*.yml" -o -name "*.yaml" | \
  oh-my-opencode --agent explorer "map all workflows and their security controls"

# 2. Security assessment (Oracle)
oh-my-opencode --agent oracle "review for:
   - Missing branch protection
   - Overly permissive permissions
   - Hardcoded secrets
   - Unpinned actions
   - Missing SBOM generation"

# 3. Remediation (Fixer)
oh-my-opencode --agent fixer "implement security best practices"
```

**GitHub Actions Security:**
```yaml
# secure-workflow.yml
name: Secure CI/CD

permissions:
  contents: read  # Least privilege
  
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          persist-credentials: false  # Security best practice
          
      - uses: sigstore/cosign-installer@v3.3.0
        with:
          cosign-release: 'v2.2.0'  # Pinned version
          
      - name: Build and sign
        run: |
          docker build -t app:${{ github.sha }} .
          cosign sign --yes app:${{ github.sha }}
        env:
          COSIGN_EXPERIMENTAL: 1
```

---

## Threat Hunting

### Scenario: Lateral Movement Detection

**Workflow:**
```bash
# 1. Baseline normal behavior
cat /var/log/auth.log | \
  sgpt "establish baseline: typical login times, source IPs, users"

# 2. Anomaly detection
cat /var/log/auth.log | \
  sgpt "find:
   - Logins outside business hours
   - New source IPs
   - Privilege escalation attempts
   - Multiple failed attempts followed by success"

# 3. Cross-reference
# Check if anomalous IPs appear in other logs
zgrep "SUSPICIOUS_IP" /var/log/*
```

---

## Configuration Drift Detection

### Scenario: Infrastructure Drift

**Workflow:**
```bash
# 1. Capture current state
terraform show -json > current-state.json
kubectl get all --all-namespaces -o yaml > current-k8s.yaml

# 2. Compare with desired state (Multi-Agent)
oh-my-opencode --agent explorer "compare Terraform state with actual resources"
oh-my-opencode --agent oracle "classify drift: intentional vs. unauthorized"

# 3. Remediation
oh-my-opencode --agent fixer "generate plan to reconcile drift"
```

---

## Disaster Recovery

### Scenario: Recovery Validation

**Workflow:**
```bash
# 1. Document current state (Librarian + Explorer)
oh-my-opencode --agent librarian "fetch disaster recovery requirements"
oh-my-opencode --agent explorer "inventory critical resources and dependencies"

# 2. Test recovery procedures (Oracle)
oh-my-opencode --agent oracle "assess RTO/RPO feasibility, identify gaps"

# 3. Automation (Fixer)
oh-my-opencode --agent fixer "create runbooks and automation scripts"
```

---

## Common Patterns Library

### Pattern 1: Security Scan Orchestration

```bash
#!/bin/bash
# security-scan.sh

echo "Starting comprehensive security scan..."

# SAST
bandit -r . -f json | \
  sgpt "summarize Python security issues"

# Secrets
trufflehog filesystem . --json | \
  sgpt "prioritize secrets by risk"

# Dependencies
safety check --json | \
  sgpt "assess dependency vulnerabilities"

# IaC
checkov -d . --compact --quiet | \
  sgpt "prioritize infrastructure misconfigurations"

# Container
trivy fs --scanners vuln,secret,misconfig . | \
  sgpt "generate remediation plan"
```

### Pattern 2: Approval Workflow

```yaml
# approval-gate.yml
security-gates:
  ai-generated-changes:
    require-approval:
      - security-team
    conditions:
      - modified-files: "*.tf,*.yaml,*.yml"
      - ai-authored: true
    
  high-risk-operations:
    require-approval:
      - senior-sre
    conditions:
      - command-pattern: "kubectl delete|terraform destroy|aws ec2 terminate"
```

### Pattern 3: Audit Logging

```bash
#!/bin/bash
# ai-audit.sh

log_ai_interaction() {
    local tool="$1"
    local prompt="$2"
    local response="$3"
    local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    
    cat >> /var/log/ai-assistant/audit.log << EOF
{
  "timestamp": "$timestamp",
  "tool": "$tool",
  "user": "$USER",
  "session": "$AI_SESSION_ID",
  "prompt_hash": "$(echo "$prompt" | sha256sum | cut -d' ' -f1)",
  "response_hash": "$(echo "$response" | sha256sum | cut -d' ' -f1)"
}
EOF
}
```

---

## Tool Integration Matrix

| Use Case | Primary Tool | Secondary | Output Format |
|----------|--------------|-----------|---------------|
| Vulnerability Scanning | Trivy | Grype | SARIF |
| Secret Detection | TruffleHog | GitLeaks | JSON |
| SAST | Semgrep | Bandit | SARIF |
| IaC Scanning | Checkov | tfsec | JUnit XML |
| Compliance | OpenSCAP | Chef Inspec | HTML/JSON |
| Container Scanning | Trivy | Snyk | SARIF |

---

## Automation Opportunities

### High-Value Automation Targets

1. **Daily:**
   - Vulnerability scan result analysis
   - Log anomaly detection
   - Certificate expiration checks

2. **Weekly:**
   - Compliance drift detection
   - Access review assistance
   - Security metrics generation

3. **Monthly:**
   - Full security assessment
   - Penetration test result analysis
   - Policy review and updates

4. **On-Demand:**
   - Incident response
   - Forensic analysis
   - Threat intelligence research
