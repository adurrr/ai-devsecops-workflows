# OpenCode Go — Homelab Production-Ready Configuration

> **Version:** 3.0.0-homelab  
> **Scope:** DevSecOps + GitOps for K3s, OpenTofu, Ansible, ArgoCD/Flux  
> **Models:** OpenCode Go subscription tier only  
> **Status:** Production-ready (manual review completed)

---

## Files in This Directory

| File | Purpose |
|------|---------|
| `homelab-prod-go.json` | Full OpenCode configuration (agents, workflows, MCPs, model routing, security guardrails) |
| `devsecops-go.json` | **oh-my-opencode-slim preset** — agent model/skill/MCP assignments only |
| `homelab-prod-go-mcps.md` | MCP & LSP review — what to install, why, and what's excluded |
| `homelab-prod-go-usage.md` | Step-by-step installation, testing, and troubleshooting guide |

### Which config should I use?

| Scenario | Recommended Config |
|----------|-------------------|
| **Full control** — workflows, security guardrails, cost caps, approval gates | `homelab-prod-go.json` |
| **oh-my-opencode-slim (OMS)** — simple preset-based agent routing | `devsecops-go.json` |

---

## Preset: `devsecops-go`

For [oh-my-opencode-slim](https://github.com/alvinunreal/oh-my-opencode-slim) users, `devsecops-go.json` provides a clean preset that maps the homelab model strategy into OMS format.

```bash
# Use with oh-my-opencode-slim
bunx oh-my-opencode-slim@latest install --config ./devsecops-go.json
```

### Agent Mapping

| Agent | Model | Variant | Skills | MCPs |
|-------|-------|---------|--------|------|
| **Orchestrator** | `opencode-go/kimi-k2.6` | high | `*` | `*` |
| **Oracle** | `opencode-go/glm-5.1` | max | `simplify` | — |
| **Council** | `opencode-go/deepseek-v4-pro` | high | — | — |
| **Librarian** | `opencode-go/kimi-k2.5` | low | — | `websearch`, `context7`, `grep_app`, `security-advisories`, `github-security` |
| **Explorer** | `opencode-go/deepseek-v4-flash` | low | — | — |
| **Designer** | `opencode-go/qwen3.6-plus` | medium | `agent-browser` | — |
| **Fixer** | `opencode-go/deepseek-v4-pro` | high | — | `semgrep-mcp`, `trivy-scanner`, `opentofu-mcp-server` |
| **Observer** | `opencode-go/deepseek-v4-pro` | low | — | `kubectl-mcp-server`, `argocd-mcp`, `flux-mcp`, `prometheus-mcp`, `grafana-mcp`, `loki-mcp`, `opentelemetry-mcp` |

### OMS Preset vs Full Config

The preset format (`devsecops-go.json`) is **minimal** — it only controls which model, skills, and MCPs each agent uses. The full config (`homelab-prod-go.json`) adds:

| Feature | Full Config | OMS Preset |
|---------|-------------|------------|
| Workflows (9 predefined) | ✅ | ❌ |
| Security guardrails (blocked paths, secret detection) | ✅ | ❌ |
| Approval gates (fixer/oracle) | ✅ | ❌ |
| Cost caps & escalation | ✅ | ❌ |
| Model routing tiers | ✅ | ❌ |
| Fallback chains | ✅ | ❌ |
| System prompts | ✅ | ❌ |
| Audit logging config | ✅ | ❌ |

**Recommendation:** Use `devsecops-go.json` if you prefer OMS preset simplicity. Use `homelab-prod-go.json` if you need workflows, security guardrails, and cost controls.

---

## Quick Start

```bash
# 1. Install CLI tools
brew install node kubernetes-cli helm opentofu
brew install aquasecurity/trivy/trivy

# 2. Install MCP servers
brew install semgrep
npm install -g @opentofu/opentofu-mcp-server kubectl-mcp-server

# 3. Export required environment variables
export NVD_API_KEY="your-key"
export GITHUB_TOKEN="ghp_xxx"
export KUBECONFIG="$HOME/.kube/homelab-readonly.yaml"

# 4. Validate config
opencode --config ./homelab-prod-go.json config validate

# 5. Run a dry-run workflow
opencode --config ./homelab-prod-go.json workflow run security-audit --dry-run
```

Full instructions: [`homelab-prod-go-usage.md`](./homelab-prod-go-usage.md)

---

## Architecture

### Agent Model Routing

| Agent | Primary Model | Fallback Chain | Best For |
|-------|--------------|----------------|----------|
| **Orchestrator** | `kimi-k2.6` | `glm-5.1` → `deepseek-v4-pro` → `qwen3.6-plus` | Coordination, final decisions |
| **Explorer** | `deepseek-v4-flash` | `qwen3.5-plus` → `minimax-m2.5` | Fast inventory, read-only recon |
| **Librarian** | `kimi-k2.5` | `qwen3.6-plus` → `mimo-v2.5` | CVE research, compliance intel |
| **Oracle** | `glm-5.1` | `kimi-k2.6` → `deepseek-v4-pro` | Architecture review, risk assessment |
| **Fixer** | `deepseek-v4-pro` | `qwen3.6-plus` → `glm-5` | Safe remediation, non-breaking fixes |
| **Designer** | `qwen3.6-plus` | `mimo-v2.5-pro` → `kimi-k2.5` | Dashboards, runbooks, Mermaid diagrams |
| **Council** | `kimi-k2.6` + `glm-5.1` + `deepseek-v4-pro` | — | Multi-model consensus on high-risk decisions |

### Three-Tier Cost Routing

| Tier | Models | Target % | Est. Monthly Cost |
|------|--------|----------|-------------------|
| **Tier 1** (Lightweight) | DeepSeek V4 Flash, Qwen 3.5 Plus, MiniMax M2.5 | 80% | ~$12 |
| **Tier 2** (Mid) | DeepSeek V4 Pro, Qwen 3.6 Plus, GLM-5.1, MiniMax M2.7 | 15% | ~$18 |
| **Tier 3** (Frontier) | Kimi K2.6, GLM-5.1 | 5% | ~$15 |
| **Total** | | | **~$45 / month** |

Fits within OpenCode Go $60/month soft limit.

---

## Workflows (9 Total)

| Workflow | Trigger | Agents |
|----------|---------|--------|
| `security-audit` | Quarterly / post-incident | Explorer → Librarian → Oracle → Fixer → Council |
| `incident-response` | P0 security incident | Explorer + Librarian + Oracle → Fixer (approval) → Designer |
| `compliance-check` | Audit prep | Librarian → Explorer → Oracle → Fixer → Council |
| `dependency-update` | Weekly / CVE alert | Explorer → Librarian → Oracle → Fixer → Council |
| `secure-pr-review` | Every PR | Explorer → Librarian → Oracle → Fixer (approval) → Designer |
| `gitops-deploy` | Pre-deployment | Explorer → Oracle → Fixer → Designer |
| `iac-hardening` | Infrastructure review | Explorer → Oracle → Fixer → Council |
| `drift-detection` | Weekly / scheduled | Explorer → Oracle → Fixer → Designer |
| `secret-rotation` | Rotation calendar | Explorer → Oracle → Fixer → Designer |

---

## MCP Servers

### Installed

| MCP | Type | Purpose |
|-----|------|---------|
| `security-advisories` | stdio | NVD/MITRE CVE feeds |
| `github-security` | HTTP | GitHub Advisory Database |
| `trivy-scanner` | stdio | Container + IaC vulnerability scanning |
| `semgrep-mcp` | stdio | SAST/SCA/secrets (5000+ rules) |
| `opentofu-mcp-server` | stdio | OpenTofu Registry search |
| `kubectl-mcp-server` | stdio | 253+ K8s tools (GitOps, Helm, security) |
| `argocd-mcp` | stdio | ArgoCD app sync, drift, logs (read-only default) |
| `flux-mcp` | stdio | Flux Kustomization/HelmRelease status (read-only default) |

### Excluded (Documented Why)

- AWS/Azure/Rancher MCPs — vendor-locked or overkill for single-cluster homelab
- Datadog / Endor Labs — enterprise pricing
- `helm-mcp` — redundant with `kubectl-mcp-server`
- `security-mcp` (Horizon) — less mature; re-evaluate Q3 2026

Full review: [`homelab-prod-go-mcps.md`](./homelab-prod-go-mcps.md)

---

## LSP Recommendations

### Required

| LSP | Source | Purpose |
|-----|--------|---------|
| `terraform-ls` | HashiCorp | IntelliSense for `.tf` / `.tfvars` (syntax-compatible with OpenTofu) |
| `yaml-ls-k8s` | `bl4ko/yaml-ls-k8s` | Auto-detects K8s schemas, 600+ CRDs |
| `helm-ls` | `mrjosh/helm-ls` | `.Values` completion, `helm lint` |
| `docker-language-server` | Docker official | Dockerfile/Compose with Docker Scout vuln info |

### Optional

| LSP | Source | Purpose |
|-----|--------|---------|
| `sysdig-lsp` | Sysdig | Real-time in-editor vulnerability scanning |
| `ansible-language-server` | Ansible | Playbook validation and linting |

---

## Security Guardrails

- **Read-only by default** — Explorer and Librarian cannot write
- **Approval gates** — Fixer requires approval for `edit`, `write`, `bash`
- **Oracle approval** — Required for `security-acceptance`, `risk-acceptance`, `architecture-change`, `production-deploy`
- **Blocked paths** — `*.pem`, `*.key`, `.env*`, `~/.ssh/`, `~/.kube/config`
- **Secret detection** — Regex patterns for AWS keys, private keys, passwords, tokens
- **Sensitive resource warnings** — Blocks auto-execution of `tofu destroy`, `kubectl delete namespace`, `helm uninstall`
- **Audit logging** — 180-day retention in `~/.local/share/opencode/audit/homelab/`

---

## Migration from `devsecops-go.json`

| From | To |
|------|-----|
| Terraform MCP (`@hashicorp/mcp-terraform`) | OpenTofu MCP (`@opentofu/opentofu-mcp-server`) |
| `terraform validate` / `terraform plan` | `tofu validate` / `tofu plan` |
| `terraform_destroy` warning | `tofu_destroy` warning |
| 5 workflows | 9 workflows (added gitops-deploy, iac-hardening, drift-detection, secret-rotation) |
| No fallback chains | Fallback chains on every agent |
| No cost caps | Per-agent `max_cost_per_session` with escalation |

---

## Cost Safeguards

| Agent | Max Cost/Session | Escalates To |
|-------|-----------------|--------------|
| Explorer | $0.05 | `deepseek-v4-pro` |
| Librarian | $0.30 | `kimi-k2.6` |
| Oracle | $3.00 | `glm-5.1` |
| Fixer | $1.50 | `kimi-k2.6` |
| Designer | $0.50 | `qwen3.6-plus` |
| Council | $6.00 | `kimi-k2.6` |

---

## Environment Variables

```bash
# Required
export NVD_API_KEY="your-nvd-api-key"
export GITHUB_TOKEN="ghp_xxx"
export KUBECONFIG="$HOME/.kube/homelab-readonly.yaml"

# Optional (for ArgoCD users)
export ARGOCD_SERVER="argocd.homelab.local"
export ARGOCD_AUTH_TOKEN="your-token"

# Optional (for Semgrep Pro rules)
export SEMGREP_APP_TOKEN="your-token"
```

---

## Changelog

### 3.0.0-homelab
- Added OpenTofu support (migrated from Terraform)
- Added 4 new workflows: `gitops-deploy`, `iac-hardening`, `drift-detection`, `secret-rotation`
- Added fallback chains for all agents
- Added per-agent cost caps with escalation targets
- Added `sensitive_resource_warnings` for destructive operations
- Added `homelab_context` block with recommended tool stack
- Added LSP recommendations section
- Switched IaC default from Terraform to OpenTofu
- Added OpenTofu official MCP (`@opentofu/opentofu-mcp-server`)
- Updated all agent system prompts for homelab/GitOps context

---

## Further Reading

- [`homelab-prod-go-usage.md`](./homelab-prod-go-usage.md) — Installation, testing, troubleshooting
- [`homelab-prod-go-mcps.md`](./homelab-prod-go-mcps.md) — MCP/LSP deep dive
- [OpenCode Go Docs](https://opencode.ai/docs/go/)
- [OpenTofu MCP Server](https://github.com/opentofu/opentofu-mcp-server)
- [kubectl-mcp-server](https://www.npmjs.com/package/kubectl-mcp-server)

---

*Maintained by the DevSecOps team. Review cycle: Quarterly.*
