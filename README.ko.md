[English](./README.md) | **한국어**

# 🛠️ song9-skills

개인적으로 유용하게 사용하는 스킬 모음입니다.

## 📚 목차

- [⚙️ Preliminaries](#preliminaries)
- [🚀 설치 방법](#getting-started)
- [💻 Codex 설치](#codex)
- [🧠 Claude Code 설치](#claude-code)
- [✨ Gemini CLI 설치](#gemini-cli)
- [🎯 Codex 기준 기본값](#codex-first-defaults)
- [🧩 Skills](#skills)
- [🤖 Ralph](#ralph)

<a id="preliminaries"></a>
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

<a id="getting-started"></a>
## 🚀 설치 방법

이 저장소를 agent가 직접 읽어서 바로 스킬로 사용하는 것은 아닙니다.
먼저 저장소를 clone한 뒤, `skills/` 아래의 스킬 디렉터리들을 각 agent가 읽는 스킬 경로로 복사해야 합니다.

원격 환경에 설치할 때는 먼저 대상 서버에 SSH로 접속한 뒤, 같은 명령을 그 환경에서 실행하면 됩니다.

<a id="codex"></a>
### Codex

```bash
git clone https://github.com/skier-song9/song9-skills.git
mkdir -p ~/.codex/skills
cp -R song9-skills/skills/* ~/.codex/skills/
./song9-skills/setup_codex.sh
```

<a id="claude-code"></a>
### Claude Code

```bash
git clone https://github.com/skier-song9/song9-skills.git
mkdir -p ~/.claude/skills
cp -R song9-skills/skills/* ~/.claude/skills/
./song9-skills/setup_claude_code.sh
```

<a id="gemini-cli"></a>
### Gemini CLI

```bash
git clone https://github.com/skier-song9/song9-skills.git
mkdir -p ~/.gemini/extensions/song9-skills/skills
cp song9-skills/gemini-extension.json ~/.gemini/extensions/song9-skills/
cp -R song9-skills/skills/* ~/.gemini/extensions/song9-skills/skills/
./song9-skills/setup_gemini.sh
```

모든 스킬이 아니라 일부만 설치하고 싶다면 `skills/*` 대신 필요한 디렉터리만 골라서 복사하면 됩니다. CLI가 이미 실행 중이면 파일 복사 후 다시 시작하세요.

<a id="codex-first-defaults"></a>
## 🎯 Codex 기준 기본값

이 저장소는 Codex, Claude Code, Gemini CLI를 모두 지원하지만, `skills/` 아래 스킬들은 기본적으로 Codex를 기준으로 작성하고 관리합니다. 별도 안내가 없는 한 예시, 프롬프트 문구, 워크플로 전제는 Codex 우선으로 생각하면 됩니다.

<a id="skills"></a>
## 🧩 Skills

| 스킬 | 목적 | `short_description` |
| --- | --- | --- |
| `notion-mcp-page-authoring` | 워크스페이스별 페이지 규칙과 포맷을 지키면서 Notion 페이지를 생성하고 수정합니다. | `Create and update Notion pages with rules` |
| `notion-paper-page-authoring` | 기존 페이지 구조와 워크스페이스 규칙을 유지하면서 arXiv 논문 내용을 Notion 페이지에 정리합니다. | `Write arXiv paper notes into a Notion page` |
| `prd` | 구현을 시작하지 않고 새로운 기능용 PRD를 작성합니다. | `Generate a Product Requirements Document (PRD) for a new feature.` |
| `ralph` | 기존 PRD를 Ralph 실행용 `scripts/ralph/prd.json` 형식으로 변환합니다. | `Convert PRDs to prd.json format for the Ralph autonomous agent system.` |

<a id="ralph"></a>
## 🤖 Ralph

이 저장소에는 Codex 사용을 기준으로 조정한 Ralph agentic loop 설정도 `scripts/ralph/` 아래에 포함되어 있습니다.

- 원본 저장소: [snarktank/ralph.git](https://github.com/snarktank/ralph.git)
- Codex tool이 추가된 기반 fork: [bsgustavo/ralph_protocol.git](https://github.com/bsgustavo/ralph_protocol.git)
- 이 저장소에는 그 fork 위에 소규모 권한 관련 수정이 추가로 반영되어 있습니다.

기본 Codex 실행:

```bash
./scripts/ralph/ralph.sh --tool codex [max_iterations]
```

기본값으로 이 래퍼는 Codex를 `--dangerously-bypass-approvals-and-sandbox` 옵션으로 실행합니다. 샌드박스 안에서 더 안전한 Codex 경로를 쓰고 싶다면 `RALPH_CODEX_SAFE_MODE=1`을 지정해 `--full-auto`로 되돌려 실행하면 됩니다.

```bash
RALPH_CODEX_SAFE_MODE=1 ./scripts/ralph/ralph.sh --tool codex [max_iterations]
```

Ralph의 자세한 워크플로, 규칙, 사용 메모는 다음 Notion 페이지를 참고하세요: [notion/Ralph](https://skier-song9.notion.site/Ralph-333c8d3f60f580ec9098cb284f3cf096?source=copy_link) ⭐
