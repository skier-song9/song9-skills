[English](./README.md) | **한국어**

# 🛠️ song9-skills

개인적으로 유용하게 사용하는 스킬 모음입니다.

## ⚙️ Preliminaries

이 스킬들을 사용하려면 MCP 서버와 기타 로컬 설정이 먼저 필요합니다.

사용하는 AI agent에 맞는 설정 스크립트를 실행하세요.

- Codex: `./setup_codex.sh`
- Claude Code: `./setup_claude_code.sh`
- Gemini CLI: `./setup_gemini.sh`

자동화된 셸 스크립트를 신뢰하고 싶지 않거나, 현재 환경에서 스크립트 실행에 실패했다면 먼저 아래 항목을 수동으로 설치하세요.

| requirements | guide url |
| --- | --- |
| Notion MCP server | https://developers.notion.com/guides/mcp/get-started-with-mcp |

## 🚀 설치 방법

이 저장소를 agent가 직접 읽어서 바로 스킬로 사용하는 것은 아닙니다.
먼저 저장소를 clone한 뒤, `skills/` 아래의 스킬 디렉터리들을 각 agent가 읽는 스킬 경로로 복사해야 합니다.

원격 환경에 설치할 때는 먼저 대상 서버에 SSH로 접속한 뒤, 같은 명령을 그 환경에서 실행하면 됩니다.

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

모든 스킬이 아니라 일부만 설치하고 싶다면 `skills/*` 대신 필요한 디렉터리만 골라서 복사하면 됩니다. CLI가 이미 실행 중이면 파일 복사 후 다시 시작하세요.

## 🧩 Skills

| 스킬 | 목적 | `short_description` |
| --- | --- | --- |
| `notion-mcp-page-authoring` | 워크스페이스별 페이지 규칙과 포맷을 지키면서 Notion 페이지를 생성하고 수정합니다. | `Create and update Notion pages with rules` |
| `notion-paper-page-authoring` | 기존 페이지 구조와 워크스페이스 규칙을 유지하면서 arXiv 논문 내용을 Notion 페이지에 정리합니다. | `Write arXiv paper notes into a Notion page` |
