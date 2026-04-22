# Contributing to AI-Assisted DevSecOps Workflows

We welcome contributions from the DevSecOps community! This document provides guidelines for contributing to this repository.

## How to Contribute

### Reporting Issues

- Use the GitHub issue tracker
- Describe the issue clearly with steps to reproduce
- Include environment details (OS, tool versions)
- Tag with appropriate labels (bug, enhancement, documentation)

### Adding New Content

#### Documentation
- Place in appropriate `/docs/` subdirectory
- Follow existing markdown formatting
- Include code examples where applicable
- Cite sources for security recommendations

#### Configuration Examples
- Add to `/configs/` with clear naming
- Include comments explaining security choices
- Test configurations before submitting
- Document any prerequisites

#### Use Case Examples
- Add to `/examples/` subdirectory
- Include README explaining the workflow
- Provide working scripts/commands
- Note any required tools or setup

### Code Style

- Shell scripts: Use `shellcheck` compliance
- YAML: Validated syntax, 2-space indentation
- JSON: Validated, sorted keys preferred
- Markdown: Standard formatting, maximum 120 chars/line

### Security Considerations

All contributions must:
- Follow least privilege principles
- Avoid hardcoded secrets
- Include appropriate warnings for dangerous operations
- Respect data privacy guidelines

### Review Process

1. Submit PR with clear description
2. Automated checks must pass
3. Maintainer review (typically 3-5 days)
4. Address feedback
5. Merge upon approval

## Development Setup

```bash
# Clone repository
git clone https://github.com/your-org/ai-devsecops-workflows.git
cd ai-devsecops-workflows

# Install pre-commit hooks
pre-commit install

# Validate configurations
./scripts/validate-configs.sh
```

## Questions?

- Open a GitHub Discussion for general questions
- Join our community Slack (link in README)
- Contact maintainers: devsecops@example.com

## Code of Conduct

- Be respectful and professional
- Focus on constructive feedback
- Welcome newcomers
- Credit original authors

Thank you for contributing to better DevSecOps practices!
