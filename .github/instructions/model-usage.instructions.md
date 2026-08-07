---
applyTo: "shell/plugins/model-usage/**"
---

# model-usage plugin review rules

## Provider visibility

- A provider belongs in the bar/panel only when it has real display data (meters and/or local history), not merely because it is enabled or installed.
- Signed-out / missing credential states should keep meters unset (`rateLimitPercent < 0`) so the provider self-hides like Claude/Codex.

## Charts vs meters

- Period-meter-only providers (for example Cursor) must report `hasLocalStats: false` and keep day/model history empty.
- `TOKENS BY DAY` must require real positive day totals (`weekPeak > 0`), not merely a non-empty `recentDays` array.
- Remember `aggregateSnapshots()` and some scanners synthesize seven zero-value `recentDays` rows.

## Limits UI

- Shared LIMITS header countdowns are allowed only when every meter on the selected provider shares the same `resetAt`.
- Different windows on one provider (for example Claude session vs weekly) must keep per-row resets.

## Scanner robustness

- Validate external JSON payloads are objects before calling `.get(...)`.
- Cursor credential DB access should stay read-only; do not write the state database.
- Resolve scanner scripts through `OMARCHY_PATH`, not component-relative `Qt.resolvedUrl`.
