# /11-fern-prep — Demo Prep + Token Refresh

Run this the morning of any demo. Claude handles the token refresh and health checks automatically — just tell it who you're demoing to.

---

```
Read fern-context.md — check the current directory first, then one level up.
Every `{variable}` in these instructions is a placeholder — replace it with the matching value from fern-context.md before running any command or generating any output.

Before generating the demo script, run these checks automatically:

1. REFRESH THE ADMIN TOKEN
   Check if token-refresh.sh exists in the same directory as fern-context.md or one level up.
   If it does not exist, write it now using the script template in this file (see HTML comment below).
   Make it executable and run it: bash token-refresh.sh
   Confirm: "✓ Admin token refreshed"
   If it fails, report the error and stop.

2. CHECK MULESOFT
   Call mcp__mulesoft__list_applications and filter for {app_name}.
   If status is RUNNING: confirm "✓ MuleSoft app running"
   If not: report the status and warn the user before continuing.
   Run: curl -s "{cloudhub_url}/{resource}/{persona_id}"
   If 200 + JSON: confirm "✓ CloudHub endpoint responding (worker warmed)"
   If not: report the response.

Once both checks pass, generate the demo brief:

I'm demoing {agent_name} to [audience] in [time]. Here's what works and what's broken: [list].

1. A demo script that plays to the working parts
2. Fallback talking points if something breaks live
3. The one-liner that explains the architecture in 10 seconds
4. Demo Links — exact URLs built from fern-context.md:
   - Chatbot (open in incognito): https://{org_domain}.my.site.com/{site_path}
   - Internal Dashboard: https://{org_domain}.my.salesforce.com/apex/{vf_page_name}
   - Agent Builder: https://{org_domain}.lightning.force.com → Setup → Agents
   - Anypoint Runtime Manager: https://anypoint.mulesoft.com → Runtime Manager → Applications
   - CloudHub test endpoint: {cloudhub_url}/{resource}/{persona_id}
5. Tabs to open before you start — using those exact links
```

---

## Pre-Demo Checklist

After the automated checks pass:

- [ ] Open the chatbot in an **incognito window** — type "Give me my summary" and confirm it responds
- [ ] Open the internal dashboard in a separate tab (logged in as admin)
- [ ] Submit a test log from the chatbot — confirm it appears in the dashboard queue
- [ ] Schedule it from the dashboard — confirm the confirmation message appears in chat
- [ ] Run `bash reset-demo.sh` to wipe the test records so the demo starts clean

**Tabs to have open at demo start:**
- [ ] Incognito tab — chatbot (persona view)
- [ ] Admin tab — internal dashboard
- [ ] Agent Builder — good for the "behind the scenes" moment
- [ ] Anypoint Runtime Manager — good for the MuleSoft story

---

<!-- CLAUDE AUTOMATION — token-refresh.sh template. Write this file if it doesn't exist, then run it.
#!/bin/bash
set -e

for CONTEXT in "$(dirname "$0")/fern-context.md" "$(dirname "$0")/../fern-context.md" "$HOME/fern-context.md"; do
  [ -f "$CONTEXT" ] && break
done
if [ ! -f "$CONTEXT" ]; then
  echo "ERROR: fern-context.md not found. Run /01-fern-design first."
  exit 1
fi

ALIAS=$(grep '^org_alias:' "$CONTEXT" | awk -F': ' '{print $2}' | xargs)
CUSTOM_SETTING=$(grep '^custom_setting:' "$CONTEXT" | awk -F': ' '{print $2}' | xargs)
ORG_DOMAIN=$(grep '^org_domain:' "$CONTEXT" | awk -F': ' '{print $2}' | xargs)

if [ -z "$ALIAS" ] || [ -z "$CUSTOM_SETTING" ] || [ -z "$ORG_DOMAIN" ]; then
  echo "ERROR: fern-context.md missing org_alias, custom_setting, or org_domain."
  exit 1
fi

echo "Refreshing token for $ALIAS..."
sf org login web --alias "$ALIAS" --instance-url "https://${ORG_DOMAIN}.my.salesforce.com" 2>&1 || true

SF_CREDS="$HOME/.sf/credentials.json"
if command -v jq &>/dev/null && [ -f "$SF_CREDS" ]; then
  TOKEN=$(jq -r --arg url "https://login.salesforce.com" '.[$url].accessToken // empty' "$SF_CREDS" 2>/dev/null)
fi
if [ -z "$TOKEN" ]; then
  TOKEN=$(echo "y" | sf org auth show-access-token --target-org "$ALIAS" 2>&1 | grep -o 'Access Token.*' | awk '{print $3}' | xargs 2>/dev/null)
fi
if [ -z "$TOKEN" ]; then
  echo "ERROR: Could not read access token. Complete the browser login and try again."
  exit 1
fi

TOKEN_LEN=${#TOKEN}
PART1="${TOKEN:0:255}"
PART2="${TOKEN:255}"

cat > /tmp/seed-token.apex << APEX
${CUSTOM_SETTING} cfg = ${CUSTOM_SETTING}.getOrgDefaults();
cfg.ApiHost__c = 'https://${ORG_DOMAIN}.my.salesforce.com';
cfg.AdminToken__c = '${PART1}';
cfg.AdminToken2__c = '${PART2}';
upsert cfg;
System.debug('Token stored. Length: ${TOKEN_LEN}');
APEX

sf apex run --target-org "$ALIAS" --file /tmp/seed-token.apex
rm -f /tmp/seed-token.apex
echo "Done — token refreshed for $ALIAS."
-->
