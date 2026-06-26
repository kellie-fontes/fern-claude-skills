# /01-fern-design — Project Architecture Design

Design the full architecture for an Agentforce + MuleSoft + Experience Cloud demo
and write a populated `fern-context.md` to the parent project directory.

---

## Step 1 — Describe your demo

Before showing the template, print exactly this to help the user fill it in:

---
**Before you fill in the template, here's what each flow should look like:**

| Slot | Shape | Examples |
|---|---|---|
| **Flow 1** | Persona asks the agent to look something up | "Patient asks about upcoming appointments and lab results" · "Loan applicant checks their application status" · "Loyalty member asks for their points balance" |
| **Flow 2** | Persona takes an action (logs, requests, submits) | "Patient logs a medication dose and requests a nurse callback" · "Applicant uploads a document and requests a status update" · "Member redeems points for a reward" |
| **Flow 3** | Internal team reviews and responds | "Nurse reviews the log and schedules a follow-up" · "Loan officer reviews the document and approves the next step" · "Support agent confirms the redemption" |

Each flow maps to one API endpoint — keep each one to a single sentence describing who does what.

---
Now fill in the template below and paste it back:

---

```
Before proceeding, check that fern-context.md exists in the current directory or one level up. If it does not exist yet, that is expected for Step 1 — proceed with the design. If it does exist, read it to understand the existing architecture before making changes.

I want to build a [industry] companion demo on Salesforce using
Agentforce + MuleSoft + Experience Cloud.

The persona is [name], a [role]. The AI companion is called [agent name].
The internal team who uses the back-office dashboard is [internal role].

Key flows I want to demo:
1. [flow 1 — what does the persona ask or do? e.g. "Patient asks the agent about her upcoming appointments"]
2. [flow 2 — what action does the persona take? e.g. "Patient logs a medication dose and requests a nurse callback"]
3. [flow 3 — what does the internal team do in response? e.g. "Nurse reviews the log and schedules a follow-up"]

Design the full architecture including:
- MuleSoft: what mock API endpoints to build and what data model each needs
- Salesforce: what custom objects, custom settings, Apex controllers,
  LWCs, and GenAI functions are required
- Integration layer: Named Credential, External Credential, External
  Service Registration, and Remote Site Settings needed to connect
  MuleSoft to Agentforce
- Experience Cloud: what the guest-facing site needs and how the
  guest user authentication pattern works
- Back-office: what internal tooling the [internal role] needs

Don't generate any code yet — just map the full dependency order
so I know what to build first.

After designing the architecture, write a populated fern-context.md
file to the parent directory (one level above the current project)
using this template. Fill in every field
you can derive from the architecture. Leave credential fields
(client_id, client_secret, business_group_id, bot_id, cloudhub_url,
org_alias, org_domain) blank — I will fill those in before each step
that needs them.

When writing fern-context.md, derive and fill ALL fields you can from the architecture — including external_credential_name, named_credential_name, external_service_name, custom_setting, agent_controller, log_controller, log_object, plugin_name, all branding fields, all log object fields, and all dashboard fields. Do not leave these blank.

After writing fern-context.md, run the following to auto-populate org credentials:
1. Run: sf org list --json
2. If exactly one org is found, extract its alias and instanceUrl. Write alias to org_alias and extract the subdomain (the part before .my.salesforce.com) to org_domain in fern-context.md.
3. If multiple orgs are found, list them and ask which one to use, then write the selected values.
4. If no orgs are found, leave org_alias and org_domain blank and tell the user to run sf org login web first.
5. Call mcp__mulesoft__get_platform_insights to retrieve the Anypoint business group ID. If successful, write the result to business_group_id in fern-context.md. If the call fails or returns no ID, leave it blank and note that the user must fill it in manually from Anypoint Platform → Access Management.

## Persona & Agent
industry:
persona_name:
persona_role:
persona_id:             # static demo ID injected as context (e.g. P001)
agent_name:             # name shown in the UI (e.g. Fern)
agent_label:            # Salesforce metadata label (e.g. Fertility Support Agent 2)
agent_developer_name:   # Salesforce API name, underscores only
company_name:           # org/company name in agent role prompt
internal_role:          # who uses the back-office dashboard (e.g. nursing team)

## Demo Flows
flow_1:
flow_2:
flow_3:

## Anypoint / MuleSoft
client_id:              # connected app client ID
client_secret:          # connected app client secret
business_group_id:      # Anypoint business group ID
app_name:               # CloudHub app name (e.g. fertility-connect-emr)
environment:            Sandbox
region:                 us-east-1
domain:                 # API domain label (e.g. EMR, CRM, Loans)

## API Shape
resource:               # top-level REST resource (e.g. patients, accounts, orders)
child_endpoint_1:
child_endpoint_2:
child_endpoint_3:
routing_phrase_1:       # e.g. "how am I doing?" → summary
routing_phrase_2:       # e.g. "tell me about Menopur" → child_endpoint_1
cloudhub_url:           # auto-populated in Step 3 after CloudHub deploy verified

## Salesforce Org
org_alias:              # auto-populated in Step 1 via sf org list
org_domain:             # auto-populated in Step 1 via sf org list
bot_id:                 # auto-populated in Step 5B via Tooling API after activation
site_path:              # auto-populated in Step 7 via sf data query Network

## Salesforce Metadata Names
external_credential_name:
named_credential_name:
external_service_name:
custom_setting:         # e.g. AgentConfig__c
agent_controller:       # e.g. AgentController
log_controller:         # e.g. LogController
log_object:             # e.g. Log__c
plugin_name:

## Branding
primary_color:          # persona-facing hex (e.g. #7c4d8e)
secondary_color:        # internal dashboard hex (e.g. #1a3a5c)
chat_component:         # LWC name for chat UI
form_component:         # LWC name for log form
dashboard_component:    # LWC name for internal dashboard
trigger_phrases:        # comma-separated phrases that open the inline form
follow_up_action:       # what the persona requests (e.g. nurse callback)
confirmation_message:   # chat message shown when follow-up is confirmed

## Log Object Fields
persona_id_field:       # e.g. PatientId__c
persona_name_field:     # e.g. PatientName__c
item_field:             # e.g. Medication__c
item_picklist:          # comma-separated picklist values
detail_field:           # e.g. Dose__c
occurred_at_field:      # e.g. TakenAt__c
notes_field:            # e.g. Symptoms__c

## Internal Dashboard
dashboard_timezone:     # e.g. Pacific Time
aura_app_name:          # e.g. NursingEmrApp
vf_page_name:           # e.g. NursingEMR
dashboard_fields:       # comma-separated display columns
```

