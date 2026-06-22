# /11-fern-prep — Demo Prep + Token Refresh

Everything to check the morning of any demo.

---

## Demo Script Prompt

```
Read fern-context.md — check the current directory first, then one level up.

I'm demoing {agent_name} to [audience] in [time]. Here's what works and
what's broken: [list].

Give me:
1. A demo script that plays to the working parts
2. Fallback talking points if something breaks live
3. The one-liner that explains the architecture in 10 seconds
4. A "Demo Links" section with the exact URLs I need, built from fern-context.md values:
   - Chatbot (open in incognito): https://{org_domain}.my.site.com/[site-path]
   - Internal Dashboard: https://{org_domain}.my.salesforce.com/apex/{vf_page_name}
   - Agentforce Agent Builder: https://{org_domain}.lightning.force.com → Setup → Agents
   - Anypoint Runtime Manager: https://anypoint.mulesoft.com → Runtime Manager → Applications
   - CloudHub test endpoint: {cloudhub_url}/{resource}/{persona_id}
5. A "Tabs to open before you start" checklist using those exact links
```

---

## Your Demo Links

These are built from your `fern-context.md` values — update that file and these resolve automatically when you run the demo script prompt above.

| What | URL |
|---|---|
| Chatbot (persona view — incognito) | https://{org_domain}.my.site.com/ |
| Internal Dashboard | https://{org_domain}.my.salesforce.com/apex/{vf_page_name} — **use org domain, NOT site domain** |
| Agentforce Agent Builder | https://{org_domain}.lightning.force.com → Setup → Agents |
| Anypoint Runtime Manager | https://anypoint.mulesoft.com → Runtime Manager → Applications |
| CloudHub test endpoint | {cloudhub_url}/{resource}/{persona_id} |

---

## Admin Token Refresh

The chatbot authenticates to Agentforce using a Salesforce admin session token stored in a Custom Setting.
**It expires when you log out or after inactivity — refresh it every morning before a demo.**

Read fern-context.md — check the current directory first, then one level up.

Write the script below as `token-refresh.sh` in the same directory as fern-context.md. Do not ask the user to copy it manually — create the file directly, make it executable with `chmod +x`, then run it immediately with `bash token-refresh.sh`. Confirm the token was stored successfully.

```bash
#!/bin/bash
# Usage: bash token-refresh.sh
# Reads org_alias, custom_setting, and org_domain from fern-context.md

set -e

# Find fern-context.md — check project root, one level up, or home
for CONTEXT in "$(dirname "$0")/fern-context.md" "$(dirname "$0")/../fern-context.md" "$HOME/fern-context.md"; do
  [ -f "$CONTEXT" ] && break
done
if [ ! -f "$CONTEXT" ]; then
  echo "ERROR: fern-context.md not found. Run /01-fern-design first to generate it."
  exit 1
fi

ALIAS=$(grep '^org_alias:' "$CONTEXT" | awk -F': ' '{print $2}' | xargs)
CUSTOM_SETTING=$(grep '^custom_setting:' "$CONTEXT" | awk -F': ' '{print $2}' | xargs)
ORG_DOMAIN=$(grep '^org_domain:' "$CONTEXT" | awk -F': ' '{print $2}' | xargs)

echo "Org alias:      $ALIAS"
echo "Custom setting: $CUSTOM_SETTING"
echo "Org domain:     $ORG_DOMAIN"
echo ""

echo "Opening browser login for $ALIAS..."
sf org login web --alias "$ALIAS" --instance-url "https://${ORG_DOMAIN}.my.salesforce.com" 2>&1 || true

echo "Reading access token..."
# Try jq on credentials file first (more reliable than parsing CLI table output)
SF_CREDS="$HOME/.sf/credentials.json"
SFDX_CREDS="$HOME/.sfdx/sfdx-config.json"
if command -v jq &>/dev/null && [ -f "$SF_CREDS" ]; then
  TOKEN=$(jq -r --arg url "https://login.salesforce.com" '.[$url].accessToken // empty' "$SF_CREDS" 2>/dev/null)
fi
# Fallback: parse from sf auth show-access-token
if [ -z "$TOKEN" ]; then
  TOKEN=$(echo "y" | sf org auth show-access-token --target-org "$ALIAS" 2>&1 | grep -o 'Access Token.*' | awk '{print $3}' | xargs 2>/dev/null)
fi
if [ -z "$TOKEN" ]; then
  echo "ERROR: Could not read access token. Make sure you completed the browser login."
  exit 1
fi

TOKEN_LEN=${#TOKEN}
PART1="${TOKEN:0:255}"
PART2="${TOKEN:255}"

echo "Token length:   $TOKEN_LEN chars"
echo "Writing to $CUSTOM_SETTING..."

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

echo ""
echo "Done — token refreshed for $ALIAS."
echo ""
echo "Verify: open an incognito window and go to:"
echo "  https://${ORG_DOMAIN}.my.site.com/[your-site-path]"
echo "Type 'give me my summary' — the agent should respond within 5 seconds."
```


---

## Pre-Demo Checklist

**MuleSoft**

Run these automated checks before the demo:
1. Call mcp__mulesoft__list_applications and filter for {app_name} — confirm status is RUNNING.
2. Run: curl -s "{cloudhub_url}/{resource}/{persona_id}" — confirm 200 + non-empty JSON. This also warms the Micro worker.
If either check fails, report it immediately so the issue can be fixed before the audience arrives.

- [ ] Log in to Anypoint Runtime Manager — confirm app shows as **Running**
- [ ] Hit the CloudHub test endpoint — confirm it returns persona data
- [ ] If the app is sleeping (Micro worker idles), send one request to wake it (~10 sec first response)

**Salesforce**
- [ ] Run `bash token-refresh.sh` to refresh the admin token
- [ ] Open the chatbot in an **incognito window** — type "Give me my summary" and confirm it responds
- [ ] Open the internal dashboard in a separate tab (logged in as admin)
- [ ] Submit a test log from the chatbot and confirm it appears in the dashboard queue
- [ ] Schedule it from the dashboard and confirm the confirmation message appears in chat
- [ ] Run `bash reset-demo.sh` to wipe the test records — demo starts clean

**Tabs to have open at demo start:**
- [ ] Incognito tab — chatbot (the persona view)
- [ ] Main browser tab — internal dashboard
- [ ] Agentforce Agent Builder — good for showing the "behind the scenes" story
- [ ] Anypoint Runtime Manager — good for the MuleSoft story
