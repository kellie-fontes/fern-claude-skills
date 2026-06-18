# /fern-apex — Apex Controllers + Custom Setting + Remote Sites

Build the Apex backend that lets Experience Cloud guest users talk to Agentforce.

## Instructions

Run this in Claude Code from inside your Salesforce DX project directory.
Claude will read `fern-context.md` automatically — no manual value replacement needed.

---

```
Read fern-context.md from the project directory to load all context values.

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
The admin token is a live session cookie that expires — see /fern-prep for the automated token refresh script.
