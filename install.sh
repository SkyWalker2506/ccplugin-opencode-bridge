#!/usr/bin/env bash
# install.sh — opencode-bridge shell alias installer
# Adds claude-free and claude-local aliases to the user's shell rc.

set -euo pipefail

CLAUDE_FREE_ALIAS='alias claude-free=\'OPENCODE_MODEL=opencode/gpt-5-nano opencode\''
CLAUDE_LOCAL_ALIAS='alias claude-local=\'OPENCODE_MODEL=ollama/qwen2.5-coder:7b opencode\''

MARKER='# opencode-bridge aliases'

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

# Check if already installed
if grep -qF "$MARKER" "$RC" 2>/dev/null; then
  echo "opencode-bridge aliases already installed in $RC"
  echo "  claude-free   → OpenCode with Zen (opencode/gpt-5-nano)"
  echo "  claude-local  → OpenCode with Ollama (ollama/qwen2.5-coder:7b)"
  exit 0
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
echo "  claude-free   → OpenCode with Zen (opencode/gpt-5-nano)"
echo "  claude-local  → OpenCode with Ollama (ollama/qwen2.5-coder:7b)"
echo ""
echo "Reload your shell or run: source $RC"
