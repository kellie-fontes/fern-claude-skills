# /fern-agent — Build the Agentforce Agent + Wire Actions

Create the Agentforce agent definition, system prompt, GenAI plugin, and all function wiring.

## Instructions

Run this in Claude Code from inside your Salesforce DX project directory. Replace all [bracketed values] with your own before running.

---

```
Create an Agentforce agent with the following configuration.
Generate all required Salesforce metadata files.

Agent definition (Bot):
- Label: [Agent Label]
- Developer name: [Agent_Developer_Name]
- Type: ExternalCopilot (required for programmatic API access)
- Agent template: AiCopilot__AgentforceAgent
- Rich content enabled: true
- Session timeout: 0 (no timeout for demo)
- Description: [one sentence — what the agent does and who it serves]

Agent version (BotVersion):
- Company: [Company Name]
- Role: [2-3 sentences — what the agent can do, what data it
  accesses, and what actions it can take]
- Tone: Casual
- Small talk: disabled
- Knowledge fallback: disabled
- Citations: disabled

System prompt (GenAiPromptTemplate, type AGENT_SYSTEM_PROMPT):
- Agent name and persona: [name, personality]
- Capabilities: [what it can look up and do]
- Tone guidance: warm and empathetic, plain language
- Hard boundary: never provide medical/clinical advice —
  always refer to the care team for clinical decisions
- Context injection: patient ID always [patientId], injected
  as {patientId} — never ask the user for their ID
- Out-of-scope response: [what to say when asked something
  outside scope]

GenAiPlugin grouping all EMR functions:
- Label: [Plugin Label]
- Developer name: [PluginDeveloperName]
- Description: [what this plugin connects and enables]

GenAiFunction for each endpoint — write descriptions as
"Use this when the patient asks [phrases]" not "Returns [data]":
- Get summary → use when patient asks how they are doing
- Get [child1] → use when patient asks about [child1]
- Get [child2] → use when patient asks about [child2]
- Get [child3] → use when patient asks about [child3]
- POST endpoints → isConfirmationRequired: true,
  isIncludeInProgressIndicator: true
```

## FertilityConnect values (working example)
- Label = Fertility Support Agent 2
- Developer name = Fertility_Support_Agent_2
- Company = Bloom Fertility
- Persona = Fern, compassionate care companion
- Patient ID always P001, injected as {patientId}
- Hard boundary = never provide medical advice, always refer to care team
- Out-of-scope = "That is a great question for your care team. Would you like me to note it so you remember to ask at your next appointment?"
- Plugin = FertilityEMRPlugin

## Key lessons
- Agent type MUST be ExternalCopilot — other types don't support the bootstrap/session API pattern
- GenAiFunction descriptions are the routing logic — vague descriptions cause the agent to call the wrong function
- Leave isConfirmationRequired: true on Schedule Appointment so the audience sees the agent ask "shall I book this?"
