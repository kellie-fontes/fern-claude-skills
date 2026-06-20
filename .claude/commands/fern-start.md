# /fern-start — Session Setup (Run This First)

Run this once at the start of every build session before any other /fern-* command.

---

```
We are going to build a demo together across 11 steps. Here is the
full project overview so you have context:

We are building an Agentforce + MuleSoft + Experience Cloud demo.
It consists of:
- A MuleSoft mock API deployed to CloudHub (Steps 1-3)
- An Agentforce agent wired to that API (Steps 4, 4B, 4C, 4D)
- Apex controllers and a Custom Setting for authentication (Step 5)
- An Experience Cloud site with a branded chat LWC (Step 6)
- A custom object, log form, and real-time polling (Step 7)
- An internal dashboard via Visualforce + Lightning Out (Step 8)

Ground rules for this session:
1. We will work through one step at a time. When I paste a prompt,
   focus ONLY on that step — do not proceed to the next step
   automatically.
2. After completing each step, stop and wait for me to confirm it
   is working before we move on.
3. If you need information from a previous step (like a URL or ID),
   look for it in fern-context.md in the project directory. If it
   is not there yet, ask me — do not assume or invent values.
4. Keep responses focused on the task at hand. If you see something
   outside the current step that could be improved, note it briefly
   but do not act on it unless I ask.
5. When a step is done, say "Step [N] complete — ready for Step [N+1]
   when you are."

At the start of each step, read fern-context.md to load all
industry-specific values before generating any code or metadata.

Confirm you understand by summarizing the project in one sentence
and listing the 11 build steps (1 through 8, with step 4 split
into 4A, 4B, 4C, 4D).
```

---

## Step order — run these in sequence

**Build steps — run in order:**

| Step | Command | What it does |
|---|---|---|
| 1 | `/fern-design` | Architecture design + writes fern-context.md |
| 2 | `/fern-api` | Build the MuleSoft mock API |
| 3 | `/fern-deploy` | Deploy to CloudHub (writes `cloudhub_url` to fern-context.md) |
| 4 | `/fern-wire` | Wire MuleSoft to Agentforce via Named Credential + External Service |
| 4B | `/fern-agent` | Create the agent metadata + GenAI functions |
| 4C | *(UI — see `/fern-agent`)* | Wire actions in Agent Builder — **mandatory, cannot be done via metadata** |
| 4D | *(UI — see `/fern-agent`)* | Assign agent user + grant External Credential perm set |
| 5 | `/fern-apex` | Apex controllers + Custom Setting + Remote Sites |
| 6 | `/fern-site` | Experience Cloud site + Chat UI + Design |
| 7 | `/fern-form` | Custom object + log form + real-time polling |
| 8 | `/fern-dashboard` | Internal dashboard |

**Support commands — use any time:**

| Command | When to use |
|---|---|
| `/fern-start` | Run once at the start of every build session |
| `/fern-debug` | When something breaks — real errors, real fixes |
| `/fern-prep` | Morning of every demo — token refresh + checklist |

**Tip:** Complete and test each step before running the next one.

**To adapt for a new industry:** Edit `fern-context.md` in your project
directory and re-run any step — all values are read from that file.
