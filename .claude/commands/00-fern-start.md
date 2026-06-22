# /00-fern-start — Session Setup (Run This First)

Run this once at the start of every session before any other /NN-fern-* command.

---

```
Run the following automatically — do not ask the user anything yet:

find ~ -name "fern-context.md" \
  -not -path "*/node_modules/*" \
  -not -path "*/.git/*" \
  -not -path "*/vendor/*" \
  2>/dev/null

For each file found, read it and extract:
- agent_name
- persona_name
- persona_role
- industry
- cloudhub_url   (blank = Step 3 not done)
- bot_id         (blank = Step 5 not done)
- site_path      (blank = Step 7 not done)

Determine the last completed step for each project using this logic:
- site_path is populated        → Steps 1–7 done, last confirmed: Step 7
- bot_id is populated           → Steps 1–5 done, last confirmed: Step 5
- cloudhub_url is populated     → Steps 1–3 done, last confirmed: Step 3
- none of the above             → Step 1 done (context file exists but no steps verified)

Then present this menu — exactly this format, nothing else before it:

---
**Fern — Session Setup**

[If 1+ projects found, list them:]
Existing projects:
  1. [agent_name] — [industry] ([persona_role])  ·  last step: [N]
  2. [agent_name] — [industry] ([persona_role])  ·  last step: [N]
  ...
  [N+1]. Start a new project

[If no projects found:]
No existing projects found.
  1. Start a new project

What would you like to do?
  • Type a number to resume or start
  • Or type "revisit [number]" to reload a project and re-run any step
---

Wait for the user to respond, then:

IF they choose an existing project to resume:
  - Read that project's fern-context.md fully into context
  - Confirm: "Loaded [agent_name] for [company_name]. Picking up at Step [N+1]."
  - Tell them exactly which command to run next: "Run /NN-fern-NAME to continue."
  - Apply the session ground rules below.

IF they type "revisit [number]":
  - Read that project's fern-context.md fully into context
  - Confirm: "Loaded [agent_name] for [company_name]."
  - List all 9 steps with ✓ next to completed ones (use the same field logic above)
  - Ask: "Which step would you like to re-run?"
  - When they answer, tell them to run that skill command.
  - Apply the session ground rules below.

IF they choose new project:
  - Say: "Let's build something new. Run /01-fern-design to design your architecture and generate fern-context.md."
  - Apply the session ground rules below.

SESSION GROUND RULES (apply for all three paths):
1. Work through one step at a time. When I run a skill, focus ONLY on that step.
2. After each step, stop and wait for me to confirm it is working before moving on.
3. If you need a value from a previous step, read fern-context.md first — check the current directory, then one level up. If it is not there, ask me. Never invent values.
4. Keep responses focused. If you spot something outside the current step that could be improved, note it briefly but do not act on it.
5. When a step is done, say "Step [N] complete — ready for Step [N+1] when you are."
```

---

## Build steps — reference

| Step | Command | What it does |
|---|---|---|
| 1 | `/01-fern-design` | Architecture design + writes fern-context.md |
| 2 | `/02-fern-api` | Build the MuleSoft mock API |
| 3 | `/03-fern-deploy` | Deploy to CloudHub |
| 4 | `/04-fern-wire` | Wire MuleSoft to Agentforce via Named Credential + External Service |
| 5 | `/05-fern-agent` | Build the agent, wire actions in Agent Builder, grant permissions |
| 6 | `/06-fern-apex` | Apex controllers + Custom Setting + Remote Sites |
| 7 | `/07-fern-site` | Experience Cloud site + Chat UI + Design |
| 8 | `/08-fern-form` | Custom object + log form + real-time polling |
| 9 | `/09-fern-dashboard` | Internal dashboard |

| Command | When to use |
|---|---|
| `/10-fern-debug` | When something breaks |
| `/11-fern-prep` | Morning of every demo — auto-refreshes token, checks health, generates demo script |
