# Fern Claude Skills

Claude Code skills for building the Fern (FertilityConnect) Agentforce + MuleSoft demo — and any demo like it. FertilityConnect (Fern) is a patient-facing Agentforce AI care companion for fertility patients — built as a proof of concept for the MuleSoft + Agentforce Better Together story in an HLS context. Built entirely with Claude Code, Fern connects Agentforce, MuleSoft, a LWC app built on Experience Cloud, and a mock EMR system hosted on Visualforce into a single end-to-end patient care journey. 


Each skill reads from a `fern-context.md` file in your project directory — a single config file that holds your industry, persona, company, API names, and branding. To build a demo for a new industry:

1. Run `/00-fern-start` to set context and ground rules for your custom build using the Fern template
2. Run `/01-fern-design` with your industry, persona, and flow descriptions — Claude writes a populated `fern-context.md` and auto-fills `org_alias`, `org_domain`, and `business_group_id`
3. Open `fern-context.md` and fill in `client_id` and `client_secret` (your Anypoint connected app credentials — the only two fields that can't be auto-populated)
4. Run each `/NN-fern-*` skill in order — Claude fills in the remaining fields like `cloudhub_url`, `bot_id`, and `site_path` automatically as each step completes

The FertilityConnect values in each skill are a working reference example, not placeholders to edit.

> **Note:** `fern-context.md` is not included in this repo. It is generated in your project's parent directory when you run `/01-fern-design` and stays local — it contains credentials and org-specific values that should never be committed.

## Install

There are two separate sets of skills to install. Do them in order.

### Step 1 — Salesforce Extension skills (Salesforce tooling)

These ship as part of the **Salesforce Extension for Claude Code** and auto-register when Claude Code detects an `sfdx-project.json` in your working directory.

1. Install Claude Code: `npm install -g @anthropic-ai/claude-code`
2. Install the Salesforce CLI (`sf`): `npm install -g @salesforce/cli`
3. Open your Salesforce DX project folder in your terminal and run `claude`
4. The Salesforce skills activate automatically — type `/` to confirm they're listed

If they don't auto-register, install manually:
```bash
npx skills add forcedotcom/sf-skills --all
```

### Step 2 — Fern demo skills (this repo)

Run this one command from any directory:

```bash
curl -s https://raw.githubusercontent.com/kellie-fontes/fern-claude-skills/main/install.sh | bash
```

The installer:
- Downloads all 12 Fern skill files to `~/.claude/commands/`
- Downloads `reset-demo.sh` to your current directory
- Prints the full command list and tells you where each file was saved

Then type `/fern` in Claude Code to see all Fern skills listed.

> **Fern skills not showing up?**
> - Close and reopen Claude Code after running the installer — it reads `~/.claude/commands/` on startup.
> - Verify: `ls ~/.claude/commands/ | grep fern` — you should see 12 files.
> - Fern skills are global — they work from any directory, not just your Salesforce DX project folder.

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
| `/11-fern-prep` | Morning of every demo — auto-refreshes the admin token, checks MuleSoft health, generates demo script and links |

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

## Reset Demo Data

If your demo object has stale records from a previous run, clear them before going live:

```bash
bash reset-demo.sh
```

The script reads `fern-context.md` to know which org, object, persona ID field, and persona ID to target — no manual edits needed. It prompts for confirmation before deleting anything.

Downloaded automatically by `install.sh`. `token-refresh.sh` is written to your project directory the first time you run `/11-fern-prep`.


## Built by
[@Kellie Fontes](https://github.com/kellie-fontes) — MuleSoft + Agentforce Better Together demo
