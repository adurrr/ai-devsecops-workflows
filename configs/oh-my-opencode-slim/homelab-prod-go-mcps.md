# MCP & LSP Review: Homelab Production-Ready OpenCode Go

> Companion document for `homelab-prod-go.json` — DevSecOps/GitOps configuration.
> **Status:** Draft for manual review. Do not commit without operator approval.

---

## 1. MCP Servers (Model Context Protocol)

### 1.1 Security Scanning

| MCP | Install | Why Include | Caveats |
|-----|---------|-------------|---------|
| **semgrep-mcp** | `semgrep mcp` | Best-in-class SAST with 5000+ rules. Can scan every file the agent generates and prompt regeneration until clean. Native integration with Claude Code / Cursor patterns. | Requires `semgrep` CLI (brew/pipx) + `SEMGREP_APP_TOKEN` for Pro rules. Free tier covers 200 CI jobs/month. Alternative: hosted `https://mcp.semgrep.ai/mcp`. |
| **trivy-scanner** | `trivy mcp-server` | Unified scanner: container images, IaC (Terraform/K8s), filesystem, SBOM generation. Essential for shift-left DevSecOps in homelab. | Requires Trivy CLI >= 0.55. Ensure `trivy` is in `$PATH`. |
| **security-advisories** | `npx -y @security/mcp-advisories` | NVD/MITRE feed aggregation. Fast CVE lookups. | Needs `NVD_API_KEY` (free from NVD). Rate-limited without key. |
| **github-security** | HTTP endpoint | GitHub Advisory Database. Better coverage for OSS packages and GHSA identifiers. | Needs `GITHUB_TOKEN` with `security_events` read scope. |

**Recommendation:** Keep all four. Semgrep + Trivy are the core scanner duo. Security-advisories + GitHub provide redundant intel sources.

---

### 1.2 Kubernetes & GitOps

| MCP | Install | Why Include | Caveats |
|-----|---------|-------------|---------|
| **kubectl-mcp-server** | `npx -y kubectl-mcp-server` | **Most comprehensive K8s MCP** (253+ tools). Covers kubectl, helm, GitOps (ArgoCD/Flux), Argo Rollouts, Cilium, Istio, KEDA, cert-manager, backup, and security audit prompts. | Large tool surface; ensure `KUBECONFIG` points to a least-privilege service account. Consider read-only RBAC for daily use. |
| **argocd-mcp** | `npx -y @argoproj-labs/mcp-for-argocd` | Official ArgoCD MCP. 29 tools for app sync, resource trees, drift detection, managed resources, logs. Supports read-only mode. | Requires `ARGOCD_AUTH_TOKEN` + `ARGOCD_SERVER`. Use read-only mode in config to prevent accidental syncs. |
| **flux-mcp** | `npx -y @controlplane/flux-mcp-server` | Official Flux MCP. Kustomization/HelmRelease status, reconciliation errors, dependency diagrams (Mermaid), root cause analysis. | Read-only by design with secret masking. Best for Flux-centric homelabs. |

**Recommendation:**
- If you use **ArgoCD**: Install `kubectl-mcp-server` + `argocd-mcp`.
- If you use **Flux**: Install `kubectl-mcp-server` + `flux-mcp`.
- If you use **both** or are migrating: Install all three.

**Security Note:** Never expose ArgoCD/Flux MCPs to the internet. Run them locally via stdio. Use read-only tokens by default.

---

### 1.3 Infrastructure as Code

| MCP | Install | Why Include | Caveats |
|-----|---------|-------------|---------|
| **opentofu-mcp-server** | `npx -y @opentofu/opentofu-mcp-server` | OpenTofu official. Registry search for providers, modules, resources, and data sources. Stdio + SSE hosted option. | No auth required for local stdio. Hosted SSE available at `mcp.opentofu.org`. |

**Recommendation:** Essential if you manage infrastructure with Terraform. Provides authoritative provider docs and module search.

---

### 1.4 Observability

| MCP | Install | Why Include | Caveats |
|-----|---------|-------------|---------|
| **prometheus-mcp** | `npx -y @prometheus-community/mcp-server` | Query Prometheus metrics with PromQL (instant + range queries), inspect alert rules and targets, explore metric metadata. Foundation for any observability workflow. | Requires `PROMETHEUS_URL` env var. For Thanos, point to Thanos Query frontend. Read-only by design. |
| **grafana-mcp** | `npx -y @grafana/mcp-server` | Full Grafana API: create/update dashboards, manage datasources and folders, configure alerts, version dashboards. Essential for dashboard-as-code workflows. | Requires `GRAFANA_URL` + `GRAFANA_API_KEY`. Service Account token with `Viewer` or `Editor` role depending on write needs. |
| **loki-mcp** | `npx -y @loki/mcp-server` | Run LogQL queries for operational debugging, tail live logs across namespaces, explore label values and log volume. Complements prometheus-mcp for root cause analysis. | Requires `LOKI_URL` env var. Large log ranges may be slow; use time-bounded queries. |
| **opentelemetry-mcp** | `npx -y @opentelemetry/mcp-server` | TraceQL queries, span attribute inspection, service dependency graphs, sampling rule configuration. Critical for distributed tracing in microservice architectures. | Requires OTLP endpoint. For homelabs, use the OpenTelemetry Collector as a proxy. Trace storage can be expensive — set sane sampling rates. |

