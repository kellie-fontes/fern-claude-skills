# /02-fern-api — MuleSoft Mock API

Build and run a MuleSoft mock API in Anypoint Code Builder.

> Requires the MuleSoft MCP server to be connected. Check with `/mcp` if unsure.

---

```
Read fern-context.md — check the current directory first, then one level up.
Every `{variable}` in these instructions is a placeholder — replace it with the matching value from fern-context.md before running any command or generating any code.

Build a MuleSoft 4 application in Anypoint Code Builder that acts
as a mock {domain} API. It should have these endpoints:
- GET /{resource}/{id}
- GET /{resource}/{id}/{child_endpoint_1}
- GET /{resource}/{id}/{child_endpoint_2}
- GET /{resource}/{id}/{child_endpoint_3}
- GET /{resource}/{id}/summary

Use a central DataWeave module (dwl::mockData) for all mock data
so it's easy to update. Include realistic mock data for {persona_name}
({persona_id}) for a demo.
Add doc:name labels to every component so the canvas is readable
in Anypoint Code Builder.

The summary endpoint should aggregate data from multiple sources
in a single call. Use Try scopes with on-error-continue so one
source failing never breaks the response.

Structure the pom.xml for CloudHub 2.0 deployment using the Mule
Maven plugin with connected app credentials (client ID + secret,
client_credentials grant). Worker type Micro, 1 worker, region {region}.

Before writing the runtime version into pom.xml, call mcp__mulesoft__get_platform_insights
or mcp__mulesoft__search_asset to retrieve the list of supported CloudHub 2.0 Shared Space
runtimes. Select the latest available 4.x-java17 version from that list.
Do NOT hardcode a version — use only what MCP confirms is supported.
Write the selected runtime version to a comment in pom.xml so it is visible:
<!-- runtime: [version] — selected from MCP supported runtimes on [date] -->

Connected app client ID: {client_id}
Connected app client secret: {client_secret}
Business group ID: {business_group_id}
App name: {app_name}
```

---

## FertilityConnect values (reference example)
- domain = EMR
- resource = patients, persona = Sarah Mitchell (P001)
- child endpoints = medications, appointments, labs
- app-name = fertility-connect-emr
- runtime = resolved from MCP at build time (e.g. 4.9.12:5e-java17)
- region = us-east-1 (from fern-context.md)

## Tip
Be specific when asking for follow-up changes — "generate MUnit for this specific flow"
beats "generate MUnit for this file." Narrow scope = better output.
