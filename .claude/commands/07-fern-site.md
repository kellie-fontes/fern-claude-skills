# /07-fern-site — Experience Cloud Site + Chat UI + Design

Build the branded chat LWC, wire it into an Experience Cloud site, and get it live for guest users.

**What you'll do:** Claude builds the LWC code (7A). You click through 4 screens in Experience Builder (7B). Claude deploys and captures the URL (7C).

---

## Step 7A — Claude builds the chat LWC

```
Before proceeding, read fern-context.md and verify these fields are present and non-empty: org_alias, org_domain, agent_controller, log_controller, chat_component, primary_color, secondary_color, trigger_phrases. If any are missing, list them and stop.

Read fern-context.md — check the current directory first, then one level up.
Every `{variable}` in these instructions is a placeholder — replace it with the matching value from fern-context.md before running any command or generating any code.

Build an LWC called {chat_component} that:
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

Visual design — two distinct looks:

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

After generating the LWC files, tell the user it's time for Step 7B.
Do not deploy yet.
```

---

## Step 7B — Create the Experience Cloud site (UI)

This requires the Salesforce UI — it takes about 5 minutes.

**1. Create a new site**
- Go to **Setup** → search **Digital Experiences** → click **All Sites**
- Click **New**
- Choose the **Build Your Own (LWR)** template → click **Get Started**
- Give the site a name (e.g. "{agent_name} Portal") and a URL path (e.g. `/chat`)
- Click **Create** — Salesforce will spin up the site (takes ~30 seconds)

**2. Open Experience Builder**
- Once the site is created, click **Workspaces** next to your new site
- Click **Builder** to open Experience Builder

**3. Add your chat component to a page**
- In Experience Builder, click **Pages** (top left) → select the **Home** page (or create a new one)
- Click the **+** icon in the page canvas to add a component
- In the search bar, type `{chat_component}` — your LWC should appear under **Custom Components**
- Drag it onto the page
- Click **Publish** (top right) → confirm

**4. Grant the guest user access to your Apex classes**
- Go back to **Setup** → search **Sites** → click your site name
- Click **Public Access Settings** → this opens the Guest User Profile
- Scroll to **Apex Class Access** → click **Edit**
- Add `{agent_controller}` and `{log_controller}` to the Enabled list → **Save**

Before telling Claude you're done, do a quick smoke test:

**5. Verify the site loads**
- Copy this URL: `https://{org_domain}.my.site.com/[the-path-you-set]`
- Open it in an **incognito window** (so there's no cached login)
- You should see the chat component and a greeting from {agent_name}
  - If the page is blank → the LWC isn't deployed yet (Claude will deploy in 7C — that's expected)
  - If you see a Salesforce login page → the site is set to Authenticated, not Guest. Go back to **Setup → Digital Experiences → All Sites** → click the site name → ensure it says **Active** (not Preview) and that the guest user profile is set
  - If you see an error about Apex class access → re-check Step 4 above

Once the site is spinning and the path is confirmed, tell Claude: **"Site published"**

---

## Step 7C — Claude deploys and captures the URL

```
When the user says "Site published", run the following automatically:

Deploy all LWC files:
sf project deploy start --source-dir force-app/main/default --target-org {org_alias}
Capture the job ID. Poll every 10 seconds:
sf project deploy report --job-id [job-id] --target-org {org_alias}
Wait until Succeeded or Failed. Report the result.

On success, capture the site URL:
sf data query --query "SELECT Id, Name, UrlPathPrefix FROM Network" --target-org {org_alias} --json
If exactly one network is returned, write its UrlPathPrefix to site_path in fern-context.md.
Confirm: "✓ site_path saved. Your chatbot URL is: https://{org_domain}.my.site.com/[site_path]"
If multiple networks are returned, list them by Name and UrlPathPrefix and ask which is the chatbot site. Write the selected value after the user confirms.
```

---

## FertilityConnect values (reference example)
- chat_component = fertilityChat, agent_name = Fern
- trigger phrases = "log my dose", "log a dose", "i took"
- form_component = medicationDoseForm
- site name = Fern Portal, URL path = /bloom
- Persona palette: primary = #7c4d8e (purple)
- Internal palette: primary = #1a3a5c (navy)

## Key lesson
Guest users can't call api.salesforce.com directly — always route through an Apex controller
using an admin OAuth token in a Custom Setting.
