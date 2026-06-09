# /fern-deploy — Deploy to CloudHub

Deploy the locally-built Mule app to CloudHub Sandbox so Salesforce has a live URL to connect to.

## Instructions

Run this in Claude Code from inside your Mule project directory. Replace all [bracketed values] with your own before running.

---

```
My MuleSoft app is built and running locally in Anypoint Code Builder.
I need to deploy it to CloudHub Sandbox so Salesforce can call it.

Walk me through:
1. Verifying the pom.xml cloudHubDeployment config is correct —
   environment name, applicationName, workerType, region,
   businessGroupId, and connected app credentials
2. The exact Maven command to deploy
3. How to confirm the app is running in Anypoint Runtime Manager
4. What the public CloudHub URL will be (pattern:
   https://[app-name].[region-code].cloudhub.io)
5. How to test the deployed endpoint with a curl call
   before wiring Salesforce to it

My app name is [app-name], environment is [environment],
businessGroupId is [id].
```

## FertilityConnect values (working example)
- app-name = fertility-connect-emr
- environment = Sandbox
- base path = /api/v1
- public URL = http://fertility-connect-emr.us-e1.cloudhub.io/api/v1
- test endpoint = GET /api/v1/patients/P001
