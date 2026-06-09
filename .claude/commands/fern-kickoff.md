# /fern-kickoff — Project Architecture Design

Design the full architecture for an Agentforce + MuleSoft + Experience Cloud demo before writing any code.

## Instructions

Run this prompt in Claude Code at the start of a new demo build. Replace all [bracketed values] with your own before running.

---

```
I want to build a [industry] patient/customer companion demo on Salesforce
using Agentforce + MuleSoft + Experience Cloud. The persona is [name],
a [role]. The AI companion is called [agent name].

Key flows I want to demo:
1. [flow 1]
2. [flow 2]
3. [flow 3]

Design the full architecture including:
- MuleSoft: what mock API endpoints to build and what data model each needs
- Salesforce: what custom objects, custom settings, Apex controllers,
  LWCs, and GenAI functions are required
- Integration layer: Named Credential, External Credential, External
  Service Registration, and Remote Site Settings needed to connect
  MuleSoft to Agentforce
- Experience Cloud: what the guest-facing site needs and how the
  guest user authentication pattern works
- Back-office: what internal tooling the [internal role] needs

Don't generate any code yet — just map the full dependency order
so I know what to build first.
```

## FertilityConnect values (working example)
- industry = Health & Life Sciences / Fertility
- persona = Sarah, a fertility patient
- agent = Fern
- internal role = nursing team
- flow 1 = Patient asks Fern about her upcoming appointments and lab results
- flow 2 = Patient logs a medication dose and requests a nurse callback
- flow 3 = Nurse reviews the dose log and schedules a follow-up appointment
