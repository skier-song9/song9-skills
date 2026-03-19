#!/usr/bin/env bash

set -u
set -o pipefail

SERVER_NAME="${SERVER_NAME:-notion}"
NOTION_MCP_URL="${NOTION_MCP_URL:-https://mcp.notion.com/mcp}"
CODEX_CONFIG_FILE="${CODEX_CONFIG_FILE:-$HOME/.codex/config.toml}"
CURL_MAX_TIME="${CURL_MAX_TIME:-15}"

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

write_codex_config() {
  local config_dir tmp_file backup_file timestamp

  config_dir="$(dirname "$CODEX_CONFIG_FILE")"
  mkdir -p "$config_dir" || fail "Could not create Codex config directory: $config_dir"

  timestamp="$(date +%Y%m%d%H%M%S)"
  tmp_file="$(mktemp)"

  if [[ -f "$CODEX_CONFIG_FILE" ]]; then
    backup_file="${CODEX_CONFIG_FILE}.bak.${timestamp}"
    cp "$CODEX_CONFIG_FILE" "$backup_file" || fail "Could not back up $CODEX_CONFIG_FILE"
    info "Backed up the existing Codex config to $backup_file"

    awk -v section="[mcp_servers.${SERVER_NAME}]" '
      $0 == section {
        skip = 1
        next
      }

      skip && /^\[/ {
        skip = 0
      }

      !skip {
        print
      }
    ' "$CODEX_CONFIG_FILE" >"$tmp_file" || fail "Could not prepare the updated Codex config."
  else
    : >"$tmp_file"
  fi

  printf '\n[mcp_servers.%s]\nurl = "%s"\n' "$SERVER_NAME" "$NOTION_MCP_URL" >>"$tmp_file"
  mv "$tmp_file" "$CODEX_CONFIG_FILE" || fail "Could not write $CODEX_CONFIG_FILE"
}

verify_codex_registration() {
  local output

  output="$(codex mcp get "$SERVER_NAME" --json 2>&1)" || fail "Codex could not read the '$SERVER_NAME' MCP configuration. $output"

  if ! printf '%s' "$output" | grep -Eq "\"name\"[[:space:]]*:[[:space:]]*\"$SERVER_NAME\""; then
    fail "Codex returned MCP config output, but it did not include the expected server name '$SERVER_NAME'."
  fi

  if ! printf '%s' "$output" | grep -Eq "\"url\"[[:space:]]*:[[:space:]]*\"$NOTION_MCP_URL\""; then
    fail "Codex returned MCP config output, but the configured URL does not match $NOTION_MCP_URL."
  fi

  success "Codex reports that '$SERVER_NAME' points to $NOTION_MCP_URL."
}

main() {
  local login_status list_output auth_hint

  info "Checking prerequisites."
  require_command codex

  info "Testing reachability of the Notion MCP endpoint."
  check_notion_endpoint

  info "Updating the Codex MCP configuration in $CODEX_CONFIG_FILE."
  write_codex_config

  info "Verifying that Codex can read the Notion MCP configuration."
  verify_codex_registration

  info "Running 'codex mcp login $SERVER_NAME'. Complete the browser flow if Codex prompts for authentication."
  if codex mcp login "$SERVER_NAME"; then
    success "Codex login completed."
  else
    login_status=$?
    auth_hint=""
    list_output="$(codex mcp list --json 2>/dev/null || true)"

    if printf '%s' "$list_output" | grep -Eq "\"name\"[[:space:]]*:[[:space:]]*\"$SERVER_NAME\"" && printf '%s' "$list_output" | grep -Eq "\"auth_status\"[[:space:]]*:[[:space:]]*\"unsupported\""; then
      auth_hint=" The installed Codex CLI currently reports OAuth as unsupported for '$SERVER_NAME'."
    fi

    fail "Codex login failed with exit code $login_status.${auth_hint} Read the CLI output above for the exact failure message."
  fi

  success "Codex Notion MCP setup test completed."
}

main "$@"
