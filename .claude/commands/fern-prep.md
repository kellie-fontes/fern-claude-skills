# /fern-prep — Demo Prep + Token Refresh

Everything to check the morning of any demo.

---

## Demo Script Prompt

Paste this into Claude Code the morning of your demo:

```
I'm demoing this to [audience] in [time]. Here's what works and
what's broken: [list].

Give me:
1. A demo script that plays to the working parts
2. Fallback talking points if something breaks live
3. The one-liner that explains the architecture in 10 seconds
```

---

## Your Demo Links

| What | URL |
|---|---|
| Chatbot (persona view) | https://[your-subdomain].my.site.com/[site-path] |
| Internal Dashboard | https://[your-org].lightning.force.com/apex/[PageName] |
| Agentforce Agent Builder | https://[your-org].lightning.force.com → Setup → Agents |
| Anypoint Runtime Manager | https://anypoint.mulesoft.com → Runtime Manager → Applications |

**FertilityConnect values:**
- Chatbot = https://kfontes-mule-agtforce-demo.my.site.com/fertilityconnect
- Dashboard = /apex/NursingEMR

---

## Admin Token Refresh

The chatbot authenticates to Agentforce using a Salesforce admin session token stored in a Custom Setting. **It expires when you log out or after inactivity — refresh it every morning before a demo.**

Save the script below as `token-refresh.sh` in your project. Run it once and you're done.

```bash
#!/bin/bash
# Usage: bash token-refresh.sh [your-org-alias]
# Find your alias by running: sf org list

ALIAS=$1
sf org login web --target-org $ALIAS

TOKEN=$(sf org display --target-org $ALIAS --json \
  | python3 -c "import sys,json; print(json.load(sys.stdin)['result']['accessToken'])")

PART1="${TOKEN:0:255}"
PART2="${TOKEN:255}"

sf apex run --target-org $ALIAS << EOF
FertilityAgentConfig__c cfg = FertilityAgentConfig__c.getOrgDefaults();
cfg.AdminToken__c = '${PART1}';
cfg.AdminToken2__c = '${PART2}';
upsert cfg;
EOF

echo "Token refreshed successfully."
```

**How to run:**
```
bash token-refresh.sh fertility-demo
```

---

## Pre-Demo Checklist

**MuleSoft**
- [ ] Log in to Anypoint Runtime Manager — confirm app shows as **Running**
- [ ] Hit the CloudHub test endpoint — confirm it returns persona data
- [ ] If the app is sleeping (Micro worker idles), send one request to wake it (~10 sec first response)

**Salesforce**
- [ ] Run `bash token-refresh.sh [alias]` to refresh the admin token
- [ ] Open the chatbot in an **incognito window** — type "Give me my summary" and confirm it responds
- [ ] Open the internal dashboard in a separate tab (logged in as admin)
- [ ] Submit a test log from the chatbot and confirm it appears in the dashboard queue
- [ ] Schedule it from the dashboard and confirm the confirmation message appears in chat

**Tabs to have open at demo start:**
1. Incognito tab — chatbot (the persona view)
2. Main browser tab — internal dashboard
3. Agentforce Agent Builder — good for showing the "behind the scenes" story
4. Anypoint Runtime Manager — good for the MuleSoft story
