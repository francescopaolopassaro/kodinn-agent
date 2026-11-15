# Kodinn Agent — commands

Type `/` in the prompt to see them with completion. `/help` (or `F1`) lists them in the app. Sub-commands are marked ↳.

| Command | What it does |
|---|---|
| `/clear` | wipe the conversation |
| `/compress` | summarise the conversation to free up room |
| `/compact` | summarise the conversation to free up room; /compact TEXT says what to keep in focus |
| `/hooks` | list the hooks this session runs |
| `/sandbox` | show whether the model's commands run contained, and what they may touch |
| ↳ `/sandbox review` | after a contained command changed git's files or a config folder: let them run without asking again |
| `/mcp` | list MCP servers, inspect one, or reload config |
| ↳ `/mcp show <name>` | inspect one server |
| `/skills` | list available skills, and any SKILL.md that was skipped |
| ↳ `/skills market [text]` | browse the skill market (GitHub SKILL.md repos) |
| ↳ `/skills install <name> [--project]` | install a skill from the market |
| ↳ `/skills remove <name> [--project]` | remove an installed skill |
| ↳ `/skills repos [add\|remove owner/repo]` | the GitHub repositories the market reads |
| `/memory` | list the notes the agent keeps across sessions |
| ↳ `/memory open <name>` | open a note to read or edit |
| ↳ `/memory forget <name>` | delete a note, after confirming |
| `/colleagues` | list the colleagues kept across sessions |
| ↳ `/colleagues keep <worker> [name]` | keep a worker of this session as a colleague |
| ↳ `/colleagues bring <name> [task]` | bring a colleague in - with a task, or idle to be given one |
| ↳ `/colleagues ask <name> [question]` | ask a colleague here - fresh from what it has learned; opens its Ask tab |
| ↳ `/colleagues talk <name> [--new] [message]` | talk with a colleague here, in a conversation that goes on - --new starts it over; opens its Talk tab |
| ↳ `/colleagues open <name>` | talk with a colleague one-to-one, in a session of its own |
| ↳ `/colleagues rename <name> to <new name>` | rename a colleague - its former names still find it |
| ↳ `/colleagues release <name>` | let one brought in here leave this session - it can be brought again |
| ↳ `/colleagues freeze <name>` | keep its experience as it is - it works on, and learns nothing |
| ↳ `/colleagues unfreeze <name>` | let it learn again, from now on |
| `/commands` | list custom commands, and any file that was shadowed or skipped |
| ↳ `/commands <name>` | show that command's file |
| `/agents` | the sub-agent types this session can spawn, and what each one is told |
| ↳ `/agents show <name>` | the full briefing that type is given |
| `/tasks` | background agents and commands running now, and what they left |
| ↳ `/tasks stop <handle\|pid>` | stop one - an agent stopped here reports as stopped by you |
| ↳ `/tasks output <handle\|pid>` | how far it has got, or what it left - reading it takes nothing from the agent that is owed the report |
| `/init` | write KODINN.md, the project instruction file this agent (and Kodinn) reads each session |
| `/diff` | what has changed in the working tree |
| ↳ `/diff --staged` | what is staged, for people who stage as they go |
| ↳ `/diff <path>` | just this file or folder |
| `/sessions` | earlier conversations here, and a way back into one |
| ↳ `/sessions resume <number\|id>` | restore one - the number from this list, or its id |
| ↳ `/sessions all` | every folder, not just this one |
| ↳ `/sessions delete <number\|id>` | delete one for good, after confirming |
| `/model` | show or switch which configured model this session uses |
| ↳ `/model <instance>` | a name from `providers` in config |
| `/think` | show or set how hard the model thinks (F10 cycles) |
| ↳ `/think <level>` | a level this model offers, or default · --save makes it the default |
| `/mode` | show or set how this session works |
| ↳ `/mode agent <mode>` | whether this agent may spawn sub-agents |
| ↳ `/mode edits <mode>` | how file writes are approved |
| `/stats` | usage: tokens, projects, agent types, what fills the context |
| ↳ `/stats <days>` | how far back to look - default 7 |
| ↳ `/stats all` | every session ever recorded |
| `/trust` | show or set whether this folder is trusted |
| ↳ `/trust yes` | trust this folder - stop asking for reads and writes inside it |
| ↳ `/trust no` | do not trust it - ask before every file operation |
| `/plugin` | list configured plugins, load or unwire one, or turn one on or off at startup |
| ↳ `/plugin load <name\|path> [{ settings }]` | load a name from config - disabled or not - or a path config never declared; a JSON settings block applies for this session |
| ↳ `/plugin unwire <name>` | stop and deregister a loaded plugin |
| ↳ `/plugin enable <name>` | load it at startup from now on |
| ↳ `/plugin disable <name>` | stop loading it at startup, and unload it now |
| `/btw` | ask a side question about this conversation, without adding it to the conversation |
| ↳ `/btw <question>` | what to ask - or nothing, and type it next |
| `/help` | show keys and commands |
| `/failover` | failover chain: show · set NAME,NAME,… · off |
| `/privacy` | PrivacyGuard: on · off · status · categories · category NAME on\|off · whitelist add\|remove TERM |
| `/caveman` | Caveman compression: on · off · status · instructions off\|light\|maximum |
| `/tpm` | rate limiter: on · off · status · reset · limit PROVIDER CALLS TOKENS · unlimit PROVIDER |
| `/errors` | model errors: list · clear |
| `/git` | git: status, diff, add, commit, branch, checkout, merge, rebase, stash, tag, push, pull, log. (/git help) |
| `/revert` | undo the agent's file changes: /revert lists the checkpoints, /revert N restores from N |
| `/add-dir` | let the agent read and write another folder too (/add-dir PATH) |
| `/permissions` | the allow rules saved for this folder |
| `/files` | the files the agent read or changed in this session |
| `/env` | the environment KodinnCli reads (KODINNCLI_*, KODINN_*, proxies) |
| `/release-notes` | what changed in this version |
| `/feedback` | report a bug or an idea for KodinnCli |
| `/terminal-setup` | how to make Shift+Enter, colours and keys work in your terminal |
| `/heapdump` | memory use of this process (for a bug report) |
| `/rename` | give this session a name for the session list (/rename NAME) |
| `/branch` | go on in a copy of this conversation; the original stays in /sessions (/branch [NAME]) |
| `/output-style` | how the agent writes: default, explanatory, learning, concise or a style file |
| `/rewind` | undo the agent's file changes (same as /revert) |
| `/cost` | what this session spent (same as /stats) |
| `/usage` | tokens and spend (same as /stats) |
| `/resume` | pick an earlier session to continue (same as /sessions) |
| `/effort` | how hard the model thinks (same as /think) |
| `/version` | version and build (same as /about) |
| `/keybindings` | the keys and commands (same as /help, F1) |
| `/config` | settings (same as F8) |
| `/copy` | copy the last answer to the clipboard |
| `/context` | what fills the model's context, and how full it is |
| `/status` | model, mode, folder, git branch, MCP and sandbox at a glance |
| `/doctor` | check this installation: engine, browser, git, folders |
| `/review` | review the uncommitted changes (or a PR number / branch) for bugs |
| `/security-review` | review the pending changes for security problems |
| `/pr-comments` | read the review comments of a GitHub PR and address them |
| `/commit-push-pr` | commit, push and open a pull request |
| `/summary` | a short summary of this conversation so far |
| `/insights` | a report on how this project is being worked on |
| `/bughunter` | hunt for real bugs in the code you point at (/bughunter [path or area]) |
| `/init-verifiers` | create skills that check this project's work (build, tests, lint) |
| `/vim [on\\|off]` | vi keys in the prompt: Esc for normal mode (h l w b 0 $ x dd D…), i to type |
| `/statusline [COMMAND\\|off]` | show a shell command's first output line on the status bar |
| `/upgrade [now]` | check for a newer version; `now` closes the app and updates it through its channel |
| `/about` | version, build and what it knows about your install |
| `/exit` | close this session, or quit when it is the last |
| `/setup` | guided setup: models, local models, Python |
| `/plan`, `/build`, `/ultraplan GOAL` | working modes: read-only planning, editing, deep planning with parallel exploration |
| `/team [TASK]` | write the plan to plan.md, then run builders + reviewer + tester until build and tests pass |
| `/localmodels [search\\|download\\|list]` | local GGUF models from Hugging Face for the built-in DesireeIA engine |
| `/providers` | the configured model providers |
| `/dock NAME`, `F2` | open a dock: agent, workers, processes, tokens, TPM, watchdog, local model, models, privacy, changes, errors, system, logs |
| `/theme`, `F9` | pick a colour theme |
| `/open PATH` | open a file in an editor tab |
| `/shell [command]` | run a command in a terminal tab |
| `/export` | export the conversation (Markdown, HTML, JSON) |
| `/decision` | the decision models (Laya) |

