---
title: "AI-Assisted DevSecOps Workflows"
linkTitle: "Home"
weight: 1
---

# AI-Assisted DevSecOps Workflows

> A comprehensive guide to integrating LLM assistants into DevSecOps practices using oh-my-opencode-slim, opencode-go, and modern AI tooling.

## What This Is

This site documents approaches, paradigms, and best practices for DevSecOps engineers leveraging AI assistants in their daily workflows. It covers security-first integration patterns, framework comparisons, and practical implementation strategies.

## Quick Navigation

| Section | Description |
|---------|-------------|
| [Architecture](docs/architecture) | Core workflow patterns and system design |
| [Frameworks](docs/frameworks) | Comparison of LLM assistant frameworks |
| [Security](docs/security) | Security concerns, risks, and mitigation strategies |
| [Paradigms](docs/paradigms) | Different approaches to AI-assisted DevSecOps |
| [Use Cases](docs/use-cases) | Practical examples and patterns |
| [Secure PR Review](docs/secure-pr-review) | Pre-PR AI-assisted security review |
| [Research](docs/research) | Comprehensive research findings |

## Core Philosophy

### Security-First AI Integration

AI assistants in DevSecOps must follow **zero-trust principles**:

1. **Verify Before Execute**: All AI-generated commands require human review
2. **Least Privilege**: Scoped permissions per agent and task
3. **Audit Trail**: Complete logging of AI interactions
4. **Data Sovereignty**: Control what code/context leaves your environment

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

## Contributing

This is a living document. Contributions welcome for:
- New framework comparisons
- Additional security patterns
- Real-world case studies
- Configuration improvements

## License

MIT
