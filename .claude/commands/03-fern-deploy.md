# /03-fern-deploy — Deploy to CloudHub

Deploy the locally-built Mule app to CloudHub Sandbox so Salesforce has a live URL to connect to.

## Instructions

Run this in Claude Code from inside your Mule project directory.
Claude will read `fern-context.md` automatically — no manual value replacement needed.

---

```
Read fern-context.md — check the current directory first, then one level up.

My MuleSoft app is built and running locally in Anypoint Code Builder.
I need to deploy it to CloudHub Sandbox so Salesforce can call it.

Walk me through:
1. Verifying the pom.xml cloudHubDeployment config is correct —
   environment name, applicationName ({app_name}), workerType,
   region ({region}), businessGroupId ({business_group_id}),
   and connected app credentials
2. The exact Maven command to deploy
3. How to confirm the app is running in Anypoint Runtime Manager
4. What the public CloudHub URL will be
5. How to test the deployed endpoint with a curl call
   before wiring Salesforce to it

After confirming the app is running, write the exact CloudHub URL
directly into the cloudhub_url field in fern-context.md — do not
ask the user to paste it manually. The URL pattern is:
http://{app_name}.us-e1.cloudhub.io/api/v1 (adjust region code
if region is not us-east-1).

IMPORTANT: Use http://, not https://. CloudHub apps deployed with
default config only listen on HTTP. The Salesforce Named Credential
must also use http:// — if it says https://, all callouts will
return 502.
```

---

## FertilityConnect values (reference example)
- app-name = fertility-connect-emr
- environment = Sandbox
- base path = /api/v1
- public URL = https://fertility-connect-emr.us-e1.cloudhub.io/api/v1
- test endpoint = GET /api/v1/patients/P001
