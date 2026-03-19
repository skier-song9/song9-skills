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

## 🧩 Skills

| Skill | Purpose | `short_description` |
| --- | --- | --- |
| `notion-mcp-page-authoring` | Create and update Notion pages while following workspace-specific page rules and formatting conventions. | `Create and update Notion pages with rules` |
| `notion-paper-page-authoring` | Fill an existing Notion page with structured notes from an arXiv paper while preserving the page structure and workspace rules. | `Write arXiv paper notes into a Notion page` |
