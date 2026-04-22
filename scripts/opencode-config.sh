#!/usr/bin/env bash
# opencode-config.sh — Read and write ~/.config/opencode/opencode.json safely
# Usage:
#   bash scripts/opencode-config.sh show                    — Print current config
#   bash scripts/opencode-config.sh set-model <model>       — Set default model
#   bash scripts/opencode-config.sh reset                   — Reset to template
#   bash scripts/opencode-config.sh add-provider <name>     — Enable a provider

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PLUGIN_DIR="$(dirname "$SCRIPT_DIR")"
OPENCODE_CONFIG="$HOME/.config/opencode/opencode.json"
CONFIG_TEMPLATE="$PLUGIN_DIR/config/opencode-template.json"

ACTION="${1:-show}"

require_python() {
  if ! command -v python3 &>/dev/null; then
    echo "Error: python3 required for config operations" >&2
    exit 1
  fi
}

require_config() {
  if [ ! -f "$OPENCODE_CONFIG" ]; then
    echo "Error: config not found at $OPENCODE_CONFIG" >&2
    echo "Run: bash install.sh (to create from template)" >&2
    exit 1
  fi
}

case "$ACTION" in
  show)
    require_config
    cat "$OPENCODE_CONFIG"
    ;;

  set-model)
    MODEL="${2:-}"
    if [ -z "$MODEL" ]; then
      echo "Usage: opencode-config.sh set-model <model>" >&2
      echo "Example: opencode-config.sh set-model opencode/gpt-5-nano" >&2
      exit 1
    fi
    require_config
    require_python
    python3 -c "
import json
config = json.load(open('$OPENCODE_CONFIG'))
config['model'] = '$MODEL'
config['small_model'] = '$MODEL'
with open('$OPENCODE_CONFIG', 'w') as f:
    json.dump(config, f, indent=2)
print('Model set to: $MODEL')
"
    ;;

  reset)
    if [ ! -f "$CONFIG_TEMPLATE" ]; then
      echo "Error: template not found at $CONFIG_TEMPLATE" >&2
      exit 1
    fi
    if [ -f "$OPENCODE_CONFIG" ]; then
      BACKUP="${OPENCODE_CONFIG}.bak.$(date +%Y%m%d_%H%M%S)"
      cp "$OPENCODE_CONFIG" "$BACKUP"
      echo "Backup saved: $BACKUP"
    fi
    mkdir -p "$(dirname "$OPENCODE_CONFIG")"
    cp "$CONFIG_TEMPLATE" "$OPENCODE_CONFIG"
    echo "Config reset to template: $OPENCODE_CONFIG"
    ;;

  add-provider)
    PROVIDER="${2:-}"
    if [ -z "$PROVIDER" ]; then
      echo "Usage: opencode-config.sh add-provider <name>" >&2
      exit 1
    fi
    require_config
    require_python
    python3 -c "
import json
config = json.load(open('$OPENCODE_CONFIG'))
providers = config.get('enabled_providers', [])
if '$PROVIDER' not in providers:
    providers.append('$PROVIDER')
    config['enabled_providers'] = providers
    with open('$OPENCODE_CONFIG', 'w') as f:
        json.dump(config, f, indent=2)
    print('Provider added: $PROVIDER')
else:
    print('Provider already enabled: $PROVIDER')
"
    ;;

  *)
    echo "Unknown action: $ACTION" >&2
    echo "Usage: opencode-config.sh [show|set-model|reset|add-provider]" >&2
    exit 1
    ;;
esac
