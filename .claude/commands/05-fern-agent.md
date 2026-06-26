# /05-fern-agent — Build the Agentforce Agent

Build the Agentforce agent metadata, wire it in Agent Builder, and get it responding.

**What you'll do:** Claude builds everything automatically (5A). You click through 5 screens in Agent Builder (5B). Claude handles the rest.

---

## Step 5A — Claude builds the agent metadata

```
Read fern-context.md — check the current directory first, then one level up.
Every `{variable}` in these instructions is a placeholder — replace it with the matching value from fern-context.md before running any command or generating any code.

Before proceeding, verify these fields are present and non-empty: org_alias, org_domain, agent_label, agent_developer_name, plugin_name, persona_id, cloudhub_url. If any are missing, list them and stop.

Create an Agentforce agent with the following configuration.
Generate all required Salesforce metadata files.

Agent definition (Bot):
- Label: {agent_label}
- Developer name: {agent_developer_name}
- Type: ExternalCopilot (required for programmatic API access)
- Agent template: AiCopilot__AgentforceAgent
- Rich content enabled: true
- Session timeout: 0 (no timeout for demo)
- Description: AI companion for {persona_role}s at {company_name}

Agent version (BotVersion):
- Company: {company_name}
- Role: One concise paragraph, strictly under 500 characters, describing what {agent_name} can do
  and what data it accesses via {plugin_name}. No bullet points, no headers — plain prose only.
  After generating it, print it labeled: "Role ([X] chars):" so the user can see the exact text
  and character count. If it exceeds 500 characters, trim it before writing to metadata.
- Tone: Casual
- Small talk: disabled
- Knowledge fallback: disabled
- Citations: disabled

System prompt (GenAiPromptTemplate, type AGENT_SYSTEM_PROMPT):
- Agent name and persona: {agent_name}, warm and helpful
- Capabilities: what the {persona_role} can look up and do
- Tone guidance: warm and empathetic, plain language
- Hard boundary: never provide clinical/professional advice —
  always refer to the appropriate team for those decisions
- Context injection: {persona_role} ID is always {persona_id},
  injected as {persona_id} — never ask the user for their ID
- Out-of-scope response: suggest the user speak to the appropriate team

GenAiPlugin grouping all {domain} functions:
- Label: {plugin_name}
- Developer name: {plugin_name}
- Description: Connects {agent_name} to the {domain} system at {company_name}

GenAiFunction for each endpoint — write descriptions as
"Use this when the {persona_role} asks [phrases]" not "Returns [data]":
- Get summary → use when {persona_role} asks how they are doing overall
- Get {child_endpoint_1} → use when {persona_role} asks about {child_endpoint_1}
- Get {child_endpoint_2} → use when {persona_role} asks about {child_endpoint_2}
- Get {child_endpoint_3} → use when {persona_role} asks about {child_endpoint_3}
- POST endpoints → isConfirmationRequired: true, isIncludeInProgressIndicator: true

After deploying the metadata, tell the user it's time for Step 5B.
Do not attempt to write bot_id to fern-context.md here.
```

---

## Step 5B — Wire actions in Agent Builder (5 clicks)

This part requires the UI — Salesforce doesn't support it via metadata. It takes about 5 minutes.

**1. Open your agent**
- Go to **Setup → Agents**
- Click your agent name → **Open in Agent Builder**

**2. Create a Subagent**
- In the left panel: **Subagents → New → New Subagent**
- Give it a short name (e.g. "{agent_name} Support") and a one-line description — keep it under 255 characters, this is not the full Role, just a brief label
- If step 3 of the wizard says "No checklist steps returned" — that's normal, just save

> **Note:** The agent's full Role description was already deployed via metadata in Step 5A — you do not need to paste anything into Agent Builder. If Agent Builder shows a Role field and it looks empty, that is a display quirk; the deployed value is already active.

**3. Add your API actions**
- Inside the subagent: **This Subagent's Actions tab → New → Add from Asset Library**
- Set **Reference Action Type = API** and **Reference Action Category = External Services**
- Add each of your External Service actions one at a time
- For each action: write a short description of when to use it, and uncheck **Collect data from user** for the ID parameter (the ID is always hardcoded)

**4. Assign the agent user**
- Click the **gear icon** (top right of Agent Builder) → **Settings**
- Find the **User** field and pick an active Salesforce user
- If your dedicated agent user is rejected, any licensed standard user works as a fallback

**5. Activate**
- Click **Activate**
- If you see "Configuration Issues Detected" → click **Ignore & Activate**
- Once activated, come back here and tell Claude: **"Agent activated"**

---

After you say "Agent activated", Claude will automatically:
- Retrieve and save the bot ID to `fern-context.md`
- Remove any auto-injected EmployeeCopilot functions that would override your agent
- Patch the topic routing description so the agent responds to all your demo phrases
- Assign the External Credential permission set to the agent user and verify the MuleSoft callout works

You'll see a confirmation for each step. When all four are done, run `/06-fern-apex`.

<!-- CLAUDE AUTOMATION — not shown to user, not for copy/paste -->
<!--
When the user says "Agent activated", run these four steps silently and report only the results:

1. RETRIEVE BOT ID
   sf api request rest --target-org {org_alias} "/services/data/v62.0/tooling/query?q=SELECT+Id+FROM+BotDefinition+WHERE+DeveloperName='{agent_developer_name}'"
   Parse the Id and write it to bot_id in fern-context.md. Read the file back to verify.
   Success → print "✓ bot_id saved: [value]"
   Failure → print "bot_id could not be saved automatically — open Agent Builder, copy the 18-character ID from the URL bar, and paste it into bot_id in fern-context.md."

2. CLEAN UP EMPLOYEECOPILOT
   Write cleanup-agent.sh using org_alias, agent_developer_name, and plugin_name from fern-context.md.
   The script: finds the _v1 planner in GenAiPlannerDefinition → queries its GenAiPlannerFunctionDef records
   → deletes any where the linked plugin is EmployeeCopilot__AnswerQuestionsWithKnowledge.
   chmod +x, run immediately, print what was deleted (or "Nothing to clean up").

3. PATCH TOPIC ROUTING
   Query GenAiPluginDefinition for {plugin_name}. PATCH its Description with an exhaustive list of
   every action category and trigger phrase from routing_phrase_1, routing_phrase_2,
   child_endpoint_1/2/3, and persona_role in fern-context.md.
   Print "✓ Topic routing patched"

4. ASSIGN EXTERNAL CREDENTIAL PERMISSION SET
   a. Find permission set: SELECT Id FROM PermissionSet WHERE Name LIKE '%API_Access%'
   b. Find agent user: SELECT Id, Username FROM User WHERE Username LIKE '%agent%' OR Profile.Name = 'Einstein Service Agent'
      If multiple users found, list them and ask which to use before continuing.
   c. POST PermissionSetAssignment. If duplicate error, continue.
   d. Test callout via sf apex run. 
      HTTP 200 → print "✓ MuleSoft callout working — ready to run /06-fern-apex"
      HTTP 502 → print "Named Credential URL may be HTTPS. Go to Setup → Named Credentials → edit {named_credential_name} → change https:// to http://"
-->

---

## FertilityConnect reference
- agent_label = Fertility Support Agent 2
- agent_name = Fern, compassionate care companion
- hard boundary = never provide medical advice, always refer to care team
- out-of-scope = "That's a great question for your care team — would you like me to note it for your next appointment?"

## Troubleshooting
If something doesn't work after this step, run `/10-fern-debug` — it covers the most common issues:
agent says "Sorry, I can't assist", actions not showing in Agent Builder, 502 callout errors, and more.
