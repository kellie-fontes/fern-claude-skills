# /fern-dashboard — Internal Back-Office Dashboard

Build the internal LWC dashboard hosted as a standalone URL via Visualforce + Lightning Out.

## Instructions

Run this in Claude Code from inside your Salesforce DX project directory. Replace all [bracketed values] with your own before running.

---

```
Build an internal [team] dashboard for managing pending [Log__c] records.

1. LWC called [dashboardComponentName] that:
   - Loads all [Log__c] records where Status__c != 'Scheduled'
     via [LogController].getPendingLogs
   - Displays a table with: [field list]
   - All DateTime values displayed in [timezone] using Intl API
     (not hardcoded offset)
   - Smart inline scheduling per row:
     - If persona requested a time: show it with Confirm and Change
       buttons. Confirm uses their time immediately. Change reveals
       a datetime picker pre-seeded with their requested time.
     - If no requested time: show a blank datetime picker.
   - On confirm, calls [LogController].scheduleFollowUp,
     converting the picker value to UTC before sending
   - Refreshes the table after a successful schedule action

2. Aura app wrapper ([AuraAppName]) using ltng:outApp so the
   LWC can be mounted via Lightning Out

3. Visualforce page ([PageName]) that:
   - Uses apex:includeLightning and $Lightning.use /
     $Lightning.createComponent
   - Mounts the dashboard LWC into a full-height div
   - Accessible at /apex/[PageName] as a standalone internal URL
```

## FertilityConnect values (working example)
- team = nursing
- Log__c = MedicationLog__c
- dashboardComponentName = nursingEmrDashboard
- LogController = MedicationLogController
- fields = Log #, Patient Name, Patient ID, Medication, Dose, Time Taken (PT), Requested Appt (PT), Symptoms/Notes, Status, Action
- timezone = Pacific Time
- AuraAppName = NursingEmrApp
- PageName = NursingEMR
- standalone URL = /apex/NursingEMR

## Key lesson
LWC can't be surfaced as a standalone URL directly — wrap it in an Aura app (extends="ltng:outApp") and mount it via a Visualforce page using Lightning Out. This gives you a shareable /apex/[PageName] URL that works without the full Lightning Experience shell.
