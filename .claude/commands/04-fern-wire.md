# /04-fern-wire — Agentforce Wiring

Connect the deployed MuleSoft API to Agentforce via External Service Registration,
Named Credential, External Credential, and permission set.

## Instructions

Run this in Claude Code from inside your Salesforce DX project directory.
Claude will read `fern-context.md` automatically — no manual value replacement needed.

---

```
Read fern-context.md — check the current directory first, then one level up.
Every `{variable}` in these instructions is a placeholder — replace it with the matching value from fern-context.md before running any command or generating any code.

My MuleSoft API is deployed at {cloudhub_url} with these endpoints:
- GET /{resource}/{id}
- GET /{resource}/{id}/{child_endpoint_1}
- GET /{resource}/{id}/{child_endpoint_2}
- GET /{resource}/{id}/{child_endpoint_3}
- GET /{resource}/{id}/summary

Create all the Salesforce metadata to wire it to Agentforce:

1. External Credential ({external_credential_name}) — Custom auth protocol,
   NoAuthentication variant, with an **Anonymous** parameter group (NOT NamedPrincipal)
2. Named Credential ({named_credential_name}) — SecuredEndpoint type pointing
   to {cloudhub_url}, linked to the External Credential, with merge fields
   allowed in body and header
3. ExternalServiceRegistration ({external_service_name}) — import the RAML 1.0
   spec from the Named Credential to auto-generate invocable actions
4. One GenAiFunction per endpoint with input/output schema.json
5. GenAiPlugin ({plugin_name}) grouping all functions under one topic
6. Permission set for the agent user granting access to the External Credential principal

Write the operation descriptions in the RAML spec to guide the
agent's routing decisions — be specific so the agent picks the
right endpoint for phrases like: {routing_phrase_1}, {routing_phrase_2}
```

---

## FertilityConnect values (reference example)
- cloudhub_url = http://fertility-connect-emr.us-e1.cloudhub.io/api/v1
- routing phrases = "how am I doing?" → summary, "tell me about Menopur" → medications
- external_credential_name = FertilityEMRv2
- named_credential_name = FertilityEMRApiv1
- plugin_name = FertilityEMRPlugin

## Key lessons
- The RAML spec operation descriptions are the agent's routing logic — write them as
  "Use when the {persona_role} asks [phrases]" not just "Returns [data]."
- External Credential principal type MUST be **Anonymous** for a NoAuthentication API.
  `NamedPrincipal` requires a stored per-user value — the Agentforce bot user has none,
  so every function call fails silently. Anonymous = shared by all users, no value needed.
- After deploying the ExternalCredential, grant the bot user's permission set access to
  the Anonymous principal explicitly — without this the callout still fails.
