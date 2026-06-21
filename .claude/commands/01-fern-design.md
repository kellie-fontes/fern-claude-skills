# /01-fern-design — Project Architecture Design

Design the full architecture for an Agentforce + MuleSoft + Experience Cloud demo
and write a populated `fern-context.md` to the parent project directory.

---

## Step 1 — Describe your demo

Replace the values below and run this prompt:

```
I want to build a [industry] companion demo on Salesforce using
Agentforce + MuleSoft + Experience Cloud.

The persona is [name], a [role]. The AI companion is called [agent name].
The internal team who uses the back-office dashboard is [internal role].

Key flows I want to demo:
1. [flow 1]
2. [flow 2]
3. [flow 3]

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
cloudhub_url:           # filled after Step 3

## Salesforce Org
org_alias:              # sf CLI alias
org_domain:             # my.salesforce.com subdomain
bot_id:                 # filled after Step 4B

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

## Step 2 — Fill in credentials

Before running `/fern-api`, open `fern-context.md` and fill in:
```
client_id:
client_secret:
business_group_id:
org_alias:
org_domain:
```

Before running `/fern-wire`, add:
```
cloudhub_url:     # from Step 3 output
```

Before running `/fern-apex`, add:
```
bot_id:           # from Step 4 output
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
