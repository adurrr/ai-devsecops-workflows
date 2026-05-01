<div align="center">

# AI-Assisted DevSecOps Workflows

[![Hugo](https://img.shields.io/badge/Hugo-0.155.0-FF4088?logo=hugo&logoColor=white)](https://gohugo.io/)
[![Docsy](https://img.shields.io/badge/Docsy-0.14.3-34A853?logo=google&logoColor=white)](https://www.docsy.dev/)
[![GitHub Pages](https://img.shields.io/badge/GitHub%20Pages-Live-222?logo=githubpages&logoColor=white)](https://adurrr.github.io/ai-devsecops-workflows/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](https://github.com/adurrr/ai-devsecops-workflows/pulls)

> A comprehensive guide to integrating LLM assistants into DevSecOps practices using **oh-my-opencode-slim**, **opencode-go**, and modern AI tooling.

[Documentation](https://adurrr.github.io/ai-devsecops-workflows/) &middot; [Contributing](./CONTRIBUTING.md) &middot; [License](./LICENSE)

</div>

---

## Overview

This repository documents approaches, paradigms, and best practices for DevSecOps engineers leveraging AI assistants in their daily workflows. It covers security-first integration patterns, framework comparisons, and practical implementation strategies.

## Documentation

Explore the full documentation at **[adurrr.github.io/ai-devsecops-workflows](https://adurrr.github.io/ai-devsecops-workflows/)**.

| Section | Description |
|---------|-------------|
| [Architecture](https://adurrr.github.io/ai-devsecops-workflows/docs/architecture/) | Core workflow patterns and system design |
| [Frameworks](https://adurrr.github.io/ai-devsecops-workflows/docs/frameworks/) | Comparison of LLM assistant frameworks |
| [Security](https://adurrr.github.io/ai-devsecops-workflows/docs/security/) | Security concerns, risks, and mitigation strategies |
| [Paradigms](https://adurrr.github.io/ai-devsecops-workflows/docs/paradigms/) | Different approaches to AI-assisted DevSecOps |
| [Use Cases](https://adurrr.github.io/ai-devsecops-workflows/docs/use-cases/) | Practical examples and patterns |
| [Secure PR Review](https://adurrr.github.io/ai-devsecops-workflows/docs/secure-pr-review/) | Pre-PR AI-assisted security review |
| [Research](https://adurrr.github.io/ai-devsecops-workflows/docs/research/) | Comprehensive research findings |

## Core Philosophy

### Security-First AI Integration

AI assistants in DevSecOps must follow **zero-trust principles**:

1. **Verify Before Execute**: All AI-generated commands require human review
2. **Least Privilege**: Scoped permissions per agent and task
3. **Audit Trail**: Complete logging of AI interactions
4. **Data Sovereignty**: Control what code/context leaves your environment

### The Three Paradigms

| Paradigm | Tools | Best For |
|----------|-------|----------|
| **Orchestrated Multi-Agent** | oh-my-opencode-slim | Complex, multi-step security workflows |
| **Single-Agent Pair Programming** | Aider, Claude Code | Focused development sessions, incident response |
| **CLI Command Generation** | ShellGPT, AIChat | Daily operations, troubleshooting, rapid prototyping |

## Key Decisions Matrix

| Scenario | Recommended Approach | Rationale |
|----------|---------------------|-----------|
| Security audit of entire codebase | Multi-Agent (Oracle + Explorer) | Comprehensive analysis with strategic oversight |
| Responding to security incident | Single-Agent Pair (Aider) | Focused, rapid response with context |
| Daily infrastructure tasks | CLI Generation (ShellGPT) | Fast, lightweight command assistance |
| Compliance documentation | Multi-Agent (Librarian + Council) | Research + consensus validation |
| IaC security review | Multi-Agent (Oracle + Fixer) | Deep analysis + automated fixes |

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
├── docs/                     # Source documentation (markdown)
├── docs-site/                # Hugo documentation site
│   ├── config/               # Hugo configuration
│   ├── content/              # Site content
│   └── ...
├── configs/                  # Ready-to-use configuration templates
│   ├── oh-my-opencode-slim/  # Multi-agent configurations
│   ├── shellgpt/             # ShellGPT roles and configs
│   └── security-policies/    # Permission templates
└── examples/                 # Practical examples
    ├── developer-security/   # Pre-PR security review workflow
    ├── incident-response/    # Security incident workflows
    ├── iac-scanning/         # Infrastructure as Code security
    └── pipeline-security/    # CI/CD security patterns
```

## Contributing

This is a living document. Contributions welcome for:
- New framework comparisons
- Additional security patterns
- Real-world case studies
- Configuration improvements

See [CONTRIBUTING.md](./CONTRIBUTING.md) for guidelines.

## License

MIT - See [LICENSE](./LICENSE) for details.

## Further Reading

- [OpenCode/Crush Documentation](https://github.com/charmbracelet/crush)
- [oh-my-opencode-slim Repository](https://github.com/alvinunreal/oh-my-opencode-slim)
- [OWASP LLM Top 10](https://owasp.org/www-project-top-10-for-large-language-model-applications/)
- [NIST AI Risk Management Framework](https://www.nist.gov/itl/ai-risk-management-framework)
