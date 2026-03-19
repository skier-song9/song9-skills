[English](./README.md) | **한국어**

# song9-skills

Codex와 Claude Code를 위한 로컬 스킬 패키지와 Notion MCP 설정 스크립트를 담은 저장소입니다.

## 개요

이 저장소는 Notion 중심 워크플로우를 위한 로컬 스킬 정의와 참고 자료를 담고 있습니다.

현재 포함된 스킬:

- `skills/notion-mcp-page-authoring`: 워크스페이스 규칙을 따르면서 Notion MCP로 페이지를 생성하고 수정하는 스킬
- `skills/notion-paper-page-authoring`: 기존 Notion 페이지 구조와 워크스페이스 규칙을 유지한 채 arXiv 논문을 정리하는 스킬

## 저장소 구조

- `skills/`: 스킬 패키지
- `skills/*/SKILL.md`: 각 스킬의 진입점과 작업 절차
- `skills/*/references/`: 규칙과 참고 자료
- `skills/*/agents/`: 에이전트별 설정
- `setup_codex.sh`: Codex용 Notion MCP 서버 설정 및 검증 스크립트
- `setup_claude_code.sh`: Claude Code용 Notion MCP 서버 설정 및 검증 스크립트

## Notion MCP 설정

두 스크립트는 기본적으로 같은 Notion MCP 엔드포인트를 사용합니다.

- `SERVER_NAME=notion`
- `NOTION_MCP_URL=https://mcp.notion.com/mcp`

두 스크립트 모두 먼저 `curl`로 엔드포인트 도달 가능 여부를 확인합니다.

## Codex 설정

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

## Claude Code 설정

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

## 참고

- 이 저장소는 애플리케이션 프로젝트가 아니라 스킬과 참고 자료를 모아둔 저장소입니다.
- README는 현재 실제 파일명인 `setup_codex.sh`, `setup_claude_code.sh` 기준으로 작성했습니다.
- Codex 설정은 대화형 로그인 단계가 포함되고, Claude Code 설정은 MCP 서버 등록 및 검증만 수행합니다.
