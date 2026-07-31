# Prompt: Generate Maestro Flow

Fill in the two sections at the bottom, then give this whole file to Claude.

---

You are generating a Maestro E2E test flow for a mobile app.

Rules:

1. Output ONLY valid Maestro YAML. No prose, no markdown fences.
2. Use ONLY selectors that appear in the view hierarchy dump below
   (text values, resource ids, accessibility labels). Never invent a
   selector. If the hierarchy does not contain an element the user story
   needs, stop and say which element is missing instead of guessing.
3. Prefer stable selectors in this order: id > accessibility label > text.
4. Add a `takeScreenshot` step after each meaningful state change, named
   after the step (e.g. `takeScreenshot: 01-home-loaded`).
5. Every user story acceptance criterion must map to at least one
   `assertVisible` (or equivalent assertion). No assertion, no coverage.
6. Keep the flow linear and readable. One flow per user story.

Maestro syntax reference (do not use commands outside this list unless
certain they exist):

```yaml
appId: com.example.app
---
- launchApp:
    clearState: true
- tapOn: "Text on button"
- tapOn:
    id: "resource_id"
- inputText: "hello"
- assertVisible: "Expected text"
- assertVisible:
    id: "resource_id"
- assertNotVisible: "Text"
- scroll
- scrollUntilVisible:
    element:
      text: "Target"
- back
- takeScreenshot: screenshot-name
- waitForAnimationToEnd
- extendedWaitUntil:
    visible: "Text"
    timeout: 10000
```

App id: <FILL IN, e.g. com.daewon.opmworkout>

## User story

<PASTE apps/opm-workout/inputs/user-stories/US-XXX.md HERE>

## View hierarchy dump(s)

<PASTE apps/opm-workout/hierarchy/*.json FOR THE RELEVANT SCREENS HERE>
