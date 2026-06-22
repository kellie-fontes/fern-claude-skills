# /05-fern-agent — Build the Agentforce Agent

Build the Agentforce agent, wire actions in Agent Builder, and grant the agent user External Credential access.

## Instructions

Run this in Claude Code from inside your Salesforce DX project directory.
Claude will read `fern-context.md` automatically — no manual value replacement needed.

---

## Step 5A — Build the Agent Metadata

```
Read fern-context.md — check the current directory first, then one level up.

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
- POST endpoints → isConfirmationRequired: true,
  isIncludeInProgressIndicator: true

After deploying the metadata, the bot ID is not yet available —
it is obtained in Step 5B after activation (from the Agent Builder URL).
Do not attempt to write bot_id to fern-context.md here.
```

---

## Step 5B — Wire Actions in Agent Builder UI (required, cannot be done via metadata)

After deploying the bot metadata, you MUST wire the actions through the Agent Builder UI.
Metadata-deployed GenAiFunctions do NOT show Inputs/Outputs in Agent Builder and the agent
will not call them. The UI wiring step creates the inline `externalServiceOperation` format
that Agentforce actually uses.

**Steps:**

1. Go to Setup → Agents → open your agent → click **Open in Agent Builder**
2. In the left panel, click **Subagents** → **New** → **New Subagent**
3. Give the subagent a name (e.g. "Loyalty Member Support") and a short description of its scope
4. On step 3 of the wizard, if it says "No checklist steps returned" — that's fine, ignore it and save
5. In the subagent, go to **This Subagent's Actions** tab → **New** → **Add from Asset Library**
6. Set **Reference Action Type = API**, **Reference Action Category = External Services** (not MuleSoft — the category label varies by org)
7. Select each of your External Service actions one at a time and add them
8. For each action: set a clear description ("Use this when the customer asks about their loyalty points...") and uncheck **Collect data from user** for the `customerId` parameter

**Assign the agent user:**

9. Click **Settings** (gear icon, top right of Agent Builder)
10. Find the **User** field and assign an active Salesforce user
    - The user must have an active Salesforce license
    - If your dedicated agent user is rejected, use any licensed standard user in the org as a fallback
    - The agent runs all MuleSoft callouts as this user — they need the External Credential permission set (see below)

**Activate:**

11. Click **Activate** — if you see "Configuration Issues Detected / We couldn't load the checklist", click **Ignore & Activate**
12. After activation, tell me you have activated the agent. I will automatically retrieve the bot ID.

---

After the user confirms activation, run:
```
sf api request rest --target-org {org_alias} "/services/data/v62.0/tooling/query?q=SELECT+Id+FROM+BotDefinition+WHERE+DeveloperName='{agent_developer_name}'"
```
Parse the Id from the response and write it to the `bot_id` field in `fern-context.md` automatically. Confirm to the user: "bot_id written to fern-context.md: [value]"

---

## Step 5C [MANUAL STEP] — Grant the Agent User External Credential Access

The agent user runs every MuleSoft callout. Without the right permission set, callouts succeed
in Apex (admin user) but silently fail when Agentforce executes them — the agent says
"I couldn't retrieve your information" with no error in the logs.

**Fix (automated):**

1. Confirm the permission set does NOT have `viewAllFields: true` — run:
   ```
   sf data query --query "SELECT Id, Name FROM PermissionSet WHERE Name = '{external_credential_name}_API_Access'" --target-org {org_alias}
   ```
   If `viewAllFields` is a concern, note it to the user.
2. Look up the permission set ID:
   ```
   sf data query --query "SELECT Id FROM PermissionSet WHERE Name LIKE '%API_Access%'" --target-org {org_alias}
   ```
3. Look up the agent user ID:
   ```
   sf data query --query "SELECT Id FROM User WHERE Username LIKE '%agent%' OR Profile.Name = 'Einstein Service Agent'" --target-org {org_alias}
   ```
4. Assign the permission set via REST:
   ```
   sf api request rest --target-org {org_alias} --method POST "/services/data/v62.0/sobjects/PermissionSetAssignment/" --body '{"AssigneeId":"[agent_user_id]","PermissionSetId":"[perm_set_id]"}'
   ```
5. Test the callout:
   ```
   sf apex run --target-org {org_alias} --apex-code "System.debug(JSON.serialize(Http.send(new HttpRequest(){{ setEndpoint('callout:{named_credential_name}/{resource}/{persona_id}'); setMethod('GET'); }})));"
   ```
   Confirm it returns HTTP 200 before testing via chatbot.

**Named Credential HTTP vs HTTPS:**
- CloudHub apps deployed with default config only listen on HTTP, not HTTPS
- Salesforce Named Credentials default to HTTPS — this causes 502 on all callouts
- If `callout:YourNC/path` returns 502 but `curl http://your-cloudhub-url/path` returns 200,
  the mismatch is HTTP vs HTTPS
- Either: update the Named Credential URL to `http://` in Setup → Named Credentials → Edit,
  or add an HTTPS listener to your MuleSoft app

---

## Generate cleanup-agent.sh

After completing Step 5, generate a `cleanup-agent.sh` script in the project root using the following logic. Read `org_alias`, `agent_developer_name`, and `plugin_name` from `fern-context.md`.

The script should:
1. Query `GenAiPlannerDefinition` to find the planner whose `DeveloperName` ends in `_v1` (the one Agent Builder created)
2. Query all `GenAiPlannerFunctionDef` records for that planner ID
3. Identify and delete any record where the linked plugin is `EmployeeCopilot__AnswerQuestionsWithKnowledge`
4. Print confirmation of what was deleted
5. Print "Run this after every deactivate → activate cycle"

