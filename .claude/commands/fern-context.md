# /fern-context — Industry Context Template

This file is the single source of truth for a Fern demo build.
`/fern-kickoff` generates a populated copy in your project directory.
Every other `/fern-*` skill reads from it automatically.

---

## How to use

**Starting fresh for a new industry:**
1. Run `/fern-kickoff` with your industry values — it writes `fern-context.md` to your project directory
2. Run each subsequent `/fern-*` skill — Claude reads `fern-context.md` and fills in all placeholders automatically

**Adapting an existing build:**
Edit `fern-context.md` in your project directory, then re-run any skill.

---

## Template (copy this into your project as `fern-context.md`)

```
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

## FertilityConnect reference (filled example)

```
## Persona & Agent
industry:               Health & Life Sciences / Fertility
persona_name:           Sarah Mitchell
persona_role:           fertility patient
persona_id:             P001
agent_name:             Fern
agent_label:            Fertility Support Agent 2
agent_developer_name:   Fertility_Support_Agent_2
company_name:           Bloom Fertility
internal_role:          nursing team

## Demo Flows
flow_1:                 Patient asks Fern about her upcoming appointments and lab results
flow_2:                 Patient logs a medication dose and requests a nurse callback
flow_3:                 Nurse reviews the dose log and schedules a follow-up appointment

## Anypoint / MuleSoft
client_id:              [your client ID]
client_secret:          [your client secret]
business_group_id:      [your business group ID]
app_name:               fertility-connect-emr
environment:            Sandbox
region:                 us-east-1
domain:                 EMR

## API Shape
resource:               patients
child_endpoint_1:       medications
child_endpoint_2:       appointments
child_endpoint_3:       labs
routing_phrase_1:       "how am I doing?" → summary
routing_phrase_2:       "tell me about Menopur" → medications
cloudhub_url:           https://fertility-connect-emr.us-e1.cloudhub.io/api/v1

## Salesforce Org
org_alias:              fertility-demo
org_domain:             kfontes-mule-agtforce-demo
bot_id:                 0XxHo000000Phw4KAC

## Salesforce Metadata Names
external_credential_name:  FertilityEMRv2
named_credential_name:     FertilityEMRApiv1
external_service_name:     FertilityEMRApiv1
custom_setting:            FertilityAgentConfig__c
agent_controller:          FertilityAgentController
log_controller:            MedicationLogController
log_object:                MedicationLog__c
plugin_name:               FertilityEMRPlugin

## Branding
primary_color:          #7c4d8e
secondary_color:        #1a3a5c
chat_component:         fertilityChat
form_component:         medicationDoseForm
dashboard_component:    nursingEmrDashboard
trigger_phrases:        "log my dose", "log a dose", "i took"
follow_up_action:       nurse callback
confirmation_message:   Your nurse has reviewed your note and will call you shortly.

## Log Object Fields
persona_id_field:       PatientId__c
persona_name_field:     PatientName__c
item_field:             Medication__c
item_picklist:          Menopur, Gonal-F, Cetrotide, Lupron, Progesterone, Ovidrel
detail_field:           Dose__c
occurred_at_field:      TakenAt__c
notes_field:            Symptoms__c

## Internal Dashboard
dashboard_timezone:     Pacific Time
aura_app_name:          NursingEmrApp
vf_page_name:           NursingEMR
dashboard_fields:       Log #, Patient Name, Patient ID, Medication, Dose, Time Taken (PT), Requested Appt (PT), Symptoms/Notes, Status, Action
```
