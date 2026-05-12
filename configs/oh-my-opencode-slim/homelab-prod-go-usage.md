# Usage & Testing Guide: homelab-prod-go.json

> How to install, configure, validate, and safely test the homelab production-ready OpenCode Go configuration.

---

## 1. Prerequisites

### 1.1 OpenCode CLI

Ensure you have the latest OpenCode CLI installed:

```bash
# Check current version
opencode --version

# Update if needed
npm update -g opencode
# or
brew upgrade opencode
```

### 1.2 Required Tools

| Tool | Install Command | Why |
|------|-----------------|-----|
| **Node.js + npm** | `brew install node` or `nvm install 22` | Runs stdio MCP servers |
| **Trivy** | `brew install aquasecurity/trivy/trivy` | Container/IaC scanning |
| **kubectl** | `brew install kubernetes-cli` | K8s MCP server dependency |
| **helm** | `brew install helm` | Helm linting / MCP |
| **opentofu** | `brew install opentofu` | OpenTofu validate / MCP |

```bash
# One-liner for macOS (Homebrew)
brew install node kubernetes-cli helm opentofu
brew install aquasecurity/trivy/trivy

# One-liner for Ubuntu/Debian
sudo apt-get install -y nodejs npm kubernetes-client helm opentofu
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sudo sh -s -- -b /usr/local/bin
```

### 1.3 MCP Server Packages

```bash
# Install globally so opencode can spawn them via stdio
npm install -g @opentofu/opentofu-mcp-server kubectl-mcp-server @argoproj-labs/mcp-for-argocd @controlplane/flux-mcp-server

# Semgrep MCP (Python/PyPI, not npm)
brew install semgrep        # macOS
# or: pipx install semgrep  # cross-platform

# Verify they are in $PATH
which semgrep-mcp
which opentofu-mcp-server
which kubectl-mcp-server
```

> **Note:** If you prefer not to install globally, ensure `npx -y <package>` works without prompts.

---

## 2. Environment Setup

Create a `.env` file in your homelab repo root (add to `.gitignore`!):

```bash
# ~/.config/opencode/homelab.env
# NEVER COMMIT THIS FILE

# Security Intel
export NVD_API_KEY="your-nvd-api-key"           # https://nvd.nist.gov/developers/request-an-api-key
export GITHUB_TOKEN="ghp_xxxxxxxxxxxxxxxxxxxx"   # GitHub → Settings → Developer settings → Personal access tokens

# Semgrep (optional, for Pro rules)
export SEMGREP_APP_TOKEN="your-semgrep-token"    # https://semgrep.dev/orgs/-/settings/tokens

# Kubernetes (use a restricted kubeconfig, NOT cluster-admin)
export KUBECONFIG="$HOME/.kube/homelab-readonly.yaml"

# ArgoCD (only if using ArgoCD)
export ARGOCD_SERVER="argocd.homelab.local:443"
export ARGOCD_AUTH_TOKEN="your-argocd-token"     # Settings → Accounts → Generate New Token (read-only)

# Terraform / HCP (only if using HCP Terraform/TFE)
export TFE_TOKEN="your-tfe-token"
```

Source it before running opencode:

```bash
source ~/.config/opencode/homelab.env
```

### 2.1 Kubernetes RBAC (Read-Only Default)

Apply this to your cluster so OpenCode explorers cannot accidentally modify production:

```bash
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: ServiceAccount
metadata:
  name: opencode-readonly
  namespace: default
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: opencode-readonly
rules:
  - apiGroups: ["*"]
    resources: ["*"]
    verbs: ["get", "list", "watch"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: opencode-readonly
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: opencode-readonly
subjects:
  - kind: ServiceAccount
    name: opencode-readonly
    namespace: default
EOF

# Generate kubeconfig for this service account
kubectl config set-credentials opencode-readonly \
  --token=$(kubectl create token opencode-readonly --duration=24h)

kubectl config set-context opencode-readonly \
  --cluster=$(kubectl config view -o jsonpath='{.contexts[?(@.name=="'$(kubectl config current-context)'")].context.cluster}') \
  --user=opencode-readonly

# Switch your KUBECONFIG to use this context
kubectl config use-context opencode-readonly --kubeconfig=$HOME/.kube/homelab-readonly.yaml
```