Save as `cleanup-agent.sh` in the current directory. Make it executable.

---

## Auto-patch Topic Classification Description

After Step 5B, automatically patch the `GenAiPluginDefinition` Classification Description to prevent "Sorry, I can't assist" routing failures:
1. Query the plugin ID:
   ```
   sf api request rest --target-org {org_alias} "/services/data/v62.0/tooling/query?q=SELECT+Id,DeveloperName+FROM+GenAiPluginDefinition+WHERE+DeveloperName='{plugin_name}'"
   ```
2. Generate an exhaustive description using `routing_phrase_1`, `routing_phrase_2`, `child_endpoint_1`/`2`/`3`, and `persona_role` from `fern-context.md`. The description must cover every action category and natural trigger phrases.
3. PATCH it:
   ```
   sf api request rest --target-org {org_alias} --method PATCH "/services/data/v62.0/tooling/sobjects/GenAiPluginDefinition/[plugin-id]" --body '{"Description":"[exhaustive description]"}'
   ```
Confirm the patch was applied.

---

## FertilityConnect values (reference example)
- agent_label = Fertility Support Agent 2
- company_name = Bloom Fertility
- agent_name = Fern, compassionate care companion
- persona_id injected as {patientId}
- hard boundary = never provide medical advice, always refer to care team
- out-of-scope = "That is a great question for your care team. Would you like me to note it so you remember to ask at your next appointment?"

## Key lessons
- Agent type MUST be ExternalCopilot — other types don't support the bootstrap/session API pattern
- GenAiFunction descriptions are the routing logic — vague descriptions cause the agent to call the wrong function
- Leave isConfirmationRequired: true on any scheduling/booking action so the audience sees the agent confirm before acting
- **EmployeeCopilot trap:** Agentforce auto-injects `EmployeeCopilot__AnswerQuestionsWithKnowledge` as a new
  `GenAiPlannerFunctionDef` on EVERY activation. It wins topic routing over your custom plugin and makes the agent
  give generic responses. After every deactivate→activate cycle, immediately delete it via Tooling API:
  ```
  GET /services/data/v62.0/tooling/query/?q=SELECT+Id+FROM+GenAiPlannerFunctionDef+WHERE+PlannerId='[your-planner-id]'
  ```
  Delete every record except the one that links to your plugin. Keep your stable plugin PlannerFunctionDef ID noted.
- **Planner naming: Agent Builder creates a `_v1` planner, not the one in your metadata.** When you wire actions
  through Agent Builder (Step 5B), it creates a NEW planner named `{agent_developer_name}_v1` — not the planner
  your metadata deployed. All EmployeeCopilot housekeeping and Tooling API patches must target THIS planner.
  Verify which planner your bot actually uses:
  ```
  GET /services/data/v62.0/tooling/query?q=SELECT+Id,DeveloperName+FROM+GenAiPlannerDefinition
  GET /services/data/v62.0/tooling/query?q=SELECT+Id,PlannerId,Plugin+FROM+GenAiPlannerFunctionDef
  ```
  Match the planner whose `DeveloperName` ends in `_v1` — that's the live one. All subsequent patches go there.
- **Topic Classification Description must be exhaustive — too narrow causes "can't assist".** Every topic
  (GenAiPluginDefinition) has TWO text fields that affect routing:
  - `Description` = the **Classification Description** shown in Agent Builder. The planner uses THIS to decide
    which topic to route a message to. If it only lists a subset of your actions (e.g. "loyalty and rewards")
    the planner won't route orders, profile, or summary questions → `result:[]` → "Sorry, I can't assist."
  - `Scope` = what the topic does once selected (instructions, not classifier).
  The Classification Description must enumerate every category of question + natural trigger phrases
  ("how am I doing", "give me a summary", etc.). Patch it while the agent is deactivated:
  ```bash
  sf api request rest --target-org [alias] --method PATCH \
    "/services/data/v62.0/tooling/sobjects/GenAiPluginDefinition/[plugin-id]" \
    --body '{"Description":"[exhaustive description covering all action categories and trigger phrases]"}'
  ```
- **Input schema for hardcoded IDs:** Each GenAiFunction needs an `input/schema.json` so the LLM knows
  the value to pass for required path parameters like `patientId` or `customerId`. Use this pattern:
  ```json
  {
    "required": ["patientId"],
    "unevaluatedProperties": false,
    "properties": {
      "patientId": {
        "title": "Patient Id",
        "description": "Always use P001 for Sarah Mitchell. Never ask the user for this value.",
        "lightning:type": "lightning__textType",
        "lightning:isPII": false,
        "copilotAction:isUserInput": true
      }
    },
    "lightning:type": "lightning__objectType"
  }
  ```
  `isUserInput: false` on a `required` field is INVALID — causes 412 "Invalid Config" on activation.
  Always use `isUserInput: true`.
- Deploying bot metadata (`.bot-meta.xml`, `.botVersion-meta.xml`) deactivates the agent — re-activate
  in Agent Builder after every bot deploy. Avoid redeploying bot files unless necessary.
- **Standalone GenAiFunction files never work for action routing** — metadata-deployed functions linked
  to a plugin do NOT show Inputs/Outputs in Agent Builder. Only actions wired through the UI
  (Add from Asset Library → External Services) create the inline format Agentforce actually executes.
  The UI path is mandatory, not optional.
