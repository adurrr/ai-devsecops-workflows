# LLM Assistant Frameworks: Comprehensive Comparison

## Executive Summary

| Framework | Type | Best For | Learning Curve | Cost Control |
|-----------|------|----------|----------------|--------------|
| **oh-my-opencode-slim** | Multi-agent orchestration | Complex DevSecOps workflows | Medium | Excellent |
| **Aider** | Pair programming | Focused coding sessions | Low | Good |
| **ShellGPT** | CLI command generation | Daily operations | Low | Good |
| **AIChat** | General-purpose LLM CLI | Multi-provider flexibility | Medium | Good |
| **Claude Code** | Terminal coding agent | Deep reasoning tasks | Low | Moderate |
| **Crush** (ex-OpenCode) | Terminal AI platform | Full development workflows | Medium | Good |

## Detailed Framework Analysis

### 1. oh-my-opencode-slim

**Repository**: [alvinunreal/oh-my-opencode-slim](https://github.com/alvinunreal/oh-my-opencode-slim)  
**License**: MIT  
**Language**: TypeScript

#### Core Concept
Agent orchestration plugin that routes tasks to specialized AI agents ("The Pantheon"), optimizing for quality, speed, and cost.

#### The Pantheon Agents

| Agent | Default Model | Purpose | Speed | Cost |
|-------|--------------|---------|-------|------|
| Orchestrator | GPT-5.4 | Master delegator & coordinator | Medium | Medium |
| Explorer | GPT-5.4-mini | Codebase reconnaissance | Fast | Low |
| Oracle | GPT-5.4 (high) | Strategic advisor, architecture | Slow | High |
| Council | Config-driven | Multi-LLM consensus | Slow | High |
| Librarian | GPT-5.4-mini | External documentation lookup | Fast | Low |
| Designer | GPT-5.4-mini | UI/UX implementation | Medium | Low |
| Fixer | Various | Fast implementation | Fast | Low |

#### DevSecOps Strengths
- **Specialized security analysis**: Oracle for architecture review, Explorer for attack surface mapping
- **Cost optimization**: Use cheap models for scouting, expensive for critical decisions
- **Multi-model validation**: Council mode for high-stakes security decisions
- **Audit trail**: Complete delegation logs

#### DevSecOps Weaknesses
- **Complexity**: Overhead for simple tasks
- **Dependencies**: Requires OpenCode/Crush base installation
- **Learning curve**: Understanding agent specialization takes time

#### Installation
```bash
bunx oh-my-opencode-slim@latest install
# Config: ~/.config/opencode/oh-my-opencode-slim.json
```

---

### 2. Aider

**Repository**: [paul-gauthier/aider](https://github.com/paul-gauthier/aider)  
**License**: Apache-2.0  
**Language**: Python

#### Core Concept
AI pair programming in the terminal with automatic git integration and codebase awareness.

#### Key Features
- **Automatic repomap**: Understands entire codebase structure
- **Git integration**: Auto-commits with sensible messages
- **Lint/test integration**: Validates changes automatically
- **Voice-to-code**: Speak commands instead of typing

#### DevSecOps Strengths
- **Focused sessions**: Ideal for incident response
- **Codebase context**: Automatically understands project structure
- **Safe by default**: Git integration allows easy rollback
- **Voice commands**: Hands-free during critical incidents

#### DevSecOps Weaknesses
- **Single-threaded**: No parallel agent capabilities
- **Limited research**: No built-in external documentation lookup
- **Provider limits**: Primarily OpenAI/Anthropic focused

#### Installation
```bash
pip install aider-chat
```

#### Usage Example
```bash
aider --model gpt-5.4 --security-mode strict
# Inside aider:
> Review this Terraform configuration for security issues
> Fix the S3 bucket public access vulnerability
```

---

### 3. ShellGPT (sgpt)

**Repository**: [TheR1D/shell_gpt](https://github.com/TheR1D/shell_gpt)  
**License**: MIT  
**Language**: Python

#### Core Concept
Generate and execute shell commands from natural language descriptions.

#### Key Features
- **Shell integration**: `Ctrl+L` hotkey for instant access
- **REPL mode**: Interactive command generation
- **Function calling**: Execute shell commands via LLM
- **Role system**: Predefined personas for different tasks

#### DevSecOps Strengths
- **Speed**: Fastest for one-off commands
- **Operations focus**: Built for infrastructure tasks
- **Role templates**: Create security-specific personas
- **Log analysis**: Pipe logs directly for AI analysis

#### DevSecOps Weaknesses
- **Security risk**: Command execution can be dangerous
- **No context**: No codebase awareness
- **Limited analysis**: Not suitable for deep security reviews

#### Installation
```bash
pip install shell-gpt
```

#### Security Role Example
```bash
# Create security auditor role
sgpt --create-role security_auditor
# Prompt: "You are a security-focused DevOps engineer. Review commands for security implications before suggesting."

# Usage
sgpt --role security_auditor "analyze these logs for security issues" < auth.log
```

---

### 4. AIChat

**Repository**: [sigoden/aichat](https://github.com/sigoden/aichat)  
**License**: MIT/Apache-2.0  
**Language**: Rust

#### Core Concept
All-in-one LLM CLI supporting 20+ providers with built-in RAG and agents.

#### Key Features
- **Multi-provider**: OpenAI, Anthropic, Google, local models, etc.
- **RAG system**: Built-in document retrieval
- **Agents**: Prompt + Tools + RAG docs
- **HTTP server**: Built-in API and playground
- **Arena mode**: Compare multiple models side-by-side

#### DevSecOps Strengths
- **Provider flexibility**: Use cheapest/most secure provider per task
- **RAG integration**: Query security documentation
- **Arena mode**: Compare model outputs for security decisions
- **Server mode**: Integrate with existing tools

#### DevSecOps Weaknesses
- **Complexity**: Many features can be overwhelming
- **Configuration**: Requires more setup than simpler tools
- **Documentation**: RAG setup needs maintenance

#### Installation
```bash
curl -fsSL https://raw.githubusercontent.com/sigoden/aichat/main/install.sh | sh
```

#### Security Agent Example
```yaml
# ~/.config/aichat/agents/security-analyst.yaml
name: security-analyst
description: Security-focused code and infrastructure reviewer
tools:
  - fs_cat
  - fs_ls
document_sets:
  - owasp-top10
  - nist-framework
prompt: |
  You are a senior security analyst. Review all code and configurations
  for security vulnerabilities. Follow OWASP guidelines and provide
  specific remediation steps.
```

---

### 5. Claude Code

**Provider**: Anthropic  
**Access**: Limited beta

#### Core Concept
Terminal-based coding agent with deep reasoning capabilities, native to Claude models.

#### Key Features
- **Deep reasoning**: Superior at complex problem-solving
- **Codebase understanding**: Natural language codebase navigation
- **Tool use**: Can invoke external tools
- **Safety focus**: Anthropic's constitutional AI principles

#### DevSecOps Strengths
- **Reasoning**: Best for complex security architecture decisions
- **Safety**: Built-in harmlessness training
- **Context**: Handles large codebases well

#### DevSecOps Weaknesses
- **Vendor lock-in**: Only Claude models
- **Cost**: Can be expensive for large sessions
- **Limited availability**: Beta access required

#### Usage
```bash
claude code
# Interactive session with natural language commands
```

---

### 6. Crush (formerly OpenCode)

**Repository**: [charmbracelet/crush](https://github.com/charmbracelet/crush)  
**License**: MIT  
**Language**: Go

#### Core Concept
Terminal AI coding agent from Charm, with beautiful TUI and session management.

#### Key Features
- **Charm ecosystem**: Beautiful terminal UI (Bubble Tea)
- **LSP integration**: Language server protocol support
- **MCP support**: Model context protocol
- **Session management**: Persistent conversations
- **Permission system**: Granular tool permissions

#### DevSecOps Strengths
- **UI**: Best-in-class terminal interface
- **LSP**: IDE-level code intelligence
- **Permissions**: Fine-grained security controls
- **Extensibility**: MCP ecosystem

#### DevSecOps Weaknesses
- **Early stage**: Evolving rapidly, API may change
- **Go ecosystem**: Primarily targets Go development
- **Resource usage**: TUI can be resource-intensive

#### Installation
```bash
go install github.com/charmbracelet/crush@latest
```

---

## Framework Decision Matrix

### By Use Case

| Use Case | Primary | Secondary | Avoid |
|----------|---------|-----------|-------|
| **Security audit** | oh-my-opencode-slim | Aider | ShellGPT |
| **Incident response** | Aider | Claude Code | - |
| **Daily operations** | ShellGPT | AIChat | - |
| **Compliance docs** | oh-my-opencode-slim | AIChat | - |
| **IaC security** | oh-my-opencode-slim | Aider | - |
| **Threat research** | AIChat | oh-my-opencode-slim | - |
| **Code review** | Aider | Claude Code | ShellGPT |
| **Quick commands** | ShellGPT | - | oh-my-opencode-slim |

### By Team Size

| Team Size | Recommended | Rationale |
|-----------|-------------|-----------|
| **Solo** | ShellGPT + Aider | Simple, effective, cost-efficient |
| **Small (2-5)** | oh-my-opencode-slim | Shared configs, specialized roles |
| **Medium (5-20)** | oh-my-opencode-slim + AIChat | Flexibility + standardization |
| **Enterprise (20+)** | Custom + Council mode | Governance + audit requirements |

### By Security Posture

| Posture | Framework | Configuration |
|---------|-----------|---------------|
| **Paranoid** | AIChat + Local models | Ollama/LM Studio backend |
| **Prudent** | oh-my-opencode-slim | Council mode for critical changes |
| **Balanced** | Aider | Git integration for rollback |
| **Fast** | ShellGPT | Review mode enabled |

## Cost Comparison (Estimated)

### Per 1000 Tasks

| Framework | Low Complexity | Medium | High | Notes |
|-----------|---------------|--------|------|-------|
| **oh-my-opencode-slim** | $5-10 | $15-30 | $50-100 | Smart routing saves costs |
| **Aider** | $10-20 | $30-60 | $100-200 | Consistent model usage |
| **ShellGPT** | $1-5 | $5-15 | N/A | Best for simple tasks |
| **AIChat** | $5-15 | $20-50 | $80-150 | Depends on provider |
| **Claude Code** | $15-30 | $50-100 | $200-400 | Premium pricing |

*Estimates based on GPT-4/Claude 3.5 Sonnet equivalent pricing

## Migration Paths

### From ShellGPT to Multi-Agent

```bash
# Phase 1: Add roles
sgpt --create-role security_auditor
sgpt --create-role terraform_expert

# Phase 2: Introduce Aider for coding
pip install aider-chat

# Phase 3: Full multi-agent
bunx oh-my-opencode-slim@latest install
```

### Consolidating Tools

```bash
# Centralized configuration repository
git clone https://github.com/org/ai-assistant-configs
cd ai-assistant-configs

# Install all tools with shared configs
make install-all
# - Installs oh-my-opencode-slim
# - Sets up ShellGPT with security roles
# - Configures AIChat with org-wide agents
```

## Future Considerations

### Emerging Trends

1. **Model Context Protocol (MCP)**: Standardizing AI tool integration
2. **Local-first**: Growing adoption of local models for privacy
3. **Agent marketplaces**: Pre-built agents for specific domains
4. **Audit automation**: Built-in compliance and governance features

### Watch List

- **GitHub Copilot Workspace**: Full repo understanding
- **Amazon CodeWhisperer**: Enterprise security scanning
- **Continue.dev**: Open-source IDE integration
- **Supermaven**: Fast completions
