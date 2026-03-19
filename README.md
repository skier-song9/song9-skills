# song9-skills

English and Korean documentation for the local skill packages in this repository, plus the Notion MCP setup scripts for Codex and Claude Code.

## English

### Overview

This repository contains local skill definitions and reference material for Notion-focused workflows.

It currently includes:

- `skills/notion-mcp-page-authoring`: create and update Notion pages through Notion MCP while following workspace-specific authoring rules
- `skills/notion-paper-page-authoring`: summarize an arXiv paper into an existing Notion page while preserving the page structure and workspace conventions

### Repository Layout

- `skills/`: skill packages
- `skills/*/SKILL.md`: entry point and workflow instructions for each skill
- `skills/*/references/`: supporting rules and reference material
- `skills/*/agents/`: agent-specific configuration
- `setup_codex.sh`: configure and verify the Notion MCP server for Codex
- `setup_claude_code.sh`: configure and verify the Notion MCP server for Claude Code

### Notion MCP Setup

The setup scripts are built around the same default Notion MCP endpoint:

- `SERVER_NAME=notion`
- `NOTION_MCP_URL=https://mcp.notion.com/mcp`

Both scripts first test that the endpoint is reachable with `curl`.

### Codex Setup

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

### Claude Code Setup

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

### Notes

- This repository is a skill and reference repository, not a full application project.
- The README reflects the current script names: `setup_codex.sh` and `setup_claude_code.sh`.
- The Codex setup includes an interactive login step. Claude Code setup only adds and verifies the MCP server entry.

---

## 한국어

### 개요

이 저장소는 Notion 중심 워크플로우를 위한 로컬 스킬 정의와 참고 자료를 담고 있습니다.

현재 포함된 스킬:

- `skills/notion-mcp-page-authoring`: 워크스페이스 규칙을 따르면서 Notion MCP로 페이지를 생성하고 수정하는 스킬
- `skills/notion-paper-page-authoring`: 기존 Notion 페이지 구조와 워크스페이스 규칙을 유지한 채 arXiv 논문을 정리하는 스킬

### 저장소 구조

- `skills/`: 스킬 패키지
- `skills/*/SKILL.md`: 각 스킬의 진입점과 작업 절차
- `skills/*/references/`: 규칙과 참고 자료
- `skills/*/agents/`: 에이전트별 설정
- `setup_codex.sh`: Codex용 Notion MCP 서버 설정 및 검증 스크립트
- `setup_claude_code.sh`: Claude Code용 Notion MCP 서버 설정 및 검증 스크립트

### Notion MCP 설정

두 스크립트는 기본적으로 같은 Notion MCP 엔드포인트를 사용합니다.

- `SERVER_NAME=notion`
- `NOTION_MCP_URL=https://mcp.notion.com/mcp`

두 스크립트 모두 먼저 `curl`로 엔드포인트 도달 가능 여부를 확인합니다.

### Codex 설정

실행:

```bash
./setup_codex.sh
```

필수 조건:

- `codex`
- `curl`

스크립트 동작:

- `codex` 설치 여부 확인
- Notion MCP 엔드포인트 도달 가능 여부 확인
- 기본값으로 `~/.codex/config.toml`에 MCP 서버 설정 작성
- 기존 설정 파일이 있으면 `~/.codex/config.toml.bak.<timestamp>`로 백업 생성
- 기존 `[mcp_servers.<SERVER_NAME>]` 섹션이 있으면 제거 후 새 값으로 다시 작성
- `codex mcp get <SERVER_NAME> --json`으로 등록 결과 검증
- `codex mcp login <SERVER_NAME>`를 실행해 인증 절차 진행

지원 환경 변수:

- `SERVER_NAME`
- `NOTION_MCP_URL`
- `CODEX_CONFIG_FILE`
- `CURL_MAX_TIME`

환경 변수 예시:

```bash
SERVER_NAME=notion \
NOTION_MCP_URL=https://mcp.notion.com/mcp \
CODEX_CONFIG_FILE="$HOME/.codex/config.toml" \
./setup_codex.sh
```

### Claude Code 설정

실행:

```bash
./setup_claude_code.sh
```

필수 조건:

- `claude`
- `curl`

스크립트 동작:

- `claude` 설치 여부 확인
- Notion MCP 엔드포인트 도달 가능 여부 확인
- `claude mcp add --transport http <SERVER_NAME> <NOTION_MCP_URL>`로 서버 등록
- add 명령이 실패해도 이미 등록된 상태인지 추가 확인
- `claude mcp get <SERVER_NAME>` 또는 `claude mcp list`로 등록 결과 검증

지원 환경 변수:

- `SERVER_NAME`
- `NOTION_MCP_URL`
- `CURL_MAX_TIME`

환경 변수 예시:

```bash
SERVER_NAME=notion \
NOTION_MCP_URL=https://mcp.notion.com/mcp \
./setup_claude_code.sh
```

### 참고

- 이 저장소는 애플리케이션 프로젝트가 아니라 스킬과 참고 자료를 모아둔 저장소입니다.
- README는 현재 실제 파일명인 `setup_codex.sh`, `setup_claude_code.sh` 기준으로 작성했습니다.
- Codex 설정은 대화형 로그인 단계가 포함되고, Claude Code 설정은 MCP 서버 등록 및 검증만 수행합니다.