---

## 3. Configure OpenCode to Use the New Config

### 3.1 Option A: Symlink as Default

```bash
# Backup your current config
cp ~/.config/opencode/config.json ~/.config/opencode/config.json.bak

# Symlink the new config
ln -sf /home/user/src/workflows/ai-devsecops-workflows/configs/oh-my-opencode-slim/homelab-prod-go.json \
       ~/.config/opencode/config.json

# Verify
opencode config validate
```

### 3.2 Option B: Explicit Path (Safer for Testing)

```bash
# Use --config flag for every command during testing
opencode --config /home/user/src/workflows/ai-devsecops-workflows/configs/oh-my-opencode-slim/homelab-prod-go.json <command>
```

### 3.3 Option C: Project-Local Config

If your homelab repo is the only place you want this config:

```bash
cp /home/user/src/workflows/ai-devsecops-workflows/configs/oh-my-opencode-slim/homelab-prod-go.json \
   ~/homelab/.opencode.json

# OpenCode auto-discovers .opencode.json in project root
cd ~/homelab
opencode <command>
```

---

## 4. Quick Validation Tests

Run these in order. Each validates a different layer.

### 4.1 Test 1: Config Syntax & Schema

```bash
# Validate JSON syntax
python3 -m json.tool /home/user/src/workflows/ai-devsecops-workflows/configs/oh-my-opencode-slim/homelab-prod-go.json > /dev/null && echo "✅ JSON valid"

# Validate against OpenCode schema (if supported by your CLI version)
opencode --config /home/user/src/workflows/ai-devsecops-workflows/configs/oh-my-opencode-slim/homelab-prod-go.json config validate
```

### 4.2 Test 2: MCP Server Connectivity

```bash
source ~/.config/opencode/homelab.env

# Test each MCP server individually

echo "=== Trivy ==="
trivy --version

echo "=== Semgrep MCP ==="
semgrep mcp --help | head -5

echo "=== HashiCorp Terraform MCP ==="
npx -y @opentofu/opentofu-mcp-server --help | head -5

echo "=== kubectl MCP Server ==="
npx -y kubectl-mcp-server --help | head -5

echo "=== ArgoCD MCP (if using) ==="
npx -y @argoproj-labs/mcp-for-argocd --help | head -5 2>/dev/null || echo "⚠️  ArgoCD MCP not installed"

echo "=== Flux MCP (if using) ==="
npx -y @controlplane/flux-mcp-server --help | head -5 2>/dev/null || echo "⚠️  Flux MCP not installed"
```

### 4.3 Test 3: Kubernetes Read-Only Access

```bash
kubectl auth can-i get pods --all-namespaces        # should print: yes
kubectl auth can-i create pods --all-namespaces     # should print: no
kubectl auth can-i delete deployments -n default    # should print: no
```

If any of the "no" answers print "yes", your kubeconfig has too much privilege. Fix the RBAC before proceeding.

### 4.4 Test 4: Workflow Dry-Run

```bash
# Run the security-audit workflow in dry-run mode
opencode --config /home/user/src/workflows/ai-devsecops-workflows/configs/oh-my-opencode-slim/homelab-prod-go.json \
         workflow run security-audit --dry-run

# Run drift-detection dry-run
opencode --config /home/user/src/workflows/ai-devsecops-workflows/configs/oh-my-opencode-slim/homelab-prod-go.json \
         workflow run drift-detection --dry-run
```

> **Dry-run mode** simulates agent routing and tool selection without executing destructive commands. Check the output for correct model assignments.

