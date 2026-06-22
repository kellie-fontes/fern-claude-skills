# /07-fern-site — Experience Cloud Site + Chat UI + Design

Create the Experience Cloud site, configure guest user permissions, and build the branded chat LWC.

## Instructions

Run this in Claude Code from inside your Salesforce DX project directory.
Claude will read `fern-context.md` automatically — no manual value replacement needed.

---

```
Before proceeding, read fern-context.md and verify these fields are present and non-empty: org_alias, org_domain, agent_controller, log_controller, chat_component, primary_color, secondary_color, trigger_phrases. If any are missing, list them and stop.

Read fern-context.md — check the current directory first, then one level up.

I need an Experience Cloud site with a custom LWC chat component
that lets guest users (no login required) talk to my Agentforce agent.

1. Experience Cloud site setup:
   - Create a new site with guest user access enabled
   - Grant the guest user profile access to:
     {agent_controller} and {log_controller} Apex classes
   - Add the chat LWC to a site page in Experience Builder

2. Build an LWC called {chat_component} that:
   - On load, calls getPersonaInfo() to get the persona's name
     and opens with a personalized greeting from {agent_name}
   - Sends messages to Agentforce via {agent_controller}.sendMessage,
     maintaining sessionId across turns
   - Detects trigger phrases ({trigger_phrases}) and instead of
     calling the agent, shows an inline {form_component} and
     suppresses further input
   - Renders agent responses as formatted HTML: bold (**text**),
     bullet lists, numbered lists, inline images and video links
     for known product/item names
   - Shows a typing indicator while waiting for a response
   - Scrolls to the latest message automatically
   - Receives submitted events from {form_component} with a logId
     and starts polling for status confirmation

3. Visual design — two distinct looks:

   {persona_role}-facing chat UI:
   - Warm, approachable palette built around {primary_color}
   - Gradient header with {agent_name} avatar as inline SVG
     (no static resources)
   - Persona messages right-aligned in brand color, agent messages
     left-aligned on white with soft shadow
   - Rounded corners: 16px containers, 6-10px buttons and inputs
   - Typing indicator: 3 animated dots bouncing in brand color
   - All form elements use brand color for borders and focus states

   Internal dashboard:
   - Clinical, data-dense palette built around {secondary_color}
   - No SLDS base components — plain HTML + custom CSS throughout
   - Use inline SVGs for all icons — no static resources
   - Define brand palette as CSS comments at top of each file
     so re-skinning for a new industry takes minutes

After deploying the site and components, capture the site URL path automatically:
sf data query --query "SELECT Id, Name, UrlPathPrefix FROM Network" --target-org {org_alias} --json
If exactly one network is returned, write its UrlPathPrefix to site_path in fern-context.md and confirm: "site_path written to fern-context.md: [value]. Your chatbot URL will be: https://{org_domain}.my.site.com/[site_path]"
If multiple networks are returned, list them with their Name and UrlPathPrefix and ask: "Which site is your chatbot site? Enter the name or path prefix." Write the selected value to site_path after the user confirms.
```

---

## FertilityConnect values (reference example)
- agent_controller = FertilityAgentController, log_controller = MedicationLogController
- chat_component = fertilityChat, agent_name = Fern
- trigger phrases = "log my dose", "log a dose", "i took"
- form_component = medicationDoseForm
- Persona palette: primary = #7c4d8e (purple)
- Internal palette: primary = #1a3a5c (navy)

## Key lesson
Guest users can't call api.salesforce.com directly — always route through an Apex controller
using an admin OAuth token in a Custom Setting.
