# Fern Claude Skills

Claude Code skills for building the Fern (FertilityConnect) Agentforce + MuleSoft demo — and any demo like it.

Each skill reads from a `fern-context.md` file in your project directory — a single config file that holds your industry, persona, company, API names, and branding. To build a demo for a new industry:

1. Run `/fern-design` with your industry, persona, and flow descriptions — Claude writes a populated `fern-context.md` to your project directory
2. Open `fern-context.md` and fill in the credential fields (`client_id`, `client_secret`, `business_group_id`, `org_alias`, `org_domain`)
3. Run each `/fern-*` skill in order — Claude reads `fern-context.md` automatically, no manual value replacement needed

The FertilityConnect values in each skill are a working reference example, not placeholders to edit.

> **Note:** `fern-context.md` is not included in this repo. It is generated in your Salesforce project directory when you run `/01-fern-design` and stays local — it contains credentials and org-specific values that should never be committed.

## Install

Run this one command in your terminal:

```bash
curl -s https://raw.githubusercontent.com/kellie-fontes/fern-claude-skills/main/install.sh | bash
```

Then open Claude Code and type `/` to see all skills listed.

## Skills

**Run this first — every session:**

| Command | What it does |
|---|---|
| `/00-fern-start` | Sets session context and ground rules — run once before anything else |

**Build steps — run in order:**

| Step | Command | What it does |
|---|---|---|
| 1 | `/01-fern-design` | Design the full architecture + write fern-context.md |
| 2 | `/02-fern-api` | Build the MuleSoft mock API in Anypoint Code Builder |
| 3 | `/03-fern-deploy` | Deploy the Mule app to CloudHub Sandbox |
| 4 | `/04-fern-wire` | Wire the MuleSoft API to Agentforce via External Service Registration |
| 5 | `/05-fern-agent` | Build the agent, wire actions in Agent Builder, grant permissions |
| 6 | `/06-fern-apex` | Build the Apex controllers, Custom Setting, and Remote Site Settings |
| 7 | `/07-fern-site` | Create the Experience Cloud site and branded chat LWC |
| 8 | `/08-fern-form` | Build the custom object, log form LWC, and real-time polling |
| 9 | `/09-fern-dashboard` | Build the internal dashboard via Visualforce + Lightning Out |

**Support commands:**

| Command | When to use |
|---|---|
| `/10-fern-debug` | When something breaks — real errors, real fixes |
| `/11-fern-prep` | Morning of every demo — token refresh + checklist |

## Prerequisites

**MuleSoft**
- Anypoint Platform account with a CloudHub Sandbox environment
- Anypoint Code Builder
- Anypoint Connected App with `client_credentials` grant

**Salesforce**
- Salesforce org with Agentforce (Einstein Agent) license activated
- Permissions to create LWCs, custom objects, external services, and named credentials
- Salesforce CLI (`sf`)

**Claude Code**
- Claude Code installed: `npm install -g @anthropic-ai/claude-code`
- MuleSoft MCP server configured (see below)

## MuleSoft MCP Server Setup

Add the following to `~/.claude.json` under `mcpServers`:

```json
"mulesoft": {
  "type": "stdio",
  "command": "/opt/homebrew/bin/npx",
  "args": ["-y", "@mulesoft/mcp-server", "start"],
  "env": {
    "ANYPOINT_CLIENT_ID": "[your-connected-app-client-id]",
    "ANYPOINT_CLIENT_SECRET": "[your-connected-app-client-secret]",
    "ANYPOINT_REGION": "PROD_US"
  }
}
```

Run `/mcp` in Claude Code to confirm it's connected.

## Built by
[@Kellie Fontes](https://github.com/kellie-fontes) — MuleSoft + Agentforce Better Together demo
