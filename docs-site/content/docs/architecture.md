---
title: "DevSecOps Architecture with AI Assistants"
linkTitle: "Architecture"
weight: 1
description: >
  System design patterns, agent responsibilities, and integration architecture for AI-assisted DevSecOps.
---

{{< alert title="Agent Permissions and Security" color="warning" >}}
Always follow the principle of least privilege when configuring agent permissions. Never grant execute permissions to agents handling sensitive codebases without human approval gates.
{{< /alert >}}

{{< alert title="Cost Optimization" color="info" >}}
Use ultra-cheap models (e.g., DeepSeek V4 Flash) for read-only tasks like exploration, and reserve frontier models for strategic decisions requiring deep analysis.
{{< /alert >}}

## System Design Patterns

### The Agent Pantheon in DevSecOps Context

When using **oh-my-opencode-slim**, each agent maps to specific DevSecOps responsibilities:

```
┌─────────────────────────────────────────────────────────────┐
│                    DEVSECOPS WORKFLOW                        │
└─────────────────────────────────────────────────────────────┘

  ┌──────────────┐
  │ Orchestrator │ ← Main interface, routes tasks
  └──────┬───────┘
         │
    ┌────┴────┬─────────┬─────────┬─────────┬─────────┐
    ▼         ▼         ▼         ▼         ▼         ▼
┌───────┐ ┌───────┐ ┌───────┐ ┌───────┐ ┌───────┐ ┌───────┐
│Explorer│ │Librarian│ │Oracle │ │Fixer  │ │Designer│ │Council│
└───┬───┘ └────┬──┘ └───┬───┘ └───┬───┘ └───┬───┘ └───┬───┘
    │          │        │         │         │         │
    ▼          ▼        ▼         ▼         ▼         ▼
 Codebase   External  Strategic Implementation  UI/UX  Multi-model
 Mapping    Research  Architecture   Tasks     Polish  Consensus
```

### Agent Responsibilities in DevSecOps

| Agent | DevSecOps Role | Typical Tasks |
|-------|---------------|---------------|
| **Orchestrator** | Security Coordinator | Task routing, context management, final decisions |
| **Explorer** | Asset Discovery | Map attack surface, find secrets, inventory IaC |
| **Librarian** | Threat Intel | CVE lookups, security advisory research, compliance docs |
| **Oracle** | Security Architect | Risk assessment, threat modeling, architecture review |
| **Fixer** | Remediation Engineer | Auto-patch vulnerabilities, update configs, refactor code |
| **Designer** | Security UX | Security dashboards, alert interfaces, documentation |
| **Council** | Red Team Consensus | Multi-model security validation, attack simulation |

## Workflow Patterns

### Pattern 1: Continuous Security Assessment

```
Trigger: Code push or schedule

1. Explorer → Map codebase changes
   └─ Identify new files, dependencies, configurations

2. Oracle → Assess risk
   └─ Analyze attack surface changes
   └─ Prioritize security concerns

3. Librarian → Research threats
   └─ Check for new CVEs in dependencies
   └─ Review security advisories

4. Fixer → Auto-remediate (if safe)
   └─ Update vulnerable dependencies
   └─ Apply security patches
   └─ Refactor insecure patterns

5. Council → Validate (high-risk changes)
   └─ Multi-model review of critical changes
   └─ Consensus on risk acceptance
```

### Pattern 2: Incident Response

```
Trigger: Security alert or breach

1. Explorer → Immediate reconnaissance
   └─ Find affected systems in codebase
   └─ Map blast radius

2. Librarian → Rapid research
   └─ Look up attack vectors
   └─ Find mitigation strategies

3. Oracle → Strategic response
   └─ Assess containment options
   └─ Plan remediation steps

4. Fixer → Execute fixes
   └─ Apply emergency patches
   └─ Update firewall rules
   └─ Rotate credentials

5. Designer → Document incident
   └─ Create timeline
   └─ Generate post-mortem template
```

### Pattern 3: Compliance Automation

```
Trigger: Audit requirement or policy update

1. Librarian → Research standards
   └─ Fetch compliance requirements
   └─ Map to controls

2. Explorer → Find evidence
   └─ Scan IaC for compliance gaps
   └─ Document current state

3. Oracle → Gap analysis
   └─ Compare current vs required state
   └─ Prioritize remediation

4. Fixer → Implement controls
   └─ Add missing security controls
   └─ Update policies as code

5. Council → Validate compliance
   └─ Multi-model review of compliance posture
```

