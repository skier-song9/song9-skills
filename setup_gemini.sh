#!/usr/bin/env bash

set -u
set -o pipefail

SERVER_NAME="${SERVER_NAME:-notion}"
NOTION_MCP_URL="${NOTION_MCP_URL:-https://mcp.notion.com/mcp}"
GEMINI_SETTINGS_FILE="${GEMINI_SETTINGS_FILE:-$HOME/.gemini/settings.json}"
CURL_MAX_TIME="${CURL_MAX_TIME:-15}"
SKIP_ENDPOINT_CHECK="${SKIP_ENDPOINT_CHECK:-0}"

if [[ -t 1 ]]; then
  RED=$'\033[31m'
  GREEN=$'\033[32m'
  YELLOW=$'\033[33m'
  BLUE=$'\033[34m'
  RESET=$'\033[0m'
else
  RED=""
  GREEN=""
  YELLOW=""
  BLUE=""
  RESET=""
fi

info() {
  printf "%s[INFO]%s %s\n" "$BLUE" "$RESET" "$*"
}

success() {
  printf "%s[SUCCESS]%s %s\n" "$GREEN" "$RESET" "$*"
}

warn() {
  printf "%s[WARN]%s %s\n" "$YELLOW" "$RESET" "$*"
}

fail() {
  printf "%s[FAIL]%s %s\n" "$RED" "$RESET" "$*" >&2
  exit 1
}

require_command() {
  local cmd="$1"

  if ! command -v "$cmd" >/dev/null 2>&1; then
    fail "Required command '$cmd' is not installed or not on PATH."
  fi
}

check_notion_endpoint() {
  local stderr_file curl_status http_code stderr_text

  require_command curl

  stderr_file="$(mktemp)"
  http_code="$(curl -sS -o /dev/null -w '%{http_code}' --max-time "$CURL_MAX_TIME" "$NOTION_MCP_URL" 2>"$stderr_file")"
  curl_status=$?
  stderr_text="$(tr '\n' ' ' < "$stderr_file")"
  rm -f "$stderr_file"

  if [[ $curl_status -ne 0 ]]; then
    fail "Notion MCP endpoint test failed. curl exited with status $curl_status. ${stderr_text:-No additional error output.}"
  fi

  case "$http_code" in
    2*|3*|400|401|403|405|406)
      success "Notion MCP endpoint is reachable at $NOTION_MCP_URL (HTTP $http_code)."
      ;;
    404)
      fail "Notion MCP endpoint returned HTTP 404. Check the configured URL: $NOTION_MCP_URL"
      ;;
    5*)
      fail "Notion MCP endpoint is reachable but unhealthy (HTTP $http_code)."
      ;;
    *)
      fail "Notion MCP endpoint returned an unexpected HTTP status: $http_code"
      ;;
  esac
}

write_gemini_settings() {
  local config_dir tmp_file backup_file timestamp python_output

  config_dir="$(dirname "$GEMINI_SETTINGS_FILE")"
  mkdir -p "$config_dir" || fail "Could not create Gemini config directory: $config_dir"

  timestamp="$(date +%Y%m%d%H%M%S)"
  tmp_file="$(mktemp)"

  if [[ -f "$GEMINI_SETTINGS_FILE" ]]; then
    backup_file="${GEMINI_SETTINGS_FILE}.bak.${timestamp}"
    cp "$GEMINI_SETTINGS_FILE" "$backup_file" || fail "Could not back up $GEMINI_SETTINGS_FILE"
    info "Backed up the existing Gemini settings to $backup_file"
  fi

  python_output="$(
    GEMINI_SETTINGS_FILE="$GEMINI_SETTINGS_FILE" \
    GEMINI_TMP_FILE="$tmp_file" \
    SERVER_NAME="$SERVER_NAME" \
    NOTION_MCP_URL="$NOTION_MCP_URL" \
    python3 <<'PY'
import json
import os
import pathlib
import sys

settings_path = pathlib.Path(os.environ["GEMINI_SETTINGS_FILE"])
tmp_path = pathlib.Path(os.environ["GEMINI_TMP_FILE"])
server_name = os.environ["SERVER_NAME"]
notion_mcp_url = os.environ["NOTION_MCP_URL"]

if settings_path.exists():
    raw = settings_path.read_text(encoding="utf-8")
    if raw.strip():
        try:
            data = json.loads(raw)
        except json.JSONDecodeError as exc:
            raise SystemExit(f"{settings_path} is not valid JSON: {exc}")
    else:
        data = {}
else:
    data = {}

if not isinstance(data, dict):
    raise SystemExit(f"{settings_path} must contain a top-level JSON object.")

mcp_servers = data.get("mcpServers")
if mcp_servers is None:
    mcp_servers = {}
elif not isinstance(mcp_servers, dict):
    raise SystemExit("The existing 'mcpServers' value must be a JSON object.")
else:
    mcp_servers = {key: value for key, value in mcp_servers.items() if key != server_name}

mcp_servers[server_name] = {"url": notion_mcp_url}

data = {key: value for key, value in data.items() if key != "mcpServers"}
data["mcpServers"] = mcp_servers

tmp_path.write_text(json.dumps(data, indent=2) + "\n", encoding="utf-8")
PY
  )" || {
    rm -f "$tmp_file"
    fail "Could not update $GEMINI_SETTINGS_FILE. ${python_output:-No additional error output.}"
  }

  mv "$tmp_file" "$GEMINI_SETTINGS_FILE" || fail "Could not write $GEMINI_SETTINGS_FILE"
}

main() {
  info "Checking prerequisites."
  require_command python3

  if [[ "$SKIP_ENDPOINT_CHECK" == "1" ]]; then
    warn "Skipping Notion MCP endpoint reachability test because SKIP_ENDPOINT_CHECK=1."
  else
    info "Testing reachability of the Notion MCP endpoint."
    check_notion_endpoint
  fi

  info "Updating the Gemini CLI settings in $GEMINI_SETTINGS_FILE."
  write_gemini_settings

  success "Gemini CLI now has an MCP server entry named '$SERVER_NAME' pointing to $NOTION_MCP_URL."
  warn "The first time Gemini CLI calls '@$SERVER_NAME', complete the OAuth flow in your browser before retrying the MCP request."
  warn "If Gemini CLI is already running, restart it so it reloads the updated settings."
}

main "$@"
