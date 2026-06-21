# /00-fern-start — Session Setup (Run This First)

Run this once at the start of every build session before any other /NN-fern-* command.

---

```
We are going to build a demo together across 9 steps. Here is the
full project overview so you have context:

We are building an Agentforce + MuleSoft + Experience Cloud demo.
It consists of:
- A MuleSoft mock API deployed to CloudHub (Steps 1-3)
- An Agentforce agent wired to that API (Steps 4-5)
- Apex controllers and a Custom Setting for authentication (Step 6)
- An Experience Cloud site with a branded chat LWC (Step 7)
- A custom object, log form, and real-time polling (Step 8)
- An internal dashboard via Visualforce + Lightning Out (Step 9)

Ground rules for this session:
1. We will work through one step at a time. When I paste a prompt,
   focus ONLY on that step — do not proceed to the next step
   automatically.
2. After completing each step, stop and wait for me to confirm it
   is working before we move on.
3. If you need information from a previous step (like a URL or ID),
   look for it in fern-context.md — check the current directory first,
   then one level up. If it is not there yet, ask me — do not assume
   or invent values.
4. Keep responses focused on the task at hand. If you see something
   outside the current step that could be improved, note it briefly
   but do not act on it unless I ask.
5. When a step is done, say "Step [N] complete — ready for Step [N+1]
   when you are."

At the start of each step, read fern-context.md to load all
industry-specific values before generating any code or metadata.

Confirm you understand by summarizing the project in one sentence
and listing the 9 build steps.
```

---

## Step order — run these in sequence

**Build steps — run in order:**

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

**Support commands — use any time:**

| Command | When to use |
|---|---|
| `/fern-debug` | When something breaks — real errors, real fixes |
| `/fern-prep` | Morning of every demo — token refresh + checklist |

**Tip:** Complete and test each step before running the next one.

**To adapt for a new industry:** Edit `fern-context.md` in your parent
directory and re-run any step — all values are read from that file.
