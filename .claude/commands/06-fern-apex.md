# /06-fern-apex — Apex Controllers + Custom Setting + Remote Sites

Build the Apex backend that lets Experience Cloud guest users talk to Agentforce.

## Instructions

Run this in Claude Code from inside your Salesforce DX project directory.
Claude will read `fern-context.md` automatically — no manual value replacement needed.

---

```
Before proceeding, read fern-context.md and verify these fields are present and non-empty: org_alias, org_domain, bot_id, agent_controller, log_controller, custom_setting, log_object. If any are missing, list them and stop.

Read fern-context.md — check the current directory first, then one level up.
Every `{variable}` in these instructions is a placeholder — replace it with the matching value from fern-context.md before running any command or generating any code.

I need the Apex backend that lets Experience Cloud guest users
talk to Agentforce. Build the following:

1. {custom_setting} — a Hierarchy Custom Setting with:
   - AdminToken__c (Text 255) — first half of the admin session token
   - AdminToken2__c (Text 255) — second half (tokens exceed 255 chars)
   - ApiHost__c (Text 100) — org instance URL

2. {agent_controller} — an Apex class with:
   - getPersonaInfo() — returns hardcoded {persona_name} and {persona_id}
     for the demo
   - sendMessage(personaId, message, sessionId) — orchestrates:
     a. Read and concatenate AdminToken__c + AdminToken2__c
     b. POST to {org_domain}.my.salesforce.com/agentforce/bootstrap/nameduser
        with Cookie: sid=[token] to exchange for a JWT
     c. If no sessionId, POST to the Agents API to create a session
     d. POST the message to the session and return the reply text
        and sessionId
   - All callouts must work for Experience Cloud guest users

3. {log_controller} — an Apex class with:
   - submitLog(...) — inserts a {log_object} record, parsing all
     DateTime values explicitly from UTC ISO strings
   - getPendingLogs() — returns pending records using a
     without sharing inner class so guest-submitted records
     are visible to internal users
   - getLatestStatus(personaId, logId) — polls for a status
     change on a specific log record

4. Remote Site Settings for:
   - https://api.salesforce.com (Agentforce API)
   - https://{org_domain}.my.salesforce.com (bootstrap endpoint)

Agent bot ID: {bot_id}

After generating all Apex classes, custom settings, and remote site settings, deploy everything:
sf project deploy start --source-dir force-app/main/default --target-org {org_alias}
Capture the job ID from the deploy output. Then poll until complete:
sf project deploy report --job-id [job-id] --target-org {org_alias}
Run the report command every 10 seconds until status is Succeeded or Failed. Report the final status. Do not proceed past this step until deployment succeeds.
```

---

## FertilityConnect values (reference example)
- custom_setting = FertilityAgentConfig__c
- agent_controller = FertilityAgentController
- log_controller = MedicationLogController
- log_object = MedicationLog__c
- persona = Sarah Mitchell, patientId = P001
- bot_id = 0XxHo000000Phw4KAC
- agent API base = https://api.salesforce.com/einstein/ai-agent/v1

## Key lesson
The admin token is a live session cookie that expires — see /11-fern-prep for the automated token refresh script.
