# Hierarchy dumps

One JSON file per screen, dumped with scripts/dump_hierarchy.sh while the
app is on that screen. These ground the AI generation step so it only uses
selectors that actually exist.

Re-dump after any UI change; stale dumps produce flows that fail with
"element not found" and waste a debugging cycle.

Naming: <screen>.json (home.json, workout-detail.json, settings.json)
