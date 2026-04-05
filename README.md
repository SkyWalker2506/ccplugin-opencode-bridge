# opencode-bridge — Claude Code Plugin

by [Musab Kara](https://linkedin.com/in/musab-kara-85580612a) · [GitHub](https://github.com/SkyWalker2506)

Claude Code plugin for integrating with [OpenCode](https://opencode.ai/) -- providing access to both **Zen** (free cloud models) and **Ollama** (local models).

## Install

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/SkyWalker2506/claude-marketplace/main/install.sh) opencode-bridge
```

Or via Claude Code native marketplace:

```bash
claude plugin install opencode-bridge@musabkara-claude-marketplace
```

## What is this?

When Claude Code quota runs out or you need a free/local alternative, OpenCode bridges the gap:

- **Zen (cloud):** Free models like `gpt-5-nano`, `minimax-m2.1-free`, `glm-4.7-free`, `kimi-k2.5-free`, `big-pickle` -- no GPU required, runs via OpenCode's Zen cloud service
- **Ollama (local):** Fully local models like `qwen2.5-coder:7b`, `gemma3:4b` -- no API key, no internet needed, runs on your machine

Both providers are configured in a single `~/.config/opencode/opencode.json` file and can be switched on the fly.

## Command

| Command | Description |
|---------|-------------|
| `/opencode` | Show current OpenCode setup status |
| `/opencode zen` | Connect to Zen cloud, configure free models |
| `/opencode local` | Switch to Ollama local model |
| `/opencode models` | List all available models (cloud + local) |
| `/opencode pull <model>` | Pull an Ollama model |
| `/opencode config` | Show/edit OpenCode configuration |
| `/opencode install` | Install or update the OpenCode CLI |

## Setup

### 1. Install OpenCode CLI

```bash
npm install -g opencode-ai
```

### 2. Install Ollama (for local models)

```bash
# macOS
brew install ollama

# Then pull a model
ollama pull qwen2.5-coder:7b
ollama pull gemma3:4b
```

### 3. Configure Zen (for free cloud models)

```bash
# Option A: Use the TUI
opencode
# Then: /connect -> select "opencode" -> paste API key from https://opencode.ai/auth

# Option B: Set environment variable
export OPENCODE_ZEN_API_KEY='sk-...'  # Add to ~/.zshrc
```

### 4. Configuration File

The plugin uses `~/.config/opencode/opencode.json`:

```json
{
  "enabled_providers": ["opencode", "ollama"],
  "model": "opencode/gpt-5-nano",
  "small_model": "opencode/gpt-5-nano",
  "provider": {
    "opencode": {
      "options": { "apiKey": "{env:OPENCODE_ZEN_API_KEY}" },
      "models": {
        "gpt-5-nano": { "name": "Zen -- GPT-5 Nano (free tier)" },
        "minimax-m2.1-free": { "name": "Zen -- MiniMax M2.1 (free, limited)" },
        "glm-4.7-free": { "name": "Zen -- GLM 4.7 (free, limited)" }
      }
    },
    "ollama": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "Ollama (local)",
      "options": { "baseURL": "http://localhost:11434/v1" },
      "models": {
        "qwen2.5-coder:7b": { "name": "Qwen 2.5 Coder 7B (local)" }
      }
    }
  }
}
```

## Shell Aliases

Run `install.sh` to add these aliases directly to your shell rc (no `claude-config` required):

| Alias | What it does |
|-------|-------------|
| `claude-free` | Opens OpenCode with Zen model (`opencode/gpt-5-nano`) |
| `claude-local` | Opens OpenCode with Ollama model (`ollama/qwen2.5-coder:7b`) |

```bash
bash install.sh
source ~/.zshrc  # or ~/.bashrc
```

If you use [claude-config](https://github.com/SkyWalker2506/claude-config), these aliases are also set up by its `install.sh`.

## Auto-Trigger

The `skills/opencode-bridge/SKILL.md` skill auto-detects when you mention opencode, zen, ollama, local models, free models, or specific model names (qwen, gemma, etc.) and routes to the appropriate `/opencode` subcommand.

## Available Free Models

### Zen Cloud (via OpenCode)

| Model | Notes |
|-------|-------|
| `opencode/gpt-5-nano` | Free tier (default) |
| `opencode/minimax-m2.1-free` | Free, limited time |
| `opencode/glm-4.7-free` | Free, limited time |
| `opencode/kimi-k2.5-free` | Free, limited time |
| `opencode/big-pickle` | Free, limited time |

### Ollama Local

| Model | Size | Notes |
|-------|------|-------|
| `qwen2.5-coder:7b` | ~4.7 GB | Best for coding tasks |
| `gemma3:4b` | ~3.3 GB | Lightweight, general purpose |
| `qwen2.5-coder:14b` | ~9.0 GB | Higher quality, needs more RAM |
| `gemma3:12b` | ~8.1 GB | Larger Gemma, better quality |

Pull any model with: `ollama pull <model>`

## Structure

```
ccplugin-opencode-bridge/
  .claude-plugin/
    plugin.json                  # Plugin manifest
  commands/
    opencode.md                  # OpenCode management command
  skills/
    opencode-bridge/
      SKILL.md                   # Auto-trigger routing
  install.sh                     # Shell alias installer
  README.md
```

## Documentation

- [OpenCode](https://opencode.ai/)
- [Zen Models & Pricing](https://open-code.ai/docs/en/zen)
- [OpenCode Providers](https://open-code.ai/docs/en/providers)
- [Ollama](https://ollama.ai/)

## License

MIT

## Part of

- [claude-config](https://github.com/SkyWalker2506/claude-config) — Multi-Agent OS for Claude Code (110 agents, local-first routing)
- [Plugin Marketplace](https://github.com/SkyWalker2506/claude-marketplace) — Browse & install all 14 plugins
