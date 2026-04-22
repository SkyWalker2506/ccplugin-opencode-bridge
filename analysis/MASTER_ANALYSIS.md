# MASTER ANALYSIS — ccplugin-opencode-bridge

**Date:** 2026-04-22  
**Forge Run:** 1 of 3  
**Analyst:** Jarvis | Sonnet 4.6

---

## 1. Project Overview

`ccplugin-opencode-bridge` bridges Claude Code with OpenCode CLI, providing access to free Zen cloud models (gpt-5-nano, minimax, GLM, kimi, big-pickle) and local Ollama models. Used when Claude quota runs out or local/free inference is needed.

---

## 2. Current Architecture

```
commands/opencode.md    — Full command spec (status/zen/local/models/pull/config/install)
skills/opencode-bridge/SKILL.md — Auto-trigger routing skill
install.sh              — Adds claude-free and claude-local shell aliases
```

**No executable scripts** — all logic is in command spec (LLM-executed) and install.sh.

---

## 3. Strengths

- Comprehensive command spec — all subcommands clearly defined with expected behavior
- Auto-trigger skill is well-designed with broad trigger patterns
- install.sh is clean, idempotent (checks for existing marker), multi-shell compatible
- Good documentation with model tables, aliases, setup steps

---

## 4. Weaknesses & Gaps

### Critical
1. **No actual scripts** — the entire `/opencode` implementation relies on the LLM interpreting the command spec. There's no `opencode.sh` that actually executes status checks, config writes, etc. This means reliability depends entirely on the LLM doing the right thing.
2. **Config template missing** — command spec references `~/Projects/claude-config/templates/opencode.json` but this file may not exist in all setups
3. **OPENCODE_MODEL env var not the actual OpenCode API** — `install.sh` sets `OPENCODE_MODEL=opencode/gpt-5-nano` as env var but OpenCode CLI doesn't use this env var for model selection — the actual config is in `opencode.json`

### Medium
4. **Model list is stale** — "gpt-5-nano", "big-pickle", "kimi-k2.5-free" may have changed/been renamed in Zen. No dynamic model discovery.
5. **`/opencode pull` subcommand** — when pulling, the command spec says to update opencode.json but there's no script to do it — LLM would need to edit JSON directly
6. **skills/SKILL.md triggers on "gpt-5-nano"** — if user mentions model name in unrelated context, could false-trigger
7. **No uninstall procedure** — install.sh adds aliases but provides no way to remove them
8. **Zen API key instructions may be outdated** — references `https://opencode.ai/auth` which may have changed

### Low
9. **No version pinning** — `npm install -g opencode-ai` installs latest, may break with API changes
10. **No health check** — no way to test if Zen connection is live
11. **commands/opencode.md** is 200+ lines — very long for a command spec, may hit context limits

---

## 5. Opportunities

| Opportunity | Category | Priority | Effort |
|-------------|----------|----------|--------|
| Add `opencode-status.sh` script for actual CLI status checks | Feature | High | Medium |
| Fix install.sh: use opencode.json config, not OPENCODE_MODEL env | Bug Fix | High | Quick |
| Add `opencode-config.sh` to write/read opencode.json | Feature | High | Medium |
| Add model list as a static JSON (with refresh command) | Feature | Medium | Quick |
| Add uninstall function to install.sh | UX | Medium | Quick |
| Add Zen connectivity health check script | Feature | Medium | Quick |
| Trim opencode.md — split into subcommand files | Refactor | Low | Medium |
| Add `--version` check and pin minimum opencode-ai version | Reliability | Low | Quick |

---

## 6. Dependency Analysis

- **Depends on:** `opencode-ai` npm package, Ollama (optional), Zen API key (optional)
- **Used by:** Claude Code users when quota exhausted or local inference needed
- **Template dependency:** `~/Projects/claude-config/templates/opencode.json` (may not exist)

---

## 7. Risk Assessment

- **Medium risk** — relies on LLM interpretation for core functionality
- If opencode-ai API changes, all subcommands silently break
- Zen model list going stale is a UX issue but not critical
- install.sh env var bug may cause confusion but non-breaking

---

## 8. Recommended Sprint Focus

**Sprint 1:** Fix install.sh env var bug + add opencode-status.sh script  
**Sprint 2:** Add opencode-config.sh + uninstall support + health check  
**Sprint 3:** Static model list JSON + trim command spec