**Recommendation:** Install all four for a complete metrics-logs-traces observability stack. If resources are constrained, start with prometheus-mcp + loki-mcp (metrics + logs coverage), then add grafana-mcp and opentelemetry-mcp as your homelab matures.

**Environment variables to export:**
```bash
export PROMETHEUS_URL="http://prometheus.monitoring:9090"
export GRAFANA_URL="http://grafana.monitoring:3000"
export GRAFANA_API_KEY="glsa_xxxxxxxxxxxx"  # Grafana Service Account token
export LOKI_URL="http://loki.monitoring:3100"
export OTEL_EXPORTER_OTLP_ENDPOINT="http://otel-collector.monitoring:4318"
```

---

### 1.5 MCPs Evaluated but Not Included

| MCP | Reason for Exclusion |
|-----|---------------------|
| **AWS EKS MCP Server** | Vendor-locked to AWS. Homelab typically uses self-hosted K3s/Proxmox. |
| **Azure AKS MCP** | Same as above — Azure-specific. |
| **Rancher AI MCP** | Overkill for single-cluster homelab. Useful if managing 3+ clusters via Rancher. |
| **helm-mcp** | `kubectl-mcp-server` already covers all Helm operations. Redundant. |
| **Amazon EKS MCP** | AWS-only. Not applicable to most homelabs. |
| **Datadog Code Security MCP** | Requires Datadog subscription. Overkill for homelab budgets. |
| **Endor Labs MCP** | Enterprise pricing. Free tier too limited. |
| **security-mcp** (Horizon) | Interesting unified wrapper, but less mature than direct Semgrep + Trivy integration. Re-evaluate in Q3. |
| **SAST MCP Server** (iflow) | Remote execution on Kali VM is powerful but adds infrastructure complexity. Consider for dedicated security workstations only. |
| **TalkOps suite** | Good for multi-cloud, but homelab is usually single-provider or on-prem. |

---

## 2. LSP Servers (Language Server Protocol)

OpenCode can leverage LSPs for in-editor validation, schema checks, and vulnerability hover info. These are **client-side** tools (VS Code, Neovim, etc.) that complement the MCP servers.

### 2.1 Required LSPs

| LSP | Install | Purpose | Priority |
|-----|---------|---------|----------|
| **terraform-ls** | HashiCorp official release | IntelliSense, go-to-definition, formatting, semantic tokens for `.tf`, `.tfvars`, `.tfdeploy.hcl`. Syntax-compatible with OpenTofu. | **Critical** |
| **yaml-ls-k8s** | `bl4ko/yaml-ls-k8s` | Auto-detects `apiVersion`/`kind` and fetches the correct K8s JSON schema. Zero-config support for 600+ CRDs (Argo, Istio, cert-manager, etc.). | **Critical** |
| **helm-ls** | `mrjosh/helm-ls` | `.Values` completion, go-to-definition, hover docs, `helm lint` integration inside templates. | **High** |
| **docker-language-server** | Docker official | Dockerfile, Compose, and Bake file support. Docker Scout vulnerability info on hover. BuildKit linting. | **High** |

### 2.2 Optional but Recommended LSPs

| LSP | Install | Purpose | When to Add |
|-----|---------|---------|-------------|
| **sysdig-lsp** | `sysdiglabs/sysdig-lsp` | Real-time vulnerability scanning in-editor. SBOM generation on save. | If you want in-IDE scanning without waiting for CI. |
| **ansible-language-server** | Ansible official | Playbook validation, module completion, `ansible-lint` integration. | If you use Ansible for OS-level configuration. |
| **atmos-lsp** | Cloud Posse | For Atmos infrastructure configuration. Manages multiple LSPs with unified diagnostics. | If you adopt Atmos for Terraform component architecture. |

### 2.3 LSP ↔ MCP Synergy

```
Developer edits manifest
        ↓
    LSP validates schema (yaml-ls-k8s, terraform-ls for OpenTofu)
    LSP shows vulnerabilities on hover (docker-language-server, sysdig-lsp)
        ↓
    Developer commits
        ↓
    MCP scans in CI/agent (trivy, semgrep)
    MCP queries live state (argocd-mcp, flux-mcp, opentofu-mcp-server)
```

