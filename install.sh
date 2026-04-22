#!/usr/bin/env bash
# install.sh — opencode-bridge shell alias installer
# Adds claude-free and claude-local aliases to the user's shell rc.
# Usage: bash install.sh [--uninstall]

set -euo pipefail

MARKER='# opencode-bridge aliases'
CONFIG_TEMPLATE="$(cd "$(dirname "$0")" && pwd)/config/opencode-template.json"
OPENCODE_CONFIG="$HOME/.config/opencode/opencode.json"

# Detect shell rc
detect_rc() {
  if [[ -n "${ZDOTDIR:-}" ]]; then
    echo "${ZDOTDIR}/.zshrc"
  elif [[ -f "$HOME/.zshrc" ]]; then
    echo "$HOME/.zshrc"
  elif [[ -f "$HOME/.bashrc" ]]; then
    echo "$HOME/.bashrc"
  elif [[ -f "$HOME/.bash_profile" ]]; then
    echo "$HOME/.bash_profile"
  else
    echo "$HOME/.zshrc"  # fallback: create .zshrc
  fi
}

RC=$(detect_rc)

# Uninstall mode
if [[ "${1:-}" == "--uninstall" ]]; then
  if grep -qF "$MARKER" "$RC" 2>/dev/null; then
    # Remove lines between marker and end marker
    sed -i.bak "/^$MARKER$/,/^# end opencode-bridge aliases$/d" "$RC"
    echo "opencode-bridge aliases removed from $RC"
    echo "  Backup saved as ${RC}.bak"
  else
    echo "opencode-bridge aliases not found in $RC"
  fi
  exit 0
fi

# The correct alias format: opencode reads model from opencode.json config
# OPENCODE_MODEL env var is not a real OpenCode API — use --model flag instead
CLAUDE_FREE_ALIAS="alias claude-free='opencode --model opencode/gpt-5-nano'"
CLAUDE_LOCAL_ALIAS="alias claude-local='opencode --model ollama/qwen2.5-coder:7b'"

# Check if already installed
if grep -qF "$MARKER" "$RC" 2>/dev/null; then
  echo "opencode-bridge aliases already installed in $RC"
  echo "  claude-free   -> OpenCode with Zen (opencode/gpt-5-nano)"
  echo "  claude-local  -> OpenCode with Ollama (ollama/qwen2.5-coder:7b)"
  exit 0
fi

# Install opencode.json config if missing
if [ ! -f "$OPENCODE_CONFIG" ] && [ -f "$CONFIG_TEMPLATE" ]; then
  mkdir -p "$(dirname "$OPENCODE_CONFIG")"
  cp "$CONFIG_TEMPLATE" "$OPENCODE_CONFIG"
  echo "OpenCode config installed: $OPENCODE_CONFIG"
fi

# Append aliases
cat >> "$RC" << EOF

$MARKER
$CLAUDE_FREE_ALIAS
$CLAUDE_LOCAL_ALIAS
# end opencode-bridge aliases
EOF

echo "Aliases installed in $RC"
echo ""
echo "  claude-free   -> OpenCode with Zen (opencode/gpt-5-nano)"
echo "  claude-local  -> OpenCode with Ollama (ollama/qwen2.5-coder:7b)"
echo ""
echo "Reload your shell or run: source $RC"
echo ""
echo "Note: Run 'opencode' then '/connect' to authenticate with Zen cloud."