## Integration Architecture

### With Existing DevSecOps Toolchain

```
┌──────────────────────────────────────────────────────────────┐
│                      DEVSECOPS PLATFORM                       │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐     │
│  │   SAST   │  │   DAST   │  │ Secrets  │  │   IaC    │     │
│  │  Scanner │  │  Scanner │  │ Scanner  │  │ Scanner  │     │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘  └────┬─────┘     │
│       │             │             │             │            │
│       └─────────────┴──────┬──────┴─────────────┘            │
│                            ▼                                 │
│                    ┌───────────────┐                         │
│                    │  AI Assistant │ ← oh-my-opencode-slim   │
│                    │   (Analysis)  │                         │
│                    └───────┬───────┘                         │
│                            │                                 │
│       ┌────────────────────┼────────────────────┐            │
│       ▼                    ▼                    ▼            │
│  ┌─────────┐         ┌─────────┐         ┌─────────┐         │
│  │  SIEM   │         │  Ticketing │      │  CI/CD  │         │
│  │  (Splunk│         │  (Jira)   │       │ Pipeline│         │
│  │ Datadog)│         │           │       │         │         │
│  └─────────┘         └─────────┘         └─────────┘         │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

### Data Flow Security

```
User Input → Local Filter → AI Assistant → Local Sanitization → Output
                │                              │
                ▼                              ▼
          ┌──────────┐                  ┌──────────┐
          │ .gitignore│                  │ Command  │
          │ Patterns  │                  │ Review   │
          │ PII Filter│                  │ (Human)  │
          └──────────┘                  └──────────┘
```

## Configuration Architecture

### Multi-Provider Cost Optimization

```json
{
  "agents": {
    "orchestrator": {
      "model": "openai/gpt-5.4",
      "purpose": "Strategic decisions, complex security analysis"
    },
    "explorer": {
      "model": "cerebras/zai-glm-4.7",
      "purpose": "Fast codebase scanning, low cost"
    },
    "oracle": {
      "model": "openai/gpt-5.4 (high)",
      "purpose": "Deep security architecture review"
    },
    "librarian": {
      "model": "openai/gpt-5.4-mini",
      "purpose": "Documentation lookups, CVE research"
    },
    "fixer": {
      "model": "fireworks-ai/kimi-k2p5-turbo",
      "purpose": "Fast implementation, routine fixes"
    },
    "council": {
      "models": ["openai/gpt-5.4", "anthropic/claude-3.5-sonnet", "google/gemini-1.5-pro"],
      "purpose": "Multi-model consensus on critical security decisions"
    }
  }
}
```

## MCP (Model Context Protocol) Integration

### Security-Focused MCP Servers

```json
{
  "mcpServers": {
    "security-advisories": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@security/mcp-advisories"]
    },
    "github-security": {
      "type": "http",
      "url": "https://api.github.com/advisories",
      "auth": "${GITHUB_TOKEN}"
    },
    "terraform-docs": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@hashicorp/mcp-terraform"]
    },
    "kubernetes-api": {
      "type": "stdio",
      "command": "kubectl",
      "args": ["mcp-server"]
    }
  }
}
```

## Scalability Patterns

### From Individual to Enterprise

| Scale | Pattern | Tools |
|-------|---------|-------|
| **Individual** | Local CLI + local models | ShellGPT + Ollama |
| **Team** | Shared configs + centralized policies | oh-my-opencode-slim + shared git repo |
| **Enterprise** | Federated agents + governance layer | Custom orchestration + audit logging |

### Session Management at Scale

```yaml
# Enterprise session patterns
sessions:
  security-audit:
    retention: 90_days
    logging: required
    approval: security_lead
  
  incident-response:
    retention: 1_year
    logging: required
    approval: auto
    
  routine-ops:
    retention: 7_days
    logging: optional
    approval: none
```

## Anti-Patterns to Avoid

1. **The "Yolo" Mode**: Never use `--yolo` or equivalent in production
2. **Over-Delegation**: Don't route trivial tasks through complex multi-agent flows
3. **Context Bleed**: Isolate sensitive and non-sensitive contexts
4. **Model Over-Reliance**: Always have human review for security-critical changes
5. **Audit Blindness**: Never disable logging for security workflows
