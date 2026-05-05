# About AI-Assisted DevSecOps Workflows

## What This Is

**AI-Assisted DevSecOps Workflows** is a field guide for teams who want to use large language models to move faster without breaking things. It collects real-world patterns, agent configurations, and guardrails that we have found actually work in production environments where security matters.

The focus is not on hype. It is on practical integration: how to route a security audit through multiple specialized agents, how to keep secrets out of prompts, how to avoid spending frontier-model money on tasks that a cheap model can handle just as well.

## Why We Built This

Most teams hit the same wall. They start using AI assistants for coding or operations, see immediate speed gains, and then run into one of several problems. A generated Terraform plan opens a security group to the world. A prompt injection surfaces sensitive context to an external API. A CI pipeline starts running untrusted commands because an agent suggested them. Costs spiral because every task gets sent to the most expensive model available.

This repository exists because we needed a single place that treated those problems as first-class concerns rather than footnotes. Every workflow here assumes that AI output is a suggestion that requires human validation, that secrets belong in vaults and not in prompts, and that the right model for the job is usually the cheapest one that can do it reliably.

## Who This Helps

| Role | What You Will Find Here |
|------|------------------------|
| **DevSecOps Engineers** | Ready-to-run workflows for security audits, incident response, and compliance checks using specialized agents |
| **Platform Engineers** | Patterns for wiring AI agents into internal developer platforms without creating shadow infrastructure |
| **Security Architects** | Threat models, permission matrices, and risk frameworks built specifically for AI-assisted tooling |
| **SREs and Infrastructure Teams** | Concrete examples for IaC scanning, container hardening, and observability integration |
| **Development Teams** | Secure coding practices, pre-PR security reviews, and dependency management strategies |

## How We Think About This

**Security is not a checkbox.** Every workflow documented here treats it as a property of the system, not a phase in the process. Agents run under strict permission boundaries. Destructive operations require explicit human approval. If a workflow cannot be audited, it does not belong in production.

**Verify before you execute.** AI-generated commands, configurations, and fixes are starting points. They are not facts. Every output gets reviewed before it touches infrastructure or sensitive code. The repository includes guardrails and approval gates to make that review systematic rather than optional.

**Match the model to the stakes.** Not every task needs a frontier model. Routine reconnaissance and file mapping run fine on fast, cheap models. Strategic architecture reviews and incident containment plans benefit from deeper reasoning. The workflows here route tasks intelligently, which typically cuts AI spend by sixty to eighty percent for day-to-day operations.

**If you cannot audit it, you cannot trust it.** Complete logging of agent interactions, tool invocations, and file accesses is mandatory. Every decision should be reconstructible after the fact.

## What Sets This Apart

Generic AI coding tutorials treat security as an afterthought. This repository is built for environments where a misconfiguration or a leaked secret has real consequences. The content includes granular permission matrices for agents, predefined security workflows mapped to specific agent capabilities, MCP integrations that let agents interact with tools directly instead of copying and pasting through chat windows, and guidance that works across multiple frameworks rather than locking you into one vendor.

## Repository Layout

```
.
├── docs/                     # Plain markdown for GitHub browsing
├── docs-site/                # Hugo site with search and navigation
├── configs/                  # Ready-to-use agent and policy configurations
│   ├── oh-my-opencode-slim/  # Multi-agent orchestration configs
│   ├── shellgpt/             # ShellGPT roles and templates
│   └── security-policies/    # Permission and policy templates
└── examples/                 # Working examples you can run
    ├── developer-security/   # Pre-PR security review scripts
    ├── incident-response/    # Incident response playbooks
    ├── iac-scanning/         # Terraform and CloudFormation scanners
    └── pipeline-security/    # CI/CD security gate examples
```

## License and Contributing

This project is released under the [MIT License](https://github.com/adurrr/ai-devsecops-workflows/blob/main/LICENSE).

If you want to contribute, open an issue or pull request. See [Contributing](https://github.com/adurrr/ai-devsecops-workflows/blob/main/CONTRIBUTING.md) for the details on reporting bugs, adding documentation, and submitting changes.

---

*Last updated: May 2026*
