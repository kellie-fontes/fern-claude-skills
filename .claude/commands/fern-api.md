# /fern-api — MuleSoft Mock API

Build and run a MuleSoft mock API in Anypoint Code Builder.

## Instructions

Run this in Claude Code with the MuleSoft MCP server connected. Replace all [bracketed values] with your own before running.

---

```
Build a MuleSoft 4 application in Anypoint Code Builder that acts
as a mock [domain] API. It should have these endpoints:
- GET /[resource]/{id}
- GET /[resource]/{id}/[child1]
- GET /[resource]/{id}/[child2]
- GET /[resource]/{id}/[child3]
- GET /[resource]/{id}/summary

Use a central DataWeave module (dwl::mockData) for all mock data
so it's easy to update. Include realistic mock data for a demo.
Add doc:name labels to every component so the canvas is readable
in Anypoint Code Builder.

The summary endpoint should aggregate data from multiple sources
in a single call. Use Try scopes with on-error-continue so one
source failing never breaks the response.

Structure the pom.xml for CloudHub 2.0 deployment using the Mule
Maven plugin with connected app credentials (client ID + secret,
client_credentials grant). Target runtime 4.9-java17, worker
type Micro, 1 worker, region us-east-1.

My Anypoint connected app client ID is [client-id] and client
secret is [client-secret]. My business group ID is [business-group-id].
My app name will be [app-name].
```

## FertilityConnect values (working example)
- domain = EMR
- resource = patients
- child endpoints = medications, appointments, cycles, results, care-summary
- app-name = fertility-connect-emr
- runtime = 4.9-java17
- region = us-east-1

## Tip
Be specific when asking for follow-up changes — "generate MUnit for this specific flow" beats "generate MUnit for this file." Narrow scope = better output.
