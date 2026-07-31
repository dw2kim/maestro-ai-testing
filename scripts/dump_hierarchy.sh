#!/usr/bin/env bash
# Dump the current screen's view hierarchy for AI flow generation grounding.
# Navigate the app to the screen you care about FIRST, then run this.
# Usage: ./scripts/dump_hierarchy.sh apps/opm-workout/hierarchy/home.json
set -euo pipefail

OUT="${1:?usage: dump_hierarchy.sh <output-path.json>}"
mkdir -p "$(dirname "${OUT}")"

maestro hierarchy > "${OUT}"

echo "Hierarchy written to ${OUT}"
echo "Lines: $(wc -l < "${OUT}")"
