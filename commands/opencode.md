# /opencode

Manage OpenCode/Zen connections, switch models, and configure local Ollama.

## Usage

| Command | Behavior |
|---------|----------|
| `/opencode` | Show current OpenCode setup status (Zen + Ollama) |
| `/opencode zen` | Connect to Zen cloud, set free model (gpt-5-nano) |
| `/opencode local` | Switch to Ollama local model (qwen2.5-coder:7b) |
| `/opencode models` | List available models (Zen free + Ollama pulled) |
| `/opencode pull <model>` | Pull an Ollama model (e.g., `gemma3:4b`, `qwen2.5-coder:7b`) |
| `/opencode config` | Show and edit `~/.config/opencode/opencode.json` |
| `/opencode install` | Install or update OpenCode CLI (`npm install -g opencode-ai`) |

## Execution

### Default: Show Status

When invoked without arguments, run the status script:

```bash
bash ~/.claude/plugins/opencode-bridge/scripts/opencode-status.sh
```

Display the output. The script checks:

```
1. Check if OpenCode CLI is installed:
   - Run: which opencode
   - If missing, offer to install: npm install -g opencode-ai

2. Check Ollama status:
   - Run: ollama list 2>/dev/null
   - Show pulled models or note that Ollama is not running

3. Check config file:
   - Read: ~/.config/opencode/opencode.json
   - Show current model, small_model, enabled_providers

4. Display summary:

   OpenCode Bridge Status
   ----------------------
   CLI:        installed (vX.X.X) | not installed
   Zen:        connected (model: opencode/gpt-5-nano) | not connected
   Ollama:     running (models: qwen2.5-coder:7b, gemma3:4b) | not running
   Config:     ~/.config/opencode/opencode.json
   Providers:  ["opencode", "ollama"]
```

### `/opencode zen` -- Connect to Zen Cloud

```
1. Verify OpenCode CLI is installed (install if missing)
2. Check if ~/.config/opencode/opencode.json exists
   - If not, copy from ~/Projects/claude-config/templates/opencode.json
3. Remind user to authenticate:
   - "Run `opencode` then `/connect` -> select `opencode` -> paste API key from https://opencode.ai/auth"
   - Or set env: export OPENCODE_ZEN_API_KEY='sk-...' in ~/.zshrc
4. Set model to opencode/gpt-5-nano (default free tier)
5. Show available Zen free models:

   Zen Free Models
   ---------------
   opencode/gpt-5-nano        -- Free tier (default)
   opencode/minimax-m2.1-free -- Free, limited time
   opencode/glm-4.7-free      -- Free, limited time
   opencode/kimi-k2.5-free    -- Free, limited time
   opencode/big-pickle         -- Free, limited time
```

### `/opencode local` -- Switch to Ollama

```
1. Check if Ollama is running: ollama list
   - If not running, warn: "Start Ollama first: `ollama serve`"
2. Check pulled models: ollama list
   - If no models, offer to pull: ollama pull qwen2.5-coder:7b
3. Update ~/.config/opencode/opencode.json:
   - Set model to ollama/qwen2.5-coder:7b (or user's choice)
   - Ensure "ollama" is in enabled_providers
4. Confirm: "Switched to local Ollama model. Run `opencode` to start."
```

### `/opencode models` -- List All Available Models

```
1. Read ~/.config/opencode/opencode.json for configured models
2. Run: ollama list (for locally pulled models)
3. Display combined list:

   Available Models
   ================

   Zen (cloud, free):
     opencode/gpt-5-nano          -- Free tier
     opencode/minimax-m2.1-free   -- Free, limited
     opencode/glm-4.7-free        -- Free, limited
     opencode/kimi-k2.5-free      -- Free, limited
     opencode/big-pickle           -- Free, limited

   Ollama (local):
     ollama/qwen2.5-coder:7b      -- Pulled, ready
     ollama/gemma3:4b              -- Pulled, ready

   Current model: opencode/gpt-5-nano
```

### `/opencode pull <model>` -- Pull Ollama Model

```
1. Run: ollama pull <model>
2. On success, add to opencode.json provider.ollama.models if not present
3. Confirm: "Model <model> pulled. Switch with: /opencode local"
```

### `/opencode config` -- Show/Edit Config

```
1. Read and display ~/.config/opencode/opencode.json
2. Offer options:
   a) Reset to template: cp ~/Projects/claude-config/templates/opencode.json ~/.config/opencode/opencode.json
   b) Change default model
   c) Toggle providers (opencode only / ollama only / both)
```

### `/opencode install` -- Install CLI

```
1. Run: npm install -g opencode-ai
2. Verify: opencode --version
3. If config missing, copy template:
   cp ~/Projects/claude-config/templates/opencode.json ~/.config/opencode/opencode.json
```

## Quick Shell Aliases

These aliases are set up by claude-config's install.sh:

| Alias | What it does |
|-------|-------------|
| `claude-free` | Opens OpenCode TUI with Zen model (opencode/gpt-5-nano) |
| `claude-local` | Opens OpenCode TUI with Ollama model (ollama/qwen2.5-coder:7b) |

## Notes

- Zen free models may have data collection policies -- see [Zen Pricing & Privacy](https://open-code.ai/docs/en/zen)
- Ollama requires no API key and runs fully local
- Config template source: `~/Projects/claude-config/templates/opencode.json`
- `install.sh --refresh-opencode-config` will overwrite config with template (backs up first)
