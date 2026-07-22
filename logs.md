# Agent Activity Log

> **Rules for agents working in this repo:**
> 1. Append one entry per work session or change — newest entries at the **top** of the Entries section.
> 2. Every entry must record: **timestamp** (local, `YYYY-MM-DD HH:MM`), **agent/session**, **what was done** (action + reason), **what changed** (files touched, or `none — read-only`).
> 3. An entry is required even for read-only investigations — findings are changes in knowledge.
> 4. Log the entry in the same commit as the change it describes.

## Entries

- **2026-07-22 11:53 — main session (kimi-code CLI)**
  - Did: Set up change tracking at user's request — created this `logs.md`, added a rule to `PROGRESS.md` requiring agents to log every change here.
  - Changed: `logs.md` (new), `PROGRESS.md` (rules section).

- **2026-07-22 11:44 — main session (kimi-code CLI)**
  - Did: Read-only diagnosis of "mo optimize / mo uninstall do nothing". Root cause: `read -p` writes its prompt to stderr, and `confirm()` (`lib/core.sh:60`) plus the numbered picker (`cmd/uninstall.sh:87`) redirect stderr to `/dev/null`, so every confirmation prompt is invisible; users press Enter → default "no" → all actions skipped. Verified in a pty: prompts appear only without `2>/dev/null`. Dry-run (`-n`) unaffected because `confirm_or_dry` short-circuits.
  - Changed: none — read-only.

- **2026-07-22 (earlier) — build agents + main session**
  - Did: Initial build of the project (dispatcher, core lib, all 7 commands, README, installer), smoke tests, git init with baseline commit `3cb08bd`.
  - Changed: all project files (see git history and `PROGRESS.md` task table).
