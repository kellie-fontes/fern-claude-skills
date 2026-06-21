# /09-fern-dashboard — Internal Back-Office Dashboard

Build the internal LWC dashboard hosted as a standalone URL via Visualforce + Lightning Out.

## Instructions

Run this in Claude Code from inside your Salesforce DX project directory.
Claude will read `fern-context.md` automatically — no manual value replacement needed.

---

```
Read fern-context.md from the project directory to load all context values.

Build an internal {internal_role} dashboard for managing pending
{log_object} records.

1. LWC called {dashboard_component} that:
   - Loads all {log_object} records where Status__c != 'Scheduled'
     via {log_controller}.getPendingLogs
   - Displays a table with: {dashboard_fields}
   - All DateTime values displayed in {dashboard_timezone} using
     the Intl API (not a hardcoded offset)
   - Smart inline scheduling per row:
     - If persona requested a time: show it with Confirm and Change
       buttons. Confirm uses their time immediately. Change reveals
       a datetime picker pre-seeded with their requested time.
     - If no requested time: show a blank datetime picker.
   - On confirm, calls {log_controller}.scheduleFollowUp,
     converting the picker value to UTC before sending
   - Refreshes the table after a successful schedule action

2. Aura app wrapper ({aura_app_name}) using ltng:outApp so the
   LWC can be mounted via Lightning Out

3. Visualforce page ({vf_page_name}) that:
   - Uses apex:includeLightning and $Lightning.use /
     $Lightning.createComponent
   - Mounts the dashboard LWC into a full-height div
   - Accessible at /apex/{vf_page_name} as a standalone internal URL
```

---

## FertilityConnect values (reference example)
- internal_role = nursing
- log_object = MedicationLog__c, log_controller = MedicationLogController
- dashboard_component = nursingEmrDashboard
- fields = Log #, Patient Name, Patient ID, Medication, Dose, Time Taken (PT), Requested Appt (PT), Symptoms/Notes, Status, Action
- dashboard_timezone = Pacific Time
- aura_app_name = NursingEmrApp, vf_page_name = NursingEMR
- standalone URL = /apex/NursingEMR

## Key lesson
LWC can't be surfaced as a standalone URL directly — wrap it in an Aura app (extends="ltng:outApp")
and mount it via a Visualforce page using Lightning Out. This gives you a shareable /apex/{vf_page_name}
URL that works without the full Lightning Experience shell.
