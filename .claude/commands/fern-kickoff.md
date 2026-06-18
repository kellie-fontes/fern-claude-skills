# /fern-kickoff — Project Architecture Design

Design the full architecture for an Agentforce + MuleSoft + Experience Cloud demo
and write a populated `fern-context.md` to the project directory.

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
file to the project directory using the template from
~/.claude/commands/fern-context.md. Fill in every field you can
derive from the architecture. Leave credential fields
(client_id, client_secret, business_group_id, bot_id, cloudhub_url,
org_alias, org_domain) blank — I will fill those in before each step
that needs them.
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
bot_id:           # from Step 4B output
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

**2. `fern-context.md`** written to your project directory — all fields
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
