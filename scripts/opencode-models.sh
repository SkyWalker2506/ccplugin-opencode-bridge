#!/usr/bin/env bash
# opencode-models.sh — List all available models (Zen cloud + Ollama local)
# Usage: bash scripts/opencode-models.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PLUGIN_DIR="$(dirname "$SCRIPT_DIR")"
MODELS_JSON="$PLUGIN_DIR/config/models.json"
OPENCODE_CONFIG="$HOME/.config/opencode/opencode.json"

# Get current model
CURRENT_MODEL="unknown"
if [ -f "$OPENCODE_CONFIG" ] && command -v python3 &>/dev/null; then
  CURRENT_MODEL=$(python3 -c "
import json
try:
    d = json.load(open('$OPENCODE_CONFIG'))
    print(d.get('model', 'unknown'))
except Exception:
    print('unknown')
" 2>/dev/null)
fi

echo ""
echo "Available Models"
echo "================"
echo ""
echo "Zen (cloud, free):"

if command -v python3 &>/dev/null && [ -f "$MODELS_JSON" ]; then
  python3 -c "
import json
models = json.load(open('$MODELS_JSON'))
for m in models.get('zen', []):
    current = ' <-- current' if m['id'] == '$CURRENT_MODEL' else ''
    print(f\"  {m['id']:<45} {m['notes']}{current}\")
"
fi

echo ""
echo "Ollama (local):"

# Show pulled models first
PULLED_MODELS=""
if command -v ollama &>/dev/null; then
  PULLED_MODELS=$(ollama list 2>/dev/null | tail -n +2 | awk '{print $1}' || true)
fi

if command -v python3 &>/dev/null && [ -f "$MODELS_JSON" ]; then
  python3 -c "
import json, subprocess
models = json.load(open('$MODELS_JSON'))
pulled = '''$PULLED_MODELS'''.strip().split('\n') if '''$PULLED_MODELS'''.strip() else []

for m in models.get('ollama', []):
    model_tag = m['id'].replace('ollama/', '')
    status = 'pulled, ready' if model_tag in pulled else f\"{m['size_gb']}GB — pull with: ollama pull {model_tag}\"
    current = ' <-- current' if m['id'] == '$CURRENT_MODEL' else ''
    print(f\"  {m['id']:<45} {status}{current}\")
"
fi

echo ""
echo "Current model: $CURRENT_MODEL"
echo ""
echo "Switch models:"
echo "  claude-free   -> opencode --model opencode/gpt-5-nano"
echo "  claude-local  -> opencode --model ollama/qwen2.5-coder:7b"
echo ""
echo "Or use: bash scripts/opencode-config.sh set-model <model-id>"
