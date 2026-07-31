# Prompt: Generate Test Report

Give Claude this prompt plus the contents of one `runs/<timestamp>/` folder
(results.xml, console.log, debug logs, screenshots) and the flow YAML and
user story that produced it.

---

You are writing a test report for a Maestro E2E run. Be factual and
specific. Do not soften failures.

Inputs you will receive:
- The user story the flow was generated from
- The flow YAML
- JUnit results (results.xml)
- Console output (console.log)
- Maestro debug logs
- Screenshots taken during the run

Produce a markdown report with EXACTLY these sections:

## Summary
One paragraph: what was tested, overall result, run duration if available.

## Results
A table: step or assertion | status (PASS/FAIL) | evidence (which
screenshot or log line supports this).

## Failure analysis
Only if something failed. For each failure:
- What the flow expected vs what actually happened
- Most likely cause, chosen from: app bug, flaky timing, wrong selector,
  outdated flow (app changed), environment issue
- Confidence (high/medium/low) and why

## Recommendations
Concrete next actions, ordered by priority. Distinguish clearly between
"fix the app" and "fix the test". If the failure looks like a real app
bug, write it as a ready-to-file bug report (steps to reproduce, expected,
actual).

## Artifacts
List of screenshots and logs referenced, with filenames.

Rules:
- Never claim a step passed without evidence in the artifacts.
- If evidence is ambiguous, say so. An honest "inconclusive" beats a
  confident guess.
- Keep it under one page unless there are multiple failures.
