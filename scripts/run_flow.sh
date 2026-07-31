#!/usr/bin/env bash
# Run a Maestro flow and collect all artifacts into runs/<timestamp>/
# Usage: ./scripts/run_flow.sh apps/opm-workout/flows/US-001.yaml
set -euo pipefail

FLOW="${1:?usage: run_flow.sh <path-to-flow.yaml>}"
[ -f "$FLOW" ] || { echo "Flow not found: $FLOW" >&2; exit 1; }

TS="$(date +%Y%m%d-%H%M%S)"
RUN_DIR="runs/${TS}"
mkdir -p "${RUN_DIR}"

echo "Run: ${RUN_DIR}"
echo "Flow: ${FLOW}"

# Start from a clean app state. Relaunching (launchApp) while the app is
# still foregrounded can leave it stuck on a blank splash past the wait
# timeout (flaky failure, see reports/US-002.md). Terminate the target app
# first. appId comes from the flow's `appId:` line; best-effort on both
# platforms, never fails the run.
APP_ID="$(grep -E '^appId:' "${FLOW}" | head -1 | sed -E 's/^appId:[[:space:]]*//; s/[[:space:]]*$//')"
if [ -n "${APP_ID}" ]; then
  echo "Pre-run: stopping ${APP_ID} for a clean launch"
  xcrun simctl terminate booted "${APP_ID}" >/dev/null 2>&1 || true
  adb shell am force-stop "${APP_ID}" >/dev/null 2>&1 || true
fi

# --format junit      -> structured pass/fail for the report step
# --debug-output      -> maestro logs and failure screenshots
set +e
maestro test "${FLOW}" \
  --format junit \
  --output "${RUN_DIR}/results.xml" \
  --debug-output "${RUN_DIR}/debug" \
  2>&1 | tee "${RUN_DIR}/console.log"
EXIT_CODE=${PIPESTATUS[0]}
set -e

# takeScreenshot writes PNGs into the current working directory;
# sweep them into the run folder so the report step has one place to look.
shopt -s nullglob
PNGS=(*.png)
if [ ${#PNGS[@]} -gt 0 ]; then
  mkdir -p "${RUN_DIR}/screenshots"
  mv -- *.png "${RUN_DIR}/screenshots/"
fi

# Record what produced this run
cp "${FLOW}" "${RUN_DIR}/flow.yaml"
{
  echo "flow=${FLOW}"
  echo "timestamp=${TS}"
  echo "exit_code=${EXIT_CODE}"
  echo "maestro_version=$(maestro --version 2>/dev/null || echo unknown)"
} > "${RUN_DIR}/run.meta"

echo ""
echo "Exit code: ${EXIT_CODE}"
echo "Artifacts: ${RUN_DIR}/"
exit "${EXIT_CODE}"
