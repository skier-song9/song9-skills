**English** | [한국어](./README.ko.md)

# song9-skills

Local skill packages and Notion MCP setup scripts for Codex and Claude Code.

## Overview

This repository contains local skill definitions and reference material for Notion-focused workflows.

It currently includes:

- `skills/notion-mcp-page-authoring`: create and update Notion pages through Notion MCP while following workspace-specific authoring rules
- `skills/notion-paper-page-authoring`: summarize an arXiv paper into an existing Notion page while preserving the page structure and workspace conventions

## Repository Layout

- `skills/`: skill packages
- `skills/*/SKILL.md`: entry point and workflow instructions for each skill
- `skills/*/references/`: supporting rules and reference material
- `skills/*/agents/`: agent-specific configuration
- `setup_codex.sh`: configure and verify the Notion MCP server for Codex
- `setup_claude_code.sh`: configure and verify the Notion MCP server for Claude Code

## Notion MCP Setup

The setup scripts are built around the same default Notion MCP endpoint:

- `SERVER_NAME=notion`
- `NOTION_MCP_URL=https://mcp.notion.com/mcp`

Both scripts first test that the endpoint is reachable with `curl`.

## Codex Setup

Run:

```bash
./setup_codex.sh
```

Requirements:

- `codex`
- `curl`

What the script does:

- checks that `codex` is installed
- checks that the Notion MCP endpoint is reachable
- writes the MCP server entry into `~/.codex/config.toml` by default
- backs up the existing Codex config to `~/.codex/config.toml.bak.<timestamp>` if the file already exists
- replaces any existing `[mcp_servers.<SERVER_NAME>]` section before writing the new one
- verifies the registration with `codex mcp get <SERVER_NAME> --json`
- runs `codex mcp login <SERVER_NAME>` so you can complete the authentication flow

Supported environment variables:

- `SERVER_NAME`
- `NOTION_MCP_URL`
- `CODEX_CONFIG_FILE`
- `CURL_MAX_TIME`

Example with overrides:

```bash
SERVER_NAME=notion \
NOTION_MCP_URL=https://mcp.notion.com/mcp \
CODEX_CONFIG_FILE="$HOME/.codex/config.toml" \
./setup_codex.sh
```

## Claude Code Setup

Run:

```bash
./setup_claude_code.sh
```

Requirements:

- `claude`
- `curl`

What the script does:

- checks that `claude` is installed
- checks that the Notion MCP endpoint is reachable
- registers the server with `claude mcp add --transport http <SERVER_NAME> <NOTION_MCP_URL>`
- if the add command returns a non-zero exit code, checks whether the server is already registered
- verifies the registration with `claude mcp get <SERVER_NAME>` or `claude mcp list`

Supported environment variables:

- `SERVER_NAME`
- `NOTION_MCP_URL`
- `CURL_MAX_TIME`

Example with overrides:

```bash
SERVER_NAME=notion \
NOTION_MCP_URL=https://mcp.notion.com/mcp \
./setup_claude_code.sh
```

## Notes

- This repository is a skill and reference repository, not a full application project.
- The README reflects the current script names: `setup_codex.sh` and `setup_claude_code.sh`.
- The Codex setup includes an interactive login step. Claude Code setup only adds and verifies the MCP server entry.
