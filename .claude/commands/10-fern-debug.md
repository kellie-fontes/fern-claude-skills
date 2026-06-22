# /10-fern-debug — Debugging Prompts

Real errors, real fixes. Paste the relevant prompt into Claude Code when you hit one of these walls.

---

## 1. Guest User Apex Callout Timeout
```
This Apex method works in the Developer Console but fails silently
for Experience Cloud guest users. What sharing or profile setting
am I missing?
```
**Root cause:** Guest users can't call api.salesforce.com — route through admin OAuth token in Custom Setting.

---

## 2. DateTime Off by Hours
```
Why is my appointment time off by [N] hours?
```
**Root cause:** DateTime.valueOf() ignores UTC offset — always convert explicitly using Intl API in JS and explicit UTC parsing in Apex.

---

## 3. MuleSoft Variable Contains Wrong Data
```
Why does my MuleSoft variable contain the wrong data?
```
**Root cause:** #[payload] after an HTTP request is a stream — store it in a variable immediately before referencing.

---

## 4. DataWeave Parse Error at Startup
```
Why does "type:" throw a parse error at startup?
```
**Root cause:** `type` is a reserved word in DataWeave — wrap in quotes: `"type":`.

---

## 5. CloudHub 502 on All Endpoints
```
My MuleSoft app deploys successfully but returns 502 on CloudHub.
The Named Credential URL is [URL]. The listener basePath is [path].
What's the mismatch?
```
**Root cause:** CloudHub basePath must exactly match the Named Credential URL path — trailing slashes matter.

---

## 6. SOQL Returns Empty via REST but Works in CLI
```
Why does my SOQL return empty via REST but work in the CLI?
```
**Root cause:** FLS blocks REST API even for admins — check field-level security on every field in your SELECT.

---

## 7. Lightning Button Not Rendering for Guest Users
```
Why does my lightning-button not render for Experience Cloud guest users?
```
**Root cause:** SLDS base components load inconsistently for guest users — use plain HTML + custom CSS instead.

---

## 8. Logo Broken After Deploying to New Org
```
Why is my logo broken after deploying to a new org?
```
**Root cause:** Static resources require separate deployment and can fail in a fresh org — use inline SVGs for all icons and logos.

---

## 9. Bootstrap Call Returns 403
```
Why does my Agentforce bootstrap call return 403 even with a valid token?
```
**Root cause:** Agent type must be ExternalCopilot — other types don't support programmatic API access via the bootstrap/session pattern.

---

## 10. Agent Ignores Certain Questions
```
Why does my agent ignore questions about [topic]?
```
**Root cause:** GenAiFunction descriptions are the routing logic — rewrite them as "Use this when the patient asks [phrases]" not "Returns [data]."

---

## 11. Generic Deployment Error
```
I'm getting this error when deploying to Salesforce: [paste error].
Here is the relevant file: [paste file]. What's wrong and how do I fix it?
```

---

## 12. Generic DataWeave Runtime Error
```
This DataWeave expression throws "[paste error]" at runtime.
The payload looks like [paste sample]. Fix it.
```

---

## 13. Agent Gives Generic Responses Instead of Calling Functions
```
My Agentforce agent routes correctly but responds generically instead of
calling my custom plugin functions. Why?
```
**Root cause:** Agentforce auto-injects `EmployeeCopilot__AnswerQuestionsWithKnowledge` as a new
`GenAiPlannerFunctionDef` on every activation. This system topic wins routing over your plugin.
Fix: after every deactivate→activate cycle, query `GenAiPlannerFunctionDef` scoped to your planner
and delete every record except the one linking to your plugin.

---

## 14. Agent Asks "Which [thing] Are You Referring To?" Instead of Calling the API
```
My agent says "Could you clarify which [X] you're referring to?" instead of
calling the function. The function requires a [paramName] path parameter.
```
**Root cause:** No `input/schema.json` — the LLM doesn't know the value to pass and falls back
to asking the user. Add an `input/schema.json` to the GenAiFunction with `isUserInput: true` and
a description like "Always use [value]. Never ask the user." See `/05-fern-agent` key lessons for
the exact schema pattern.

---

## 15. 412 "Invalid Config" on Agent Activation
```
My agent activation fails with 412 Precondition Failed: Invalid Config.
```
**Root cause:** `copilotAction:isUserInput: false` on a `required` field in an input schema
is invalid for ExternalService GenAiFunctions. Change it to `isUserInput: true`. If the error
persists after that change, remove the input schema entirely and redeploy — then re-add it
with `isUserInput: true` in a fresh deploy.

---

## 16. Agent Function Calls Fail Silently (result: [] with no error)
```
My agent routes to the right topic, says it's looking something up, but
returns empty results with no error message. The API works when called directly.
```
**Root cause:** External Credential principal type is `NamedPrincipal` instead of `Anonymous`.
The Agentforce bot user has no stored credential value, so callouts fail silently.
Fix: in your `.externalCredential-meta.xml`, change `parameterType` from `NamedPrincipal`
to `Anonymous`, redeploy, then ensure the bot user's permission set grants access to the
Anonymous principal.

---

## 17. Agent Says "Sorry, I Can't Assist" for Every Message (result: [])
```
My agent responds with "Sorry, I can't assist with that" for every message,
even ones clearly within its topic scope. The session creates successfully.
```
**Root cause:** The topic's **Classification Description** (`GenAiPluginDefinition.Description`) is
too narrow. The planner uses this field to decide which topic to route a message to — if it only
covers a subset of your actions (e.g. "loyalty and rewards") it won't route orders, profile, or
summary questions, returning `result:[]`.

This field is distinct from **Scope** (which governs what the topic does once selected).

Fix: deactivate the agent, then PATCH the Description to cover every action category and natural
trigger phrases ("how am I doing", "give me a summary", "show my orders"):
```bash
sf api request rest --target-org [alias] --method PATCH \
  "/services/data/v62.0/tooling/sobjects/GenAiPluginDefinition/[plugin-id]" \
  --body '{"Description":"[exhaustive description]"}'
```
Reactivate after patching. To find your plugin ID:
```bash
sf api request rest --target-org [alias] \
  "/services/data/v62.0/tooling/query?q=SELECT+Id,DeveloperName+FROM+GenAiPluginDefinition"
```
