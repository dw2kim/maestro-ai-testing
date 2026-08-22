# AGENTS.md

This file provides guidance to Codex (Codex.ai/code) when working with code in this repository.

## What this is

An AI-driven mobile E2E test pipeline built around the Maestro CLI. A user story plus a real view-hierarchy dump is turned into a grounded Maestro flow YAML, run against a device/emulator, and the raw artifacts (JUnit XML, logs, screenshots) are turned into a readable report. Target app for v1 is OPM Workout (iOS/Android).

The pipeline is **hand-cranked on purpose** for v1: a human runs each stage and reviews the output before feeding it to the next. Do not build the chaining/automation script until the loop works end to end for several stories.

## The 5-stage pipeline

```
user story + view hierarchy → [AI: prompts/generate-flow.md] → flow YAML
→ [scripts/run_flow.sh] → runs/<timestamp>/ artifacts → [AI: prompts/generate-report.md] → reports/
```

Stages 1 and 4 are AI steps driven by the prompt templates in `prompts/`; there is no code that calls an LLM. The prompt files ARE the contract — treat them as source, not docs. When changing what the pipeline produces, edit the prompt, not a script.

## Commands

Run a flow (collects all artifacts into a fresh `runs/<timestamp>/`):
```bash
./scripts/run_flow.sh apps/opm-workout/flows/US-001.yaml
```
Exit code is Maestro's own pass/fail (propagated through the `tee` via `PIPESTATUS`). Each run folder gets `results.xml`, `console.log`, `debug/`, a copy of the flow, `run.meta`, and (if any) `screenshots/`.

Dump a view hierarchy — **navigate the app to the target screen first**, then:
```bash
./scripts/dump_hierarchy.sh apps/opm-workout/hierarchy/home.json
```

There is no build, lint, or unit-test suite. "Running a test" means running a Maestro flow via `run_flow.sh`.

## Non-obvious mechanics

- **Screenshot sweep**: Maestro's `takeScreenshot` writes PNGs into the *current working directory*, not the output dir. `run_flow.sh` moves stray `*.png` from cwd into the run folder afterward. `*.png` is gitignored, so screenshots are captured for the report step but never committed.
- **What's committed vs not**: `runs/*` is gitignored (only `.gitkeep` kept). Flows (`apps/*/flows/`) and reports (`reports/`) ARE committed and meant to be code-reviewed — "generated does not mean trusted."

## Rules baked into the AI stages (keep these consistent if editing prompts)

- **Selectors must come from the hierarchy dump.** The generator may only use text/id/accessibility values that appear in the provided dump; if a needed element is absent it must stop and name the missing element rather than invent a selector. Selector preference order: id > accessibility label > text.
- **OPM Workout is a Flutter app** — elements expose almost no `resource-id`/`text`; selectors come from `accessibilityText` (accessibility labels). The one `resource-id` in a dump is usually iOS status-bar chrome, not the app.
- **Maestro does a FULL-string regex match**, not substring. Labels with a suffix (`"Beginner\nTab 1 of 3"`, `"DAY 2\n0%"`) will not match a bare `"Beginner"` — use a DOTALL regex `(?s)Beginner.*`. (Learned from US-001; see `reports/US-001.md`.)
- **Dump in the same state the flow runs in.** Flows use `clearState: true`; day/progress labels are state-dependent (a completed `"DAY 1"` becomes `"DAY 1\n0%"` after reset), so grounding must be captured from cleared state or assertions will drift from reality.
- **Flutter merges card subtrees into one label.** A whole card can expose a single `accessibilityText` (e.g. `"Workout\nTotal Average: 00:00\nM\nT\nW\nT\nF\nS\nS"`); inner texts aren't separately targetable — assert substrings with a DOTALL regex. (Learned from US-002.)
- **Cold `clearState` launch is slow (not hung).** It re-seeds data and can take 20s+ to render Home content (blank splash meanwhile). The fix is a generous `extendedWaitUntil` (90s) on a Home-content element right after `launchApp` — it returns as soon as content appears, so it's cheap on fast launches. `run_flow.sh` also terminates the app before the run for a clean state, but that alone does NOT fix the slow launch. (Learned from US-002; see `reports/US-002.md`.) The **first** launch after a fresh simulator boot is slower again and blew a 45s budget on a warm-sim-passing flow — hence 90s, not 45s. A cold environment is the case to size for; on a warm sim these flows finish in 9–14s. (Learned from US-003.)
- **Every acceptance criterion maps to an assertion.** No `assertVisible` (or equivalent) → no coverage.
- **Reports must not soften failures** and must separate "fix the app" from "fix the test"; a suspected app bug is written as a ready-to-file bug report.

## Constraints for v1 (don't silently cross these)

- Local-only. No CI, no cloud runners.
- Visual comparison against design assets is out of scope (if ever added: AI-vision, advisory only, never a pass/fail gate).
- Maestro CLI flags/commands change. If a script flag fails, check https://docs.maestro.dev before debugging anything else.
