# Diagram Improvement Plan

## Current State

All diagrams in the documentation are ASCII art blocks. Examples:
- Agent pantheon hierarchy in `architecture.md`
- Workflow patterns (Continuous Security, Incident Response, Compliance)
- Integration architecture diagrams
- Threat model diagrams in `security.md`
- Paradigm architecture in `paradigms.md`

## Proposed Improvements

### Phase 1: Mermaid Diagrams (Immediate)

Docsy v0.14.3 supports **Mermaid** natively. Add this to `hugo.toml`:

```toml
[params]
  [params.mermaid]
    enable = true
    theme = "default"
```

Then convert ASCII diagrams to Mermaid syntax:

**Example: Agent Pantheon (architecture.md)**
```markdown
{{< mermaid >}}
graph TD
    A[Orchestrator] --> B[Explorer]
    A --> C[Librarian]
    A --> D[Oracle]
    A --> E[Fixer]
    A --> F[Designer]
    A --> G[Council]
    
    B --> B1[Codebase Mapping]
    C --> C1[External Research]
    D --> D1[Strategic Architecture]
    E --> E1[Implementation Tasks]
    F --> F1[UI/UX Polish]
    G --> G1[Multi-model Consensus]
{{< /mermaid >}}
```

**Example: Continuous Security Workflow (architecture.md)**
```markdown
{{< mermaid >}}
graph LR
    Trigger[Code Push / Schedule] --> Explorer[1. Explorer<br/>Map codebase changes]
    Explorer --> Oracle[2. Oracle<br/>Assess risk]
    Oracle --> Librarian[3. Librarian<br/>Research threats]
    Librarian --> Fixer[4. Fixer<br/>Auto-remediate]
    Fixer --> Council[5. Council<br/>Validate changes]
{{< /mermaid >}}
```

**Example: Threat Model (security.md)**
```markdown
{{< mermaid >}}
graph LR
    UserInput[User Input] --> LocalFilter[Local Filter]
    LocalFilter --> AI[AI Assistant]
    AI --> Sanitization[Local Sanitization]
    Sanitization --> Output[Output]
    
    LocalFilter --> Gitignore[.gitignore Patterns<br/>PII Filter]
    Sanitization --> Review[Command Review<br/>Human in Loop]
{{< /mermaid >}}
```

### Phase 2: AI-Generated Visual Diagrams (Next)

For more polished, human-style diagrams:

1. **Use Claude/DALL-E/Stable Diffusion** to generate:
   - Isometric architecture diagrams
   - Security workflow illustrations
   - Agent relationship visualizations
   
2. **Prompt template for AI image generation:**
   ```
   Create a professional, clean isometric diagram showing a DevSecOps 
   workflow with 6 AI agents (Orchestrator, Explorer, Librarian, Oracle, 
   Fixer, Designer, Council) connected by arrows. Dark theme with blue 
   and green accents. Include security shield icons. Flat design style, 
   vector-like, transparent background, 1920x1080.
   ```

3. **Store generated images** in `docs-site/assets/images/diagrams/`

4. **Reference in content:**
   ```markdown
   ![Agent Pantheon Architecture](/images/diagrams/agent-pantheon.png)
   ```

### Phase 3: Interactive Diagrams (Future)

- Use Mermaid's interactive features (clickable nodes)
- Add hover tooltips with additional info
- Consider Excalidraw-style hand-drawn diagrams for a more human feel

## Implementation Priority

| Priority | File | Diagrams to Convert | Type |
|----------|------|---------------------|------|
| P0 | architecture.md | Agent pantheon, 3 workflows, integration arch | Mermaid |
| P0 | security.md | Threat model, data flow | Mermaid |
| P1 | paradigms.md | 3 paradigm architectures | Mermaid |
| P1 | use-cases.md | Workflow patterns | Mermaid |
| P2 | All | Replace with AI-generated visuals | Images |

## Mermaid Configuration

Add to `config/_default/hugo.toml`:

```toml
[params]
  [params.mermaid]
    enable = true
    theme = "default"
    # Optional: custom styling
    [params.mermaid.flowchart]
      useMaxWidth = true
```

## Benefits

1. **Human-readable**: Mermaid renders as clean SVG, not monospace ASCII
2. **Accessible**: Screen readers can parse Mermaid structure
3. **Responsive**: SVG scales to any screen size
4. **Dark mode compatible**: Mermaid auto-adjusts colors with Docsy theme
5. **Editable**: Plain text syntax, easy to update
6. **Searchable**: Content in Mermaid is indexable by search engines

## Example Conversion

**Before (ASCII):**
```
┌──────────────┐
│ Orchestrator │
└──────┬───────┘
       │
  ┌────┴────┐
  ▼         ▼
Explorer  Oracle
```

**After (Mermaid):**
```markdown
{{< mermaid >}}
graph TD
    Orchestrator --> Explorer
    Orchestrator --> Oracle
    
    style Orchestrator fill:#4a90d9,stroke:#333,stroke-width:2px,color:#fff
    style Explorer fill:#5cb85c,stroke:#333,stroke-width:2px,color:#fff
    style Oracle fill:#f0ad4e,stroke:#333,stroke-width:2px,color:#fff
{{< /mermaid >}}
```

This renders as a clean, styled flowchart that adapts to light/dark mode.
