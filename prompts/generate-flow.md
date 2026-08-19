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
7. Maestro matches a selector against the element's ENTIRE label as a
   regex (full match, not substring). If the label in the dump carries a
   suffix (common in Flutter apps: "Beginner\nTab 1 of 3", "DAY 2\n0%"),
   a bare "Beginner" will NOT match. Use a DOTALL regex that spans the
   newline: `(?s)Beginner.*`. Match on the stable leading text.
8. Grounding must reflect RUN state, not capture state. If the flow uses
   `clearState: true`, the dump must be taken from cleared state — labels
   like day/progress rows change with app state (a completed "DAY 1"
   becomes "DAY 1\n0%" after a reset).
9. A Flutter card/subtree can collapse into ONE accessibility label (e.g.
   "Workout\nTotal Average: 00:00\nM\nT\nW\nT\nF\nS\nS"). You cannot target
   the inner texts separately; assert substrings of the combined label with
   a DOTALL regex, e.g. `(?s).*Total Average.*`.
10. After a `clearState` launch, wait on a screen-specific element with a
    generous `extendedWaitUntil` (timeout: 90000) BEFORE asserting — the cold
    launch re-seeds data and can take 20s+ to render. It returns as soon as
    the element appears, so a big timeout is free on fast launches. Do not
    assert on the always-present app container ("One Punch") to gate this;
    use real screen content (e.g. "(?s)Beginner.*").

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
