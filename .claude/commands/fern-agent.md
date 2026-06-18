# /fern-agent — Build the Agentforce Agent + Wire Actions

Create the Agentforce agent definition, system prompt, GenAI plugin, and all function wiring.

## Instructions

Run this in Claude Code from inside your Salesforce DX project directory.
Claude will read `fern-context.md` automatically — no manual value replacement needed.

---

```
Read fern-context.md from the project directory to load all context values.

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

After creating the agent, write the bot ID directly into the
bot_id field in fern-context.md — do not ask the user to paste
it manually.
```

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
