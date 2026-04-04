---
name: opencode-bridge
description: "Auto-trigger for OpenCode, Zen cloud models, Ollama local models, and free/open-source LLM requests. Routes to /opencode command."
user-invocable: false
---

# OpenCode Bridge -- Auto-Trigger Skill

This skill detects when the user mentions OpenCode, Zen, Ollama, local models, or free/open-source LLMs and routes to the `/opencode` command.

## Trigger Patterns

| Pattern | Routes to |
|---------|-----------|
| "opencode", "open code", "OpenCode" | `/opencode` (status) |
| "zen", "zen cloud", "zen models", "zen free" | `/opencode zen` |
| "ollama", "local model", "run locally", "local llm" | `/opencode local` |
| "free model", "free llm", "kota bitti", "quota exhausted", "no quota" | `/opencode zen` |
| "switch to local", "go local", "offline model" | `/opencode local` |
| "open source llm", "open-source model", "oss model" | `/opencode models` |
| "qwen", "qwen coder", "qwen2.5" | `/opencode local` |
| "gemma", "gemma3", "gemma 3" | `/opencode local` |
| "pull model", "download model", "ollama pull" | `/opencode pull` |
| "opencode config", "opencode setup" | `/opencode config` |
| "install opencode", "setup opencode" | `/opencode install` |
| "claude-free", "claude-local" | `/opencode` (explain aliases) |
| "gpt-5-nano", "minimax-m2.1", "glm-4.7", "kimi-k2.5", "big-pickle" | `/opencode zen` |

## Routing Rules

1. Match user message against trigger patterns above
2. If a clear match is found, invoke the corresponding `/opencode` subcommand
3. If the user mentions quota exhaustion or wanting free alternatives, route to `/opencode zen`
4. If the user asks about running models locally or offline, route to `/opencode local`
5. If ambiguous, ask:

```
I detected an OpenCode/local model request. What would you like to do?
  1) /opencode zen    -- Connect to Zen cloud (free models like gpt-5-nano)
  2) /opencode local  -- Switch to Ollama (local models like qwen, gemma)
  3) /opencode models -- List all available models
  4) /opencode pull   -- Pull a new Ollama model
  5) /opencode        -- Show current setup status
```

6. If the user explicitly names a command (e.g., "/opencode local"), go directly without asking

## Context

- **Zen (cloud):** Free cloud models via OpenCode's Zen service -- no local GPU needed
- **Ollama (local):** Fully local, no API key, requires Ollama installed + model pulled
- **Config:** `~/.config/opencode/opencode.json` manages both providers
- **Template:** `~/Projects/claude-config/templates/opencode.json` is the source of truth
- **Docs:** [Zen](https://open-code.ai/docs/en/zen), [Providers](https://open-code.ai/docs/en/providers)