---

## 5. Safe Production Tests (Non-Destructive)

### 5.1 Test 5: Explorer Inventory (Read-Only)

```bash
opencode --config /home/user/src/workflows/ai-devsecops-workflows/configs/oh-my-opencode-slim/homelab-prod-go.json \
         agent explorer run \
         "Inventory all Kubernetes manifests and Terraform files in ~/homelab. Map the attack surface."
```

**Expected:** Explorer uses `deepseek-v4-flash`, only reads files, does not write.

### 5.2 Test 6: Librarian CVE Lookup

```bash
opencode --config /home/user/src/workflows/ai-devsecops-workflows/configs/oh-my-opencode-slim/homelab-prod-go.json \
         agent librarian run \
         "Check for critical CVEs in nginx ingress controller version 1.11.0"
```

**Expected:** Librarian uses `kimi-k2.5`, queries NVD/GitHub advisories, returns CVSS scores.

### 5.3 Test 7: Secure PR Review on a Test Branch

```bash
cd ~/homelab

# Create a test branch
git checkout -b test/opencode-config

# Make a trivial change to a manifest
echo "# test" >> apps/whoami/deployment.yaml

# Run the secure-pr-review workflow
opencode --config /home/user/src/workflows/ai-devsecops-workflows/configs/oh-my-opencode-slim/homelab-prod-go.json \
         workflow run secure-pr-review \
         --base main --head test/opencode-config

# Clean up
git checkout main
git branch -D test/opencode-config
```

**Expected:** Workflow runs all 5 steps. Fixer asks for approval before any edits. Designer outputs a markdown summary.

### 5.4 Test 8: Terraform Plan Drift Detection

```bash
cd ~/homelab/opentofu

# Run the drift-detection workflow
opencode --config /home/user/src/workflows/ai-devsecops-workflows/configs/oh-my-opencode-slim/homelab-prod-go.json \
         workflow run drift-detection \
         --path ./environments/staging
```

**Expected:** Explorer runs `tofu plan`, Oracle analyzes drift, Fixer prepares reconciliation. **No apply is executed** because fixer requires approval.

---

## 6. Testing Approval Gates

The config has `require_approval_for` on Fixer (`edit`, `write`, `bash`) and Oracle (`security-acceptance`, `risk-acceptance`).

### 6.1 Approve a Fixer Edit

When Fixer wants to edit a file, you will see:

```
[fixer] proposes editing: apps/whoami/deployment.yaml
Reason: Add missing securityContext and resource limits
Diff:
+ securityContext:
+   readOnlyRootFilesystem: true
+   allowPrivilegeEscalation: false

Approve? [y/N/d (details)/s (skip)]
```

- **y** — Approve this edit
- **N** — Reject
- **d** — View full diff and reasoning
- **s** — Skip this file but continue workflow

### 6.2 Approve a Risk Acceptance

When Oracle assesses a high-risk change:

```
[oracle] Risk Assessment: Changing ingress-nginx LoadBalancer to NodePort
Risk Level: MEDIUM
Blast Radius: All ingress traffic
Mitigation: Rolling update, health checks enabled

Accept risk? [y/N/r (request council review)]
```

- **y** — Accept with documentation
- **N** — Reject and request alternative
- **r** — Escalate to Council (runs multi-model consensus)

---

## 7. Testing the Council

Trigger a high-stakes decision to test multi-model consensus:

```bash
opencode --config /home/user/src/workflows/ai-devsecops-workflows/configs/oh-my-opencode-slim/homelab-prod-go.json \
         agent council run \
         "We need to upgrade K3s from v1.30 to v1.31. Assess the risk and recommend a rollback-safe strategy."
```

**Expected:**
- 3 models (`kimi-k2.6`, `glm-5.1`, `deepseek-v4-pro`) respond independently
- Consensus threshold: 0.66 (2-of-3 must agree)
- Output includes: majority opinion + any dissenting opinions

