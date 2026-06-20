# Fern Claude Skills

Claude Code skills for building the Fern (FertilityConnect) Agentforce + MuleSoft demo — and any demo like it.

Each skill reads from a `fern-context.md` file in your project directory — a single config file that holds your industry, persona, company, API names, and branding. To build a demo for a new industry:

1. Run `/fern-kickoff` with your industry, persona, and flow descriptions — Claude writes a populated `fern-context.md` to your project directory
2. Open `fern-context.md` and fill in the credential fields (`client_id`, `client_secret`, `business_group_id`, `org_alias`, `org_domain`)
3. Run each `/fern-*` skill in order — Claude reads `fern-context.md` automatically, no manual value replacement needed

The FertilityConnect values in each skill are a working reference example, not placeholders to edit.

## Install

Run this one command in your terminal:

```bash
curl -s https://raw.githubusercontent.com/kellie-fontes/fern-claude-skills/main/install.sh | bash
```

Then open Claude Code and type `/` to see all skills listed.

## Skills

| Command | What it does |
|---|---|
| `/fern-start` | **Run this first** — sets context and ground rules for the session |
| `/fern-kickoff` | Design the full architecture before writing any code |
| `/fern-api` | Build the MuleSoft mock API in Anypoint Code Builder |
| `/fern-deploy` | Deploy the Mule app to CloudHub Sandbox |
| `/fern-wire` | Wire the MuleSoft API to Agentforce via External Service Registration |
| `/fern-agent` | Create the Agentforce agent, system prompt, and GenAI functions |
| `/fern-apex` | Build the Apex controllers, Custom Setting, and Remote Site Settings |
| `/fern-site` | Create the Experience Cloud site and branded chat LWC |
| `/fern-form` | Build the custom object, log form LWC, and real-time polling |
| `/fern-dashboard` | Build the internal dashboard via Visualforce + Lightning Out |
| `/fern-debug` | Debugging prompts for the most common errors |
| `/fern-prep` | Demo prep checklist, demo links, and admin token refresh script |

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
