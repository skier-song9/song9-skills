#!/usr/bin/env bash

set -u
set -o pipefail

SERVER_NAME="${SERVER_NAME:-notion}"
NOTION_MCP_URL="${NOTION_MCP_URL:-https://mcp.notion.com/mcp}"
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

VERIFY_REASON=""

verify_claude_registration() {
  local output

  if output="$(claude mcp get "$SERVER_NAME" 2>&1)"; then
    if printf '%s' "$output" | grep -Fq "$NOTION_MCP_URL"; then
      VERIFY_REASON="Claude Code reports that '$SERVER_NAME' points to $NOTION_MCP_URL."
    else
      VERIFY_REASON="Claude Code reports that '$SERVER_NAME' is registered."
    fi
    return 0
  fi

  if output="$(claude mcp list 2>&1)"; then
    if printf '%s' "$output" | grep -Fqi "$SERVER_NAME"; then
      VERIFY_REASON="Claude Code lists '$SERVER_NAME' after setup."
      return 0
    fi

    VERIFY_REASON="Claude Code responded to 'claude mcp list', but '$SERVER_NAME' was not listed."
    return 1
  fi

  VERIFY_REASON="Claude Code could not verify MCP registration after setup. Neither 'claude mcp get $SERVER_NAME' nor 'claude mcp list' succeeded."
  return 1
}

main() {
  local add_output add_status

  info "Checking prerequisites."
  require_command claude

  info "Testing reachability of the Notion MCP endpoint."
  check_notion_endpoint

  info "Registering the Notion MCP server in Claude Code."
  add_output="$(claude mcp add --transport http "$SERVER_NAME" "$NOTION_MCP_URL" 2>&1)"
  add_status=$?

  if [[ $add_status -ne 0 ]]; then
    warn "The add command returned a non-zero exit code. Checking whether the server is already registered."

    if verify_claude_registration; then
      warn "Claude Code already appears to have a working '$SERVER_NAME' MCP entry. CLI output: ${add_output:-No output captured.}"
    else
      fail "Claude Code failed to add the Notion MCP server. Exit code $add_status. ${add_output:-No output captured.}"
    fi
  fi

  info "Verifying Claude Code MCP registration."
  if verify_claude_registration; then
    success "$VERIFY_REASON"
  else
    fail "$VERIFY_REASON"
  fi

  success "Claude Code Notion MCP setup test completed."
}

main "$@"
