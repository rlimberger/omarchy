---
applyTo: "shell/**/*.{qml,js}"
---

# Omarchy Quickshell review rules

## Runtime paths

- Flag QML that builds Omarchy script/bin paths from `Qt.resolvedUrl`, `HOME`, or `Quickshell.shellDir`.
- Prefer `Quickshell.env("OMARCHY_PATH")` / injected `omarchyPath` for runtime files under `shell/` and `bin/`.
- Do not suggest re-exporting or defaulting `OMARCHY_PATH`.

## Plugin contract

- First-party plugins live under `shell/plugins/` (optionally one category deeper).
- Entry points are `Item`s (not `ShellRoot`) and accept injected `omarchyPath`, `shell`, `manifest`, and registry props as appropriate.
- Panel / overlay / menu plugins must expose `open(payloadJson)` and `close()`.
- Prefer `bin/omarchy-shell` / existing IPC targets over new ad-hoc Quickshell socket clients.
- Do not suggest starting extra standalone Quickshell processes for individual components.

## Refresh and polling

- Prefer the plugin's central refresh/settings cadence over hard-coded duplicate timers that bypass settings such as `refreshIntervalSec`.
- Flag providers that hit network APIs on a fixed short interval when a shared scheduler already exists.

## UI capability flags

- Chart/history sections should not treat padded empty arrays as real history.
- Respect provider capability flags such as `hasLocalStats` when sync aggregation synthesizes placeholder rows.
