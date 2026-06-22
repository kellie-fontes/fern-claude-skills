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
- Role: Describe what {agent_name} can do — what data it accesses
  via {plugin_name} and what actions it can take
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
- Give it a name (e.g. "{agent_name} Support") and a one-line description of what it does
- If step 3 of the wizard says "No checklist steps returned" — that's normal, just save

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

---

```
After the user confirms activation, run the following automatically — do not wait for the user to ask:

1. Retrieve bot ID:
sf api request rest --target-org {org_alias} "/services/data/v62.0/tooling/query?q=SELECT+Id+FROM+BotDefinition+WHERE+DeveloperName='{agent_developer_name}'"
Parse the Id and write it to bot_id in fern-context.md. Read the file back to verify it's present.
If it's missing after writing, tell the user: "bot_id could not be written automatically — open Agent Builder, copy the 18-character ID from the URL bar, and paste it into bot_id in fern-context.md." Otherwise confirm: "✓ bot_id saved: [value]"

2. Generate cleanup-agent.sh from fern-context.md values (org_alias, agent_developer_name, plugin_name). The script must:
   - Query GenAiPlannerDefinition for the planner whose DeveloperName ends in _v1
   - Query all GenAiPlannerFunctionDef records for that planner
   - Delete any record where the linked plugin is EmployeeCopilot__AnswerQuestionsWithKnowledge
   - Print what was deleted (or "Nothing to clean up")
Save as cleanup-agent.sh, chmod +x, run it immediately, and report what was deleted.

3. Patch topic routing — query GenAiPluginDefinition for {plugin_name}, then PATCH its Description with an exhaustive list of every action category and natural trigger phrase drawn from routing_phrase_1, routing_phrase_2, child_endpoint_1/2/3, and persona_role in fern-context.md. Confirm the patch was applied.

4. Assign External Credential permission set to the agent user:
   a. sf data query --query "SELECT Id, Name FROM PermissionSet WHERE Name LIKE '%API_Access%'" --target-org {org_alias}
   b. sf data query --query "SELECT Id, Username FROM User WHERE Username LIKE '%agent%' OR Profile.Name = 'Einstein Service Agent'" --target-org {org_alias}
      If multiple users are returned, list them and ask which one to use.
   c. POST to /services/data/v62.0/sobjects/PermissionSetAssignment/ with AssigneeId and PermissionSetId. If duplicate error, continue.
   d. Test: sf apex run --target-org {org_alias} --apex-code "System.debug(JSON.serialize(Http.send(new HttpRequest(){{ setEndpoint('callout:{named_credential_name}/{resource}/{persona_id}'); setMethod('GET'); }})));"
      If HTTP 200 → confirm "✓ MuleSoft callout working"
      If 502 → tell the user: "Named Credential URL may be HTTPS — go to Setup → Named Credentials → edit {named_credential_name} → change the URL from https:// to http://"
```

---

## FertilityConnect reference
- agent_label = Fertility Support Agent 2
- agent_name = Fern, compassionate care companion
- hard boundary = never provide medical advice, always refer to care team
- out-of-scope = "That's a great question for your care team — would you like me to note it for your next appointment?"

## Troubleshooting
If something doesn't work after this step, run `/10-fern-debug` — it covers the most common issues:
agent says "Sorry, I can't assist", actions not showing in Agent Builder, 502 callout errors, and more.
