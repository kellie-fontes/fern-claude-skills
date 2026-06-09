# /fern-debug — Debugging Prompts

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
