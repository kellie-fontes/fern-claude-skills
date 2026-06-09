# /fern-wire — Agentforce Wiring

Connect the deployed MuleSoft API to Agentforce via External Service Registration, Named Credential, External Credential, and permission set.

## Instructions

Run this in Claude Code from inside your Salesforce DX project directory. Replace all [bracketed values] with your own before running.

---

```
My MuleSoft API is deployed at [CloudHub URL] with these endpoints:
- GET /[resource]/{id}
- GET /[resource]/{id}/[child1]
- GET /[resource]/{id}/[child2]
- GET /[resource]/{id}/[child3]
- GET /[resource]/{id}/summary

Create all the Salesforce metadata to wire it to Agentforce:

1. External Credential — Custom auth protocol, NoAuthentication
   variant, with a NamedPrincipal parameter group
2. Named Credential — SecuredEndpoint type pointing to [URL],
   linked to the External Credential, with merge fields allowed
   in body and header
3. ExternalServiceRegistration — import the RAML 1.0 spec from
   the Named Credential to auto-generate invocable actions
4. One GenAiFunction per endpoint with input/output schema.json
5. GenAiPlugin grouping all functions under one topic
6. Permission set for the agent user granting access to the
   External Credential principal

Write the operation descriptions in the RAML spec to guide the
agent's routing decisions — be specific so the agent picks the
right endpoint for phrases like [example phrases].
```

## FertilityConnect values (working example)
- CloudHub URL = http://fertility-connect-emr.us-e1.cloudhub.io/api/v1
- routing phrases = "how am I doing?" → summary, "tell me about Menopur" → medications
- External Credential name = FertilityEMRv2
- Named Credential name = FertilityEMRApiv1
- External Service Registration name = FertilityEMRApiv1

## Key lesson
The RAML spec operation descriptions are the agent's routing logic — write them as "Use when the patient asks [phrases]" not just "Returns [data]."