---

## Fill in credentials

Before running `/02-fern-api`, open `fern-context.md` and confirm these are filled in
(most will be auto-populated — only fill any that are still blank):
```
client_id:          # Anypoint connected app client ID
client_secret:      # Anypoint connected app client secret
business_group_id:  # If blank: Anypoint Platform → Access Management → Business Groups → copy the ID from the URL
org_alias:          # auto-populated from sf org list — fill if blank
org_domain:         # auto-populated from sf org list — fill if blank (subdomain before .my.salesforce.com)
```

Before running `/04-fern-wire`, confirm:
```
cloudhub_url:     # auto-written by Step 3 — verify it's present
```

Before running `/06-fern-apex`, confirm:
```
bot_id:           # auto-written by Step 5B via Tooling API — verify it's present
                  # if missing: Setup → Agents → open agent in Agent Builder → copy 18-char ID from the URL
```

---

## Expected output

Running this step produces two things:

**1. Architecture summary** — a structured breakdown covering:

```
MuleSoft Mock API
  GET /{resource}/{id}
  GET /{resource}/{id}/{child1}
  GET /{resource}/{id}/{child2}
  GET /{resource}/{id}/{child3}
  GET /{resource}/{id}/summary
  → each endpoint lists its mock data fields

Salesforce
  Custom Object: {Log__c} with all fields
  Custom Setting: {AgentConfig__c} — AdminToken, ApiHost
  Apex Controllers: {AgentController}, {LogController}
  LWCs: {chatComponent}, {formComponent}, {dashboardComponent}
  GenAI Functions: one per endpoint, with routing phrase guidance
  GenAI Plugin: groups all functions under one topic

Integration Layer
  External Credential → Named Credential → External Service Registration
  Remote Site Settings: api.salesforce.com + org domain

Experience Cloud
  Guest-access site (no login)
  Guest user profile permissions
  Trigger phrases that swap chat for the inline form

Back-Office Dashboard
  Aura app + Visualforce page → /apex/{PageName}
  Table of pending {Log__c} records with inline scheduling

Build order (dependency chain, step by step)
```

**2. `fern-context.md`** written to your parent project folder — all fields
populated from the architecture. Credential fields left blank for you to fill.

---

## Flow examples across industries

Each flow should map to one of these three shapes — pick what fits your industry:

| Flow | Shape | Examples across industries |
|---|---|---|
| **Flow 1** | Persona asks the agent to look something up | "Patient asks about upcoming appointments and lab results" · "Loan applicant checks their application status" · "Loyalty member asks for their points balance and recent transactions" |
| **Flow 2** | Persona takes an action (logs, requests, submits) | "Patient logs a medication dose and requests a nurse callback" · "Applicant uploads a document and requests a status update" · "Member redeems points for a reward" |
| **Flow 3** | Internal team responds (reviews, schedules, approves) | "Nurse reviews the log and schedules a follow-up" · "Loan officer reviews the document and approves the next step" · "Support agent reviews the redemption and confirms fulfillment" |

The three flows map directly to: (1) a GET summary endpoint, (2) a POST/action endpoint, (3) the internal dashboard. Keep each flow one sentence — Claude uses them to name the API endpoints, functions, and LWC components.

---

## FertilityConnect reference example (input → output)

**Input values:**
- industry = Health & Life Sciences / Fertility
- persona = Sarah Mitchell, a fertility patient
- agent = Fern
- internal role = nursing team
- flow 1 = Patient asks Fern about her upcoming appointments and lab results
- flow 2 = Patient logs a medication dose and requests a nurse callback
- flow 3 = Nurse reviews the dose log and schedules a follow-up appointment

**Output fern-context.md (key fields):**
```
persona_name:           Sarah Mitchell
persona_role:           fertility patient
persona_id:             P001
agent_name:             Fern
agent_label:            Fertility Support Agent 2
agent_developer_name:   Fertility_Support_Agent_2
company_name:           Bloom Fertility
internal_role:          nursing team

resource:               patients
child_endpoint_1:       medications
child_endpoint_2:       appointments
child_endpoint_3:       labs

custom_setting:         FertilityAgentConfig__c
agent_controller:       FertilityAgentController
log_controller:         MedicationLogController
log_object:             MedicationLog__c
plugin_name:            FertilityEMRPlugin

primary_color:          #7c4d8e
secondary_color:        #1a3a5c
chat_component:         fertilityChat
form_component:         medicationDoseForm
dashboard_component:    nursingEmrDashboard
trigger_phrases:        "log my dose", "log a dose", "i took"
follow_up_action:       nurse callback
confirmation_message:   Your nurse has reviewed your note and will call you shortly.

aura_app_name:          NursingEmrApp
vf_page_name:           NursingEMR
```

---

## Tip
The architecture output from this step IS the fern-context.md — every
downstream skill reads from that file. Getting the names right here
(API resource, object names, component names) avoids rename churn later.
