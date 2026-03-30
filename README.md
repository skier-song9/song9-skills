**English** | [한국어](./README.ko.md)

# 🛠️ song9-skills

A small collection of skills I personally find useful.

## ⚙️ Preliminaries

These skills require MCP servers and a few local settings before use.

Run the setup script that matches your AI agent:

- Codex: `./setup_codex.sh`
- Claude Code: `./setup_claude_code.sh`
- Gemini CLI: `./setup_gemini.sh`

If you do not want to trust the automated shell scripts, or if a script fails in your environment, install the preliminaries manually first.

| requirements | guide url |
| --- | --- |
| Notion MCP server | https://developers.notion.com/guides/mcp/get-started-with-mcp |

## 🚀 Getting Started

This repository is not loaded directly by the AI agents.
Clone the repository first, then copy the skill directories under `skills/` into the agent-specific skill path.

For a remote machine, SSH into the target host first and run the same commands there.

### Codex

```bash
git clone https://github.com/skier-song9/song9-skills.git
mkdir -p ~/.codex/skills
cp -R song9-skills/skills/* ~/.codex/skills/
./song9-skills/setup_codex.sh
```

### Claude Code

```bash
git clone https://github.com/skier-song9/song9-skills.git
mkdir -p ~/.claude/skills
cp -R song9-skills/skills/* ~/.claude/skills/
./song9-skills/setup_claude_code.sh
```

### Gemini CLI

```bash
git clone https://github.com/skier-song9/song9-skills.git
mkdir -p ~/.gemini/extensions/song9-skills/skills
cp song9-skills/gemini-extension.json ~/.gemini/extensions/song9-skills/
cp -R song9-skills/skills/* ~/.gemini/extensions/song9-skills/skills/
./song9-skills/setup_gemini.sh
```

If you only want a subset, copy only the directories you need from `skills/` instead of `skills/*`. If the CLI is already open, restart it after copying the files.

## 🎯 Codex-first defaults

This repository supports Codex, Claude Code, and Gemini CLI, but the skills in `skills/` are written and maintained with Codex as the default target. Unless a skill explicitly says otherwise, the examples, prompt wording, and workflow assumptions in this repo are Codex-first.

## 🧩 Skills

| Skill | Purpose | `short_description` |
| --- | --- | --- |
| `notion-mcp-page-authoring` | Create and update Notion pages while following workspace-specific page rules and formatting conventions. | `Create and update Notion pages with rules` |
| `notion-paper-page-authoring` | Fill an existing Notion page with structured notes from an arXiv paper while preserving the page structure and workspace rules. | `Write arXiv paper notes into a Notion page` |
| `prd` | Generate a Product Requirements Document for a feature without starting implementation. | `Generate a Product Requirements Document (PRD) for a new feature.` |
| `ralph` | Convert an existing PRD into `scripts/ralph/prd.json` format for Ralph autonomous runs. | `Convert PRDs to prd.json format for the Ralph autonomous agent system.` |

## 🤖 Ralph

This repo also includes a Ralph agentic loop setup under `scripts/ralph/`, adapted for Codex usage.

- Original repository: https://github.com/snarktank/ralph.git
- Codex-enabled fork used as the base: https://github.com/bsgustavo/ralph_protocol.git
- This repo carries a small local permission tweak on top of that fork.

Default Codex run:

```bash
./scripts/ralph/ralph.sh --tool codex [max_iterations]
```

By default, this wrapper runs Codex with `--dangerously-bypass-approvals-and-sandbox`. If you want the safer sandboxed Codex path instead, set `RALPH_CODEX_SAFE_MODE=1`, which switches the runner back to `--full-auto`:

```bash
RALPH_CODEX_SAFE_MODE=1 ./scripts/ralph/ralph.sh --tool codex [max_iterations]
```

For detailed Ralph workflow notes, conventions, and usage guidance, see the Notion page: https://skier-song9.notion.site/Ralph-333c8d3f60f580ec9098cb284f3cf096?source=copy_link