---

## 8. Monitoring & Observability

### 8.1 Check Audit Logs

```bash
# View recent audit entries
ls -la ~/.local/share/opencode/audit/homelab/

# Tail the latest log
tail -f ~/.local/share/opencode/audit/homelab/$(date +%Y-%m-%d).log
```

### 8.2 Check Cost Per Session

```bash
# OpenCode may write cost summaries to audit logs
grep -r "cost\|tokens\|model" ~/.local/share/opencode/audit/homelab/ | tail -20
```

### 8.3 Prometheus Metrics (Optional)

If you have the OpenCode metrics exporter enabled:

```bash
# Scrape metrics endpoint
curl -s http://localhost:9090/metrics | grep opencode_

# Key metrics to watch
opencode_requests_total{agent="explorer"}
opencode_cost_usd_total{agent="council"}
opencode_workflow_duration_seconds{workflow="security-audit"}
```

---

## 9. Troubleshooting

### 9.1 MCP Server Fails to Start

```bash
# Check if the binary is in PATH
which kubectl-mcp-server || echo "❌ Not in PATH"

# Test stdio manually
echo '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{}}' | npx -y kubectl-mcp-server

# Common fix: reinstall globally
npm install -g @opentofu/opentofu-mcp-server
```

### 9.2 Kubernetes Permission Denied

```bash
# Verify your context
kubectl config current-context

# Check effective permissions
kubectl auth can-i '*' '*' --list | head -20

# If you see create/update/delete, switch to the readonly context
kubectl config use-context opencode-readonly
```

### 9.3 Model Not Available (OpenCode Go)

```bash
# List available models
opencode models list | grep opencode-go

# If a model is missing, the fallback chain activates automatically
# Check logs to see which model was used:
grep "fallback\|model=" ~/.local/share/opencode/audit/homelab/*.log
```

### 9.4 Workflow Hangs or Loops

```bash
# Cancel with Ctrl+C
# Then check if an agent is stuck in a loop:
grep -i "loop\|retry\|timeout" ~/.local/share/opencode/audit/homelab/*.log

# Reduce max_tokens or add stricter prompts if an agent is too verbose
```

### 9.5 Secret Detection False Positives

If the config blocks a legitimate file (e.g., a test fixture with a fake token):

```bash
# Temporarily override for a single command
OPENCODE_BLOCK_PATTERNS="" opencode --config homelab-prod-go.json <command>

# Or add the file to .opencodeignore
echo "tests/fixtures/fake-secrets.yaml" >> ~/.opencodeignore
```

---

## 10. Gradual Rollout Strategy

Don't switch everything at once. Use this phased approach:

| Phase | Action | Duration |
|-------|--------|----------|
| **1** | Run `--dry-run` on all workflows. Review agent routing. | 1 day |
| **2** | Use `--config` flag explicitly on a test repo/branch. | 1 week |
| **3** | Switch default config symlink. Run only read-only agents (explorer, librarian). | 1 week |
| **4** | Enable fixer with approval gates on non-production namespaces. | 1 week |
| **5** | Full production usage with all workflows enabled. | Ongoing |

---

## 11. Quick Reference Card

```bash
# Daily Commands
opencode --config homelab-prod-go.json agent explorer run "..."
opencode --config homelab-prod-go.json agent librarian run "..."
opencode --config homelab-prod-go.json workflow run security-audit --dry-run

# Weekly Commands
opencode --config homelab-prod-go.json workflow run dependency-update
opencode --config homelab-prod-go.json workflow run drift-detection

# Incident Response
opencode --config homelab-prod-go.json workflow run incident-response --priority p0

# PR Review
opencode --config homelab-prod-go.json workflow run secure-pr-review --base main --head feature/xxx

# Config Validation
opencode --config homelab-prod-go.json config validate
```

---

*Version: 3.0.0-homelab-draft*
*Status: For manual review — do not commit without operator approval.*
