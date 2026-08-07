---
applyTo: "bin/**,install/**,migrations/**,test/**/*.sh,default/**/*.sh"
---

# Omarchy bash review rules

## Style

- Two-space indent; shebangs must be `#!/bin/bash` (not `#!/usr/bin/env bash`).
- Use `[[ ]]` for string/file tests and `(( ))` for numeric tests.
- In `[[ ]]`, do not quote variables; do quote string literals in comparisons.
- Prefer `(( count < 50 ))` over `[[ $count -lt 50 ]]`.
- Quote paths with spaces; do not escape spaces with `\ `.
- `install/` and `migrations/` scripts may omit shebangs because they are sourced.

## Helpers and privileges

- Prefer `omarchy-cmd-present` / `omarchy-cmd-missing`, `omarchy-pkg-add` / `omarchy-pkg-drop`, and `omarchy-notification-send` over raw equivalents when those helpers are available.
- Do not add defensive presence checks around commands from Omarchy's default package set.
- Privileged work should follow `default/omarchy-skill/SKILL.md` (`sudo` vs `pkexec`).

## Commands and migrations

- User-facing commands are `omarchy-*`; keep CLI metadata (`# omarchy:summary=...`, etc.) valid in the first 80 lines.
- New command prefixes must update `GROUP_DESCRIPTIONS` in `bin/omarchy`.
- Migrations under `migrations/` are per-user, mode `0644`, no shebang, start with an `echo`, and should prefer Omarchy helpers.