## Agent tools

What the model can use. Writes and commands ask according to the working mode; reads inside a trusted folder do not.

| Tool | What it does |
|---|---|
| `read_file`, `write_file`, `replace_in_file`, `glob`, `grep` | read, write and edit files; find files and text |
| `run_shell` | run a command (in a sandbox where available) |
| `git`, `revert`, `build`, `test` | git operations, undo the agent's changes, build and test the project |
| `lsp` | definition, references, hover, symbols, diagnostics from a language server (Roslyn, TypeScript, Python, Go, Rust, C/C++, Java) |
| `browser` | drive Chrome/Edge: open, click, type, eval JavaScript, console, network, screenshot; attach to an Electron app |
| `web_fetch`, `web_search`, `http_request` | read a page, search the web, call an API |
| `agent`, `agent_send`, `task_list`, `task_output`, `task_stop` | sub-agents in the background and their work |
| `worktree` | isolated git worktrees in `.worktrees/NAME` for parallel work |
| `cron_create`, `cron_list`, `cron_delete` | prompts that come back on a schedule |
| `notebook_edit` | edit one cell of a Jupyter notebook |
| `sleep` | wait, ending at once when the turn is stopped |
| `todowrite`, `ask_user`, `skill`, `memory`, `colleague` | task list, questions to you, skills, notes kept across sessions, colleagues |
| `tool_search` | load the schema of a rarely used tool (MCP tools load on demand) |

## Command line

```
kodinn                         start in the current folder
kodinn -C PATH                 start in another folder
kodinn -p "task"               run one task and print the answer
kodinn -p --input-format stream-json --output-format stream-json    driven by another program
kodinn provider add\|list\|remove\|default\|kinds      models
kodinn mcp add\|list\|remove\|enable\|disable          MCP servers
kodinn hooks list\|add\|remove                       hooks
kodinn logs [cat FILE | last N]                    the encrypted logs, readable on this machine
kodinn --version
```
