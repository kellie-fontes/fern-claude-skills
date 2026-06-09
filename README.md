# Fern Claude Skills

Claude Code skills for building the Fern (FertilityConnect) Agentforce + MuleSoft demo — and any demo like it.

Each skill is a standalone prompt pre-filled with FertilityConnect values as a working example. Replace the `[bracketed placeholders]` with your own industry, persona, and company to build a new demo from scratch.

## Install

Run this one command in your terminal:

```bash
curl -s https://raw.githubusercontent.com/kellie-fontes/fern-claude-skills/main/install.sh | bash
```

Then open Claude Code and type `/` to see all skills listed.

## Skills

| Command | What it does |
|---|---|
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
