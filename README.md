# AI-Assisted DevSecOps Workflows

> A comprehensive guide to integrating LLM assistants into DevSecOps practices using oh-my-opencode-slim, opencode-go, and modern AI tooling.

## Overview

This repository documents approaches, paradigms, and best practices for DevSecOps engineers leveraging AI assistants in their daily workflows. It covers security-first integration patterns, framework comparisons, and practical implementation strategies.

## Quick Navigation

| Section | Description |
|---------|-------------|
| [Architecture](./docs/architecture.md) | Core workflow patterns and system design |
| [Frameworks](./docs/frameworks.md) | Comparison of LLM assistant frameworks |
| [Security](./docs/security.md) | Security concerns, risks, and mitigation strategies |
| [Paradigms](./docs/paradigms.md) | Different approaches to AI-assisted DevSecOps |
| [Configurations](./configs/) | Ready-to-use configuration templates |
| [Use Cases](./docs/use-cases.md) | Practical examples and patterns |

## Core Philosophy

### Security-First AI Integration

AI assistants in DevSecOps must follow **zero-trust principles**:

1. **Verify Before Execute**: All AI-generated commands require human review
2. **Least Privilege**: Scoped permissions per agent and task
3. **Audit Trail**: Complete logging of AI interactions
4. **Data Sovereignty**: Control what code/context leaves your environment

### The Three Paradigms

This repository explores three primary approaches to AI-assisted DevSecOps:

#### 1. **Orchestrated Multi-Agent** (oh-my-opencode-slim)
Specialized agents for different tasks (Explorer, Oracle, Librarian, Fixer, Designer, Council)

**Best for**: Complex, multi-step security workflows requiring diverse expertise

#### 2. **Single-Agent Pair Programming** (Aider, Claude Code)
One AI assistant working alongside the engineer with deep codebase context

**Best for**: Focused development sessions, incident response

#### 3. **CLI Command Generation** (ShellGPT, AIChat)
Quick shell commands and one-off queries from natural language

**Best for**: Daily operations, troubleshooting, rapid prototyping

## Getting Started

### Prerequisites

- Terminal with modern shell (zsh/bash/fish)
- API keys for LLM providers (or local models via Ollama)
- Git and basic DevSecOps tooling

### Installation Options

**Option 1: Full Multi-Agent Setup (Recommended for Teams)**
```bash
# Install oh-my-opencode-slim on top of opencode-go/crush
bunx oh-my-opencode-slim@latest install
```

**Option 2: Lightweight CLI (Individual Contributors)**
```bash
# ShellGPT for command generation
pip install shell-gpt

# Or AIChat for general-purpose LLM CLI
curl -fsSL https://raw.githubusercontent.com/sigoden/aichat/main/install.sh | sh
```

**Option 3: Pair Programming**
```bash
# Aider for focused coding sessions
pip install aider-chat
```

## Repository Structure

```
.
├── README.md                 # This file
├── docs/
│   ├── architecture.md       # System design patterns
│   ├── frameworks.md         # Framework comparison matrix
│   ├── security.md           # Security guide
│   ├── paradigms.md          # Approach comparison
│   └── use-cases.md          # Practical examples
├── configs/
│   ├── oh-my-opencode-slim/  # Multi-agent configurations
│   ├── shellgpt/             # ShellGPT roles and configs
│   └── security-policies/    # Permission templates
└── examples/
    ├── incident-response/    # Security incident workflows
    ├── iac-scanning/         # Infrastructure as Code security
    └── pipeline-security/    # CI/CD security patterns
```

## Key Decisions Matrix

| Scenario | Recommended Approach | Rationale |
|----------|---------------------|-----------|
| Security audit of entire codebase | Multi-Agent (Oracle + Explorer) | Comprehensive analysis with strategic oversight |
| Responding to security incident | Single-Agent Pair (Aider) | Focused, rapid response with context |
| Daily infrastructure tasks | CLI Generation (ShellGPT) | Fast, lightweight command assistance |
| Compliance documentation | Multi-Agent (Librarian + Council) | Research + consensus validation |
| IaC security review | Multi-Agent (Oracle + Fixer) | Deep analysis + automated fixes |

## Contributing

This is a living document. Contributions welcome for:
- New framework comparisons
- Additional security patterns
- Real-world case studies
- Configuration improvements

## License

MIT - See [LICENSE](./LICENSE) for details

## Further Reading

- [OpenCode/Crush Documentation](https://github.com/charmbracelet/crush)
- [oh-my-opencode-slim Repository](https://github.com/alvinunreal/oh-my-opencode-slim)
- [OWASP LLM Top 10](https://owasp.org/www-project-top-10-for-large-language-model-applications/)
- [NIST AI Risk Management Framework](https://www.nist.gov/itl/ai-risk-management-framework)
