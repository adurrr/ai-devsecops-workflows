---
title: "AI-Assisted DevSecOps Workflows"
linkTitle: "Home"
weight: 1
---

{{< blocks/cover title="AI-Assisted DevSecOps Workflows" image_anchor="top" height="small" color="primary" >}}
<div class="mx-auto">
  <p class="h5 mt-3 mb-4">Integrating LLM assistants into security-first DevSecOps practices</p>
  <p class="lead mt-3">A comprehensive guide to using oh-my-opencode-slim, opencode-go, and modern AI tooling in your DevSecOps workflows.</p>
  <a class="btn btn-lg btn-secondary me-3 mb-4" href="{{< relref "docs" >}}">
    Get Started <i class="fas fa-arrow-alt-circle-right ms-2"></i>
  </a>
  <a class="btn btn-lg btn-light me-3 mb-4" href="https://github.com/adurrr/ai-devsecops-workflows">
    View on GitHub <i class="fab fa-github ms-2"></i>
  </a>
  <p class="lead mt-3">Explore patterns for security audits, incident response, compliance automation, and more.</p>
</div>
{{< /blocks/cover >}}

{{< blocks/lead color="secondary" >}}
This site documents approaches, paradigms, and best practices for DevSecOps engineers leveraging AI assistants. It covers security-first integration patterns, framework comparisons, and practical implementation strategies.
{{< /blocks/lead >}}

{{< blocks/section color="white" type="container" >}}
<div class="row text-center">
  {{< blocks/feature icon="fa-sitemap" title="Architecture" url="docs/architecture" >}}
  Core workflow patterns, agent responsibilities, and integration architecture for AI-assisted DevSecOps.
  {{< /blocks/feature >}}

  {{< blocks/feature icon="fa-layer-group" title="Frameworks" url="docs/frameworks" >}}
  Detailed comparison of oh-my-opencode-slim, Aider, ShellGPT, AIChat, Claude Code, and Crush.
  {{< /blocks/feature >}}

  {{< blocks/feature icon="fa-shield-halved" title="Security" url="docs/security" >}}
  Threat model, critical controls, compliance considerations, and hardening guides for AI-assisted workflows.
  {{< /blocks/feature >}}
</div>

<div class="row text-center mt-5">
  {{< blocks/feature icon="fa-code-branch" title="Paradigms" url="docs/paradigms" >}}
  Three primary approaches: Orchestrated Multi-Agent, Single-Agent Pair Programming, and CLI Command Generation.
  {{< /blocks/feature >}}

  {{< blocks/feature icon="fa-briefcase" title="Use Cases" url="docs/use-cases" >}}
  Practical patterns for incident response, IaC security, secret management, compliance, container security, and CI/CD.
  {{< /blocks/feature >}}

  {{< blocks/feature icon="fa-magnifying-glass" title="Research" url="docs/research" >}}
  Comprehensive research findings: framework landscape, cost analysis, and implementation recommendations.
  {{< /blocks/feature >}}
</div>
{{< /blocks/section >}}

{{< blocks/section color="dark" type="container" >}}
<div class="row justify-content-center">
  <div class="col-lg-8 text-center">
    <h2 class="text-white">Secure PR Review Workflow</h2>
    <p class="text-white lead">Run a 5-step AI-assisted security review over your branch changes before they reach code review.</p>
    <a class="btn btn-lg btn-primary mt-3" href="{{< relref "docs/secure-pr-review" >}}">
      Learn the Workflow <i class="fas fa-arrow-right ms-2"></i>
    </a>
  </div>
</div>
{{< /blocks/section >}}

{{< blocks/section color="primary" type="container" >}}
<div class="row justify-content-center">
  <div class="col-lg-8 text-center">
    <h2 class="text-white">Contributing</h2>
    <p class="text-white lead">This is a living document. Contributions are welcome for new framework comparisons, security patterns, case studies, and configuration improvements.</p>
    <a class="btn btn-lg btn-light mt-3" href="https://github.com/adurrr/ai-devsecops-workflows">
      Contribute on GitHub <i class="fab fa-github ms-2"></i>
    </a>
  </div>
</div>
{{< /blocks/section >}}
