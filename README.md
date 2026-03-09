# Salesforce Skills for VS Code + GitHub Copilot

A collection of **52 instruction files** for GitHub Copilot in VS Code, enabling AI-powered Salesforce development across the entire platform.

## How It Works

GitHub Copilot supports project-level instructions via `.github/instructions/*.md` files. Each instruction file has YAML frontmatter with a `description` and optional `applyWhen` glob pattern. Copilot automatically activates relevant instructions based on the files you're editing.

## Installation

### Windows (PowerShell)

```powershell
# Install all instructions to current project
.\install.ps1

# List available instructions
.\install.ps1 -List

# Install specific instructions only
.\install.ps1 -Skills sf-apex,sf-lwc,sf-flow

# Uninstall all instructions from current project
.\install.ps1 -Uninstall
```

### macOS / Linux (Bash)

```bash
# Install all instructions to current project
./install.sh

# List available instructions
./install.sh --list

# Install specific instructions only
./install.sh --skills sf-apex,sf-lwc,sf-flow

# Uninstall all instructions from current project
./install.sh --uninstall
```

## What Gets Installed

```
your-salesforce-project/
└── .github/
    ├── copilot-instructions.md          # Global Salesforce conventions
    └── instructions/
        ├── sf-apex.md                   # Auto-activates on *.cls, *.trigger
        ├── sf-lwc.md                    # Auto-activates on lwc/**/*.js, lwc/**/*.html
        ├── sf-flow.md                   # Auto-activates on *.flow-meta.xml
        ├── sf-soql.md                   # Auto-activates on *.soql
        └── ... (52 instruction files)
```

Instructions with `applyWhen` patterns activate automatically when you edit matching files. Others are available for Copilot to reference based on your prompts.

## Available Instructions (52)

### Development
sf-apex, sf-flow, sf-lwc, sf-soql

### Quality & Review
sf-testing, sf-debug, sf-code-review, sf-performance

### Foundation
sf-metadata, sf-data, sf-permissions, sf-formula, sf-security, sf-custom-metadata, sf-file-management

### Automation
sf-approval, sf-email, sf-automation-strategy

### Advanced Apex
sf-async-patterns, sf-api-design

### Data Quality
sf-duplicate-management, sf-migration

### Integration
sf-connected-apps, sf-integration, sf-mulesoft, sf-slack

### AI & Agentforce
sf-ai-agentforce, sf-ai-agentforce-persona, sf-ai-agentforce-testing, sf-ai-agentforce-observability, sf-ai-agentscript

### DevOps & Tooling
sf-deploy, sf-package, sf-devhub, sf-diagram-mermaid, sf-reporting

### Monitoring
sf-event-monitoring, sf-crm-analytics

### Legacy & Migration
sf-aura, sf-visualforce

### Clouds
sf-cloud-sales, sf-cloud-service, sf-experience-cloud, sf-field-service, sf-commerce

### Products
sf-data-cloud, sf-omnistudio, sf-cpq

### Marketing
sf-marketing-cloud

### Industries
sf-industry-health, sf-industry-finserv, sf-nonprofit

## Prerequisites

- **VS Code** with GitHub Copilot extension
- **Salesforce CLI v2** (`sf`) — `npm install -g @salesforce/cli`
- **Authenticated Salesforce Org**
- **sfdx-project.json** — Standard DX project structure

## License

MIT