**Key Insight:** LSPs provide **fast feedback during editing**. MCPs provide **deep analysis across the entire system**. Both are needed for production-ready DevSecOps.

---

## 3. Environment Variables Checklist

Before activating `homelab-prod-go.json`, ensure these are exported in your shell or `.env` file (never committed):

```bash
# Security Intel
export NVD_API_KEY="your-nvd-api-key"
export GITHUB_TOKEN="ghp_xxx"  # with security_events read

# Semgrep (optional but recommended for Pro rules)
export SEMGREP_APP_TOKEN="your-semgrep-token"

# Kubernetes
export KUBECONFIG="$HOME/.kube/config"
# Ensure kubeconfig uses a least-privilege service account, not cluster-admin

# ArgoCD (if applicable)
export ARGOCD_SERVER="argocd.homelab.local"
export ARGOCD_AUTH_TOKEN="your-argocd-token"

# Terraform / HCP (if applicable)
export TFE_TOKEN="your-tfe-token"

# Observability (required for Observer agent)
export PROMETHEUS_URL="http://prometheus.monitoring:9090"
export GRAFANA_URL="http://grafana.monitoring:3000"
export GRAFANA_API_KEY="glsa_xxxxxxxxxxxx"
export LOKI_URL="http://loki.monitoring:3100"
export OTEL_EXPORTER_OTLP_ENDPOINT="http://otel-collector.monitoring:4318"
```

---

## 4. GitOps RBAC Recommendations

For the Kubernetes context used by OpenCode MCPs:

```yaml
# Example read-only ClusterRole for daily OpenCode operations
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: opencode-readonly
rules:
  - apiGroups: ["*"]
    resources: ["*"]
    verbs: ["get", "list", "watch"]
---
# Escalate to this Role only for approved fixer tasks
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: opencode-gitops-writer
rules:
  - apiGroups: [""]
    resources: ["configmaps", "secrets"]
    verbs: ["create", "update", "patch", "delete"]
  - apiGroups: ["argoproj.io"]
    resources: ["applications"]
    verbs: ["sync", "update"]
```

**Principle:** Default to `opencode-readonly`. The `fixer` agent's `require_approval_for` array in the config ensures human review before any write operation.

---

## 5. Cost Projection (OpenCode Go)

Based on the model routing in `homelab-prod-go.json`:

| Tier | Models | Target % | Est. Monthly Cost |
|------|--------|----------|-------------------|
| Tier 1 (Lightweight) | DeepSeek V4 Flash, Qwen 3.5 Plus | 80% | ~$12 |
| Tier 2 (Mid) | DeepSeek V4 Pro, Qwen 3.6 Plus, GLM-5.1 | 15% | ~$18 |
| Tier 3 (Frontier) | Kimi K2.6, GLM-5.1 | 5% | ~$15 |
| **Total** | | | **~$45 / month** |

This fits comfortably within the OpenCode Go $60/month soft limit with headroom for incident-response spikes.

**Cost Safeguards:**
- `max_cost_per_session` caps prevent runaway agent loops.
- Council sessions are gated to high-stakes decisions only.
- Explorer uses the cheapest available model (DeepSeek V4 Flash at ~$0.03/session).

---

## 6. Migration Path from `devsecops-go.json`

If you are currently using `devsecops-go.json` (v2.1.0):

1. **Copy** `homelab-prod-go.json` alongside it.
2. **Export** the environment variables listed in Section 3.
3. **Install** MCP dependencies:
   - `npm install -g @opentofu/opentofu-mcp-server kubectl-mcp-server`
   - `brew install semgrep` (for Semgrep MCP — PyPI package, not npm)
4. **Install** Trivy: https://aquasecurity.github.io/trivy/latest/getting-started/installation/
5. **Install** LSPs: terraform-ls (syntax-compatible with OpenTofu), yaml-ls-k8s, helm-ls, docker-language-server
6. **Test** with a dry-run: `opencode --config ./homelab-prod-go.json --workflow drift-detection --dry-run`
7. **Switch** your default config symlink after validation.

---

## 7. Q2 2026 Re-evaluation Checklist

- [ ] Check if OpenCode schema v3 supports native `lsp_recommendations` block (currently informational)
- [ ] Evaluate `sysdig-lsp` maturity for inclusion in required list
- [ ] Review `security-mcp` (Horizon) for unified scanner abstraction
- [ ] Test Rancher AI MCP if cluster count grows beyond 3
- [ ] Assess OpenCode Go model additions (potential new frontier models)
- [ ] Validate cost projections against actual usage logs in `~/.local/share/opencode/audit/homelab/`

---

*Document version: 3.0.0-homelab-draft*
*Reviewers: DevSecOps / SRE team*
*Do not commit to main without approval.*
