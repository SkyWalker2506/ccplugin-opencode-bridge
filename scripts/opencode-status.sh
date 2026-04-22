#!/usr/bin/env bash
# opencode-status.sh — Check OpenCode CLI, Ollama, and config status
# Usage: bash scripts/opencode-status.sh

set -euo pipefail

OPENCODE_CONFIG="$HOME/.config/opencode/opencode.json"
MIN_VERSION="0.1.0"  # Minimum required opencode-ai version

echo "OpenCode Bridge Status"
echo "----------------------"

# 1. Check OpenCode CLI
if command -v opencode &>/dev/null; then
  OC_VERSION=$(opencode --version 2>/dev/null | head -1 || echo "unknown")
  echo "CLI:        installed ($OC_VERSION)"
else
  echo "CLI:        NOT installed"
  echo "            Install with: npm install -g opencode-ai"
fi

# 2. Check Zen connection (via config)
if [ -f "$OPENCODE_CONFIG" ] && command -v python3 &>/dev/null; then
  ZEN_STATUS=$(python3 -c "
import json, os
try:
    d = json.load(open('$OPENCODE_CONFIG'))
    providers = d.get('enabled_providers', [])
    model = d.get('model', 'unknown')
    if 'opencode' in providers:
        print(f'configured (model: {model})')
    else:
        print('not in enabled_providers')
except Exception as e:
    print(f'error reading config: {e}')
" 2>/dev/null)
  echo "Zen:        $ZEN_STATUS"
else
  echo "Zen:        config not found ($OPENCODE_CONFIG)"
fi

# 3. Check Ollama
if command -v ollama &>/dev/null; then
  OLLAMA_MODELS=$(ollama list 2>/dev/null | tail -n +2 | awk '{print $1}' | tr '\n' ', ' | sed 's/,$//')
  if [ -n "$OLLAMA_MODELS" ]; then
    echo "Ollama:     running (models: $OLLAMA_MODELS)"
  else
    echo "Ollama:     installed but no models pulled"
    echo "            Pull a model: ollama pull qwen2.5-coder:7b"
  fi
else
  echo "Ollama:     not installed"
  echo "            Install: brew install ollama"
fi

# 4. Config summary
if [ -f "$OPENCODE_CONFIG" ]; then
  echo "Config:     $OPENCODE_CONFIG"
  if command -v python3 &>/dev/null; then
    python3 -c "
import json
try:
    d = json.load(open('$OPENCODE_CONFIG'))
    providers = d.get('enabled_providers', [])
    model = d.get('model', 'unknown')
    print(f'Providers:  {providers}')
    print(f'Model:      {model}')
except Exception:
    pass
" 2>/dev/null
  fi
else
  echo "Config:     not found"
  echo "            Run install.sh to create default config"
fi

echo ""
echo "Aliases (if installed):"
echo "  claude-free   -> opencode --model opencode/gpt-5-nano"
echo "  claude-local  -> opencode --model ollama/qwen2.5-coder:7b"
