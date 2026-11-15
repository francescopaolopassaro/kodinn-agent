# Changelog

## 0.9.4 beta — 2026-11-15

### New
- **Automatic updates**: a daily check of `latest.json`; `/upgrade now` closes the app and updates it through the
  channel it was installed with (install script, Scoop, winget, Chocolatey, Homebrew, npm).
- **Install anywhere**: `install.ps1` (Windows), `install.sh` (Linux, macOS), npm (`npm i -g kodinncli`), Scoop,
  Homebrew, winget and Chocolatey manifests. Packages are checked against their SHA-256.
- **New start-up splash**: the Kodinn logo assembles from its glyphs, then each part lights up.
- **Code intelligence** — the `lsp` tool: definitions, references, hover, symbols and diagnostics from Roslyn (C#),
  TypeScript, Python, Go, Rust, C/C++ and Java language servers.
- **Scheduled prompts** — `cron_create`, `cron_list`, `cron_delete`.
- **Git worktrees** — the `worktree` tool for isolated parallel work.
- `notebook_edit` (Jupyter cells) and `sleep` tools.
- **Browser testing** — the `browser` tool drives Chrome/Edge or attaches to an Electron app.
- Commands: `/vim`, `/statusline`, `/output-style` (explanatory, learning, concise, your own), `/branch`,
  `/rename`, `/add-dir`, `/permissions`, `/files`, `/env`, `/summary`, `/insights`, `/bughunter`,
  `/init-verifiers`, `/feedback`, `/terminal-setup`, `/heapdump`, `/context`, `/doctor`, `/status`, `/copy`,
  `/compact [focus]`, `/review`, `/security-review`, `/pr-comments`, `/commit-push-pr`.
- Deferred tool schemas: rarely used and MCP tools load on demand through `tool_search`, keeping the prompt small.
- Skills: reads Claude Code and OpenCode skill folders too; `/skills market` installs skills from GitHub.
- Driven mode: `--input-format stream-json` lets another program control a session, permission questions included.
- Provider cards: **Ollama server**, **Ollama Cloud**, and **DesireeIA** (the built-in engine).

### Improved
- The bar beside the prompt is **orange whenever the agent may write** (build), red-orange in auto, teal in plan.
- The mode line says **sub-agents on** / **single agent** instead of "fan-out".
- Saving a new default model in the settings applies at once to the sessions that were on the old default.
- File edits show their real diff in the conversation.
- Copying text no longer freezes the screen on Windows.
- `/compact` keeps the conversation when the cloud model fails, moving to the failover model.

## 0.9.3

First public build of Kodinn Agent.
