# /09-fern-dashboard — Internal Back-Office Dashboard

Build the internal LWC dashboard hosted as a standalone URL via Visualforce + Lightning Out.

---

```
Before proceeding, read fern-context.md and verify these fields are present and non-empty: org_alias, log_object, log_controller, dashboard_component, dashboard_fields, dashboard_timezone, aura_app_name, vf_page_name. If any are missing, list them and stop.

Read fern-context.md — check the current directory first, then one level up.
Every `{variable}` in these instructions is a placeholder — replace it with the matching value from fern-context.md before running any command or generating any code.

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

After generating the dashboard LWC, Aura wrapper, and Visualforce page, deploy everything:
sf project deploy start --source-dir force-app/main/default --target-org {org_alias}
Capture the job ID from the deploy output. Then poll until complete:
sf project deploy report --job-id [job-id] --target-org {org_alias}
Run the report command every 10 seconds until status is Succeeded or Failed. Report the final status. On success, open the dashboard directly:
sf org open --path /apex/{vf_page_name} --target-org {org_alias}
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
