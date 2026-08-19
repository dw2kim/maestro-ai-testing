# Maestro AI Test Automation

AI-driven mobile E2E test pipeline. Feed a user story to Claude, generate a
grounded Maestro flow, run it against a real device or emulator, and let AI
turn the raw artifacts (JUnit results, logs, screenshots) into a readable
report with fix recommendations.

Target app for v1: OPM Workout (iOS / Android).

## Pipeline

```
user story + view hierarchy
        |
        v
 [1] AI generation (prompts/generate-flow.md)
        |
        v
 [2] Maestro flow YAML (apps/<app>/flows/)
        |
        v
 [3] scripts/run_flow.sh  -> runs/<timestamp>/ (junit xml, logs, screenshots)
        |
        v
 [4] AI report (prompts/generate-report.md) -> reports/
```

## Architecture

A visual walkthrough of the pipeline — how the AI and Maestro stages fit
together, and how a generated flow stays valid Maestro YAML (prompt
allow-list -> Claude -> human review -> Maestro runtime) — lives at
[`docs/architecture.html`](docs/architecture.html).

It's a self-contained HTML page; view it rendered via
[htmlpreview](https://htmlpreview.github.io/?https://github.com/dw2kim/maestro-ai-testing/blob/main/docs/architecture.html),
or open the file locally.

## Repo layout

```
apps/opm-workout/
  inputs/user-stories/   one markdown file per user story
  hierarchy/             view hierarchy dumps (grounding for generation)
  flows/                 generated Maestro YAML (committed, reviewable)
prompts/                 prompt templates for generation and reporting
scripts/                 run and dump helpers
runs/                    per-run artifacts (gitignored)
reports/                 AI-generated reports (committed)
docs/                    architecture page (docs/architecture.html)
```

## Prerequisites

- Maestro CLI installed (`curl -fsSL https://get.maestro.mobile.dev | bash`)
- Android emulator or iOS simulator running, OPM Workout app installed
- Claude (Claude Code, claude.ai, or API) for the generation and report steps

## The loop (v1, hand-cranked on purpose)

1. Write a user story in `apps/opm-workout/inputs/user-stories/`.
   Use `US-001-launch-home.md` as the template.
2. Dump the view hierarchy for the screens involved:
   `./scripts/dump_hierarchy.sh apps/opm-workout/hierarchy/home.json`
   (Navigate the app to each relevant screen and dump once per screen.)
3. Generate the flow: open `prompts/generate-flow.md`, fill in the user story
   and hierarchy dump(s), give it to Claude. Save the YAML it returns to
   `apps/opm-workout/flows/US-001.yaml`. Review it like a PR.
4. Run it: `./scripts/run_flow.sh apps/opm-workout/flows/US-001.yaml`
   Artifacts land in `runs/<timestamp>/`.
5. Generate the report: open `prompts/generate-report.md`, attach the run
   artifacts, give it to Claude. Save output to `reports/`.

Once this loop works end to end for a handful of stories, automate the glue
(single script that chains 3-5). Not before.

## Design decisions

- Generation is grounded in real view hierarchy dumps. The PRD alone is not
  enough; without a hierarchy the AI invents selectors.
- Flows are committed and code-reviewed. Generated does not mean trusted.
- Local-only for v1. No CI, no cloud runners.
- Visual comparison against design handoff assets is deliberately out of
  scope for v1. If added later, it will be AI vision based and advisory
  only, never a pass/fail gate.

## Verify against current Maestro docs

Maestro CLI flags and commands evolve. If a script flag fails, check
https://docs.maestro.dev before debugging anything else.
