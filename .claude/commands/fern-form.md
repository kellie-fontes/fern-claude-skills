# /fern-form — Custom Object + Log Form + Real-Time Polling

Build the custom object, the inline log form LWC, and the polling pattern that closes the loop.

## Instructions

Run this in Claude Code from inside your Salesforce DX project directory. Replace all [bracketed values] with your own before running.

---

```
I need a custom object [Log__c] with these fields:
- [PersonaId__c] (Text 50)
- [PersonaName__c] (Text 100)
- [Item__c] (Picklist: [list])
- [Detail__c] (Text 50)
- [OccurredAt__c] (DateTime)
- [Notes__c] (TextArea)
- [RequestedFollowUpDate__c] (DateTime)
- [FollowUpDate__c] (DateTime)
- Status__c (Picklist: Pending Review, Scheduled)

Also build an LWC called [formComponentName] that:
- Accepts personaId and personaName as @api properties
- Has fields for [item] (picklist), [detail], time (datetime-local
  defaulting to now in PT), and notes
- Includes a checkbox "Request a [follow-up action]"
- If checked and the user submits, opens a confirmation modal
  showing a datetime picker pre-seeded to the next day at
  10:00 AM PT — user confirms before submitting
- Calls [LogController].submitLog via Apex on submit
- All datetime inputs display and submit in Pacific Time —
  convert PT input values to UTC before sending to Apex
- On success, fires a 'submitted' custom event to the parent
  with { item, detail, requestFollowUp, logId }
- On cancel, fires a 'cancel' custom event

Also add a polling pattern to [chatComponentName] that:
- Starts automatically when a 'submitted' event is received
  with a logId and requestFollowUp=true
- Calls [LogController].getLatestStatus every 5 seconds,
  scoped to the specific logId (not a time window)
- Stops and fires a confirmation message in chat when
  Status__c = 'Scheduled' on that record
- Stops polling when the component is disconnected
  to prevent memory leaks
```

## FertilityConnect values (working example)
- Log__c = MedicationLog__c
- PersonaId__c = PatientId__c, PersonaName__c = PatientName__c
- Item__c = Medication__c (picklist: Menopur, Gonal-F, Cetrotide, Lupron, Progesterone, Ovidrel)
- Detail__c = Dose__c
- OccurredAt__c = TakenAt__c
- Notes__c = Symptoms__c
- formComponentName = medicationDoseForm
- chatComponentName = fertilityChat
- follow-up action = nurse callback
- callback message = "Your nurse has reviewed your note and will call you shortly."

## Key lesson
Platform Events don't work for Experience Cloud guest users — the polling pattern scoped to a specific record ID is the correct solution. This is the most satisfying moment in the demo.
