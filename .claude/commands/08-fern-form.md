# /08-fern-form — Custom Object + Log Form + Real-Time Polling

Build the custom object, the inline log form LWC, and the polling pattern that closes the loop.

## Instructions

Run this in Claude Code from inside your Salesforce DX project directory.
Claude will read `fern-context.md` automatically — no manual value replacement needed.

---

```
Before proceeding, read fern-context.md and verify these fields are present and non-empty: org_alias, log_object, log_controller, form_component, chat_component, item_field, item_picklist, detail_field, occurred_at_field, persona_id_field. If any are missing, list them and stop.

Read fern-context.md — check the current directory first, then one level up.

I need a custom object {log_object} with these fields:
- {persona_id_field} (Text 50)
- {persona_name_field} (Text 100)
- {item_field} (Picklist: {item_picklist})
- {detail_field} (Text 50)
- {occurred_at_field} (DateTime)
- Notes__c (TextArea)
- RequestedFollowUpDate__c (DateTime)
- FollowUpDate__c (DateTime)
- Status__c (Picklist: Pending Review, Scheduled)

Also build an LWC called {form_component} that:
- Accepts personaId and personaName as @api properties
- Has fields for {item_field} (picklist), {detail_field},
  time (datetime-local defaulting to now in PT), and notes
- Includes a checkbox "Request a {follow_up_action}"
- If checked and the user submits, opens a confirmation modal
  showing a datetime picker pre-seeded to the next day at
  10:00 AM PT — user confirms before submitting
- Calls {log_controller}.submitLog via Apex on submit
- All datetime inputs display and submit in Pacific Time —
  convert PT input values to UTC before sending to Apex
- On success, fires a 'submitted' custom event to the parent
  with the relevant fields and logId
- On cancel, fires a 'cancel' custom event

Also add a polling pattern to {chat_component} that:
- Starts automatically when a 'submitted' event is received
  with a logId and a follow-up was requested
- Calls {log_controller}.getLatestStatus every 5 seconds,
  scoped to the specific logId (not a time window)
- Stops and shows this confirmation message in chat when
  Status__c = 'Scheduled': "{confirmation_message}"
- Stops polling when the component is disconnected
  to prevent memory leaks

After generating the custom object metadata and LWC files, deploy everything:
sf project deploy start --source-dir force-app/main/default --target-org {org_alias}
Capture the job ID from the deploy output. Then poll until complete:
sf project deploy report --job-id [job-id] --target-org {org_alias}
Run the report command every 10 seconds until status is Succeeded or Failed. Report the final status. Do not proceed past this step until deployment succeeds.
```

---

## FertilityConnect values (reference example)
- log_object = MedicationLog__c
- item_field = Medication__c (Menopur, Gonal-F, Cetrotide, Lupron, Progesterone, Ovidrel)
- detail_field = Dose__c, occurred_at_field = TakenAt__c
- form_component = medicationDoseForm, chat_component = fertilityChat
- follow_up_action = nurse callback
- confirmation_message = Your nurse has reviewed your note and will call you shortly.

## Key lesson
Platform Events don't work for Experience Cloud guest users — the polling pattern
scoped to a specific record ID is the correct solution. This is the most satisfying moment in the demo.
