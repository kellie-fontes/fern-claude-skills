# /04-fern-wire — Agentforce Wiring

Connect the deployed MuleSoft API to Agentforce via External Service Registration,
Named Credential, External Credential, and permission set.

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

## After deploying — verify the wiring works

Before moving to Step 5, test the callout from Apex:

1. In Salesforce, click the **gear icon → Developer Console**
2. Click **Debug → Open Execute Anonymous Window**
3. Paste and run:
   ```apex
   HttpRequest req = new HttpRequest();
   req.setEndpoint('callout:{named_credential_name}/{resource}/{persona_id}');
   req.setMethod('GET');
   Http h = new Http();
   HttpResponse res = h.send(req);
   System.debug(res.getStatusCode() + ' ' + res.getBody());
   ```
4. In the logs panel, look for `200` and JSON data. That confirms Salesforce can reach MuleSoft.
   - If you see `502` → the Named Credential URL is HTTPS but should be HTTP. Go to **Setup → Named Credentials → edit {named_credential_name}** and change `https://` to `http://`.
   - If you see `401` or `403` → the External Credential permission set isn't assigned. Step 5C handles this automatically.

## Key lessons
- The RAML spec operation descriptions are the agent's routing logic — write them as
  "Use when the {persona_role} asks [phrases]" not just "Returns [data]."
- External Credential principal type MUST be **Anonymous** for a NoAuthentication API.
  In Setup, this is under **Setup → External Credentials → New → Authentication Protocol: Custom → Parameter Groups: Anonymous** (NOT NamedPrincipal). NamedPrincipal requires a stored per-user value — the Agentforce bot user has none, so every function call fails silently.
- After deploying the ExternalCredential, grant the bot user's permission set access to
  the Anonymous principal explicitly — without this the callout still fails.
