# /fern-site — Experience Cloud Site + Chat UI + Design

Create the Experience Cloud site, configure guest user permissions, and build the branded chat LWC.

## Instructions

Run this in Claude Code from inside your Salesforce DX project directory. Replace all [bracketed values] with your own before running.

---

```
I need an Experience Cloud site with a custom LWC chat component
that lets guest users (no login required) talk to my Agentforce agent.

1. Experience Cloud site setup:
   - Create a new site with guest user access enabled
   - Grant the guest user profile access to:
     [AgentController] and [LogController] Apex classes
   - Add the chat LWC to a site page in Experience Builder

2. Build an LWC called [componentName] that:
   - On load, calls getPatientInfo() to get the persona's name
     and opens with a personalized greeting from the agent
   - Sends messages to Agentforce via [AgentController].sendMessage,
     maintaining sessionId across turns
   - Detects trigger phrases [list] and instead of calling the agent,
     shows an inline [form component] and suppresses further input
   - Renders agent responses as formatted HTML: bold (**text**),
     bullet lists, numbered lists, inline images and video links
     for known product/medication names
   - Shows a typing indicator while waiting for a response
   - Scrolls to the latest message automatically
   - Receives submitted events from [form component] with a logId
     and starts polling for status confirmation

3. Visual design — two distinct looks:

   [Persona]-facing chat UI:
   - Warm, approachable palette built around [primary color]
   - Gradient header with agent avatar as inline SVG (no static resources)
   - Patient messages right-aligned in brand color, agent messages
     left-aligned on white with soft shadow
   - Rounded corners: 16px containers, 6-10px buttons and inputs
   - Typing indicator: 3 animated dots bouncing in brand color
   - All form elements use brand color for borders and focus states

   Internal dashboard:
   - Clinical, data-dense palette built around [secondary color]
   - No SLDS base components — plain HTML + custom CSS throughout
   - Use inline SVGs for all icons — no static resources
   - Define brand palette as CSS comments at top of each file
     so re-skinning for a new industry takes minutes
```

## FertilityConnect values (working example)
- AgentController = FertilityAgentController
- LogController = MedicationLogController
- componentName = fertilityChat
- trigger phrases = "log my dose", "log a dose", "i took"
- form component = medicationDoseForm
- Patient palette: primary = #7c4d8e (purple), dark = #5a3570, light = #a06bb5, background = #f8f4f0
- Internal palette: primary = #1a3a5c (navy), mid = #2d6a9f, action = #27ae60, danger = #e74c3c
- Shared accent: #7c4d8e on both sides — visual thread connecting patient and clinical views

## Key lesson
Guest users can't call api.salesforce.com directly — always route through an Apex controller using an admin OAuth token in a Custom Setting.
