# SPRINT PLAN — ccplugin-opencode-bridge

**Date:** 2026-04-22  
**Based on:** MASTER_ANALYSIS.md  
**Forge Runs:** 3 × 3 sprints

---

## Sprint 1 — Executable Scripts & Bug Fixes

**Goal:** Replace LLM-dependent logic with real scripts; fix install.sh bug.

| Task | Description | Effort |
|------|-------------|--------|
| S1-T1 | Fix `install.sh`: remove `OPENCODE_MODEL` env var from aliases (it doesn't work) — use `opencode --model` flag or config instead | Quick |
| S1-T2 | Create `scripts/opencode-status.sh` — check CLI installed, Ollama running, config exists, show summary | Medium |
| S1-T3 | Create `scripts/opencode-config.sh` — read/write `~/.config/opencode/opencode.json` safely | Medium |
| S1-T4 | Add `set -euo pipefail` to `install.sh` + better error messages | Quick |
| S1-T5 | Add uninstall function to `install.sh` (`--uninstall` flag removes aliases from rc) | Quick |

---

## Sprint 2 — Config & Model Management

**Goal:** Make model/config management reliable and user-friendly.

| Task | Description | Effort |
|------|-------------|--------|
| S2-T1 | Create `models.json` — static list of Zen free models + popular Ollama models with metadata | Quick |
| S2-T2 | Add `scripts/opencode-models.sh` — reads models.json + runs `ollama list`, outputs combined table | Quick |
| S2-T3 | Create default `config/opencode-template.json` — reference config shipped with plugin | Quick |
| S2-T4 | Update `install.sh` to copy template to `~/.config/opencode/opencode.json` if missing | Quick |
| S2-T5 | Add `scripts/opencode-health.sh` — ping Zen API + check Ollama serve + verify config valid | Medium |

---

## Sprint 3 — Command Spec Trim & Reliability

**Goal:** Reduce command spec complexity; add version pinning.

| Task | Description | Effort |
|------|-------------|--------|
| S3-T1 | Split `commands/opencode.md` into smaller files: `opencode-zen.md`, `opencode-local.md`, `opencode-models.md` | Medium |
| S3-T2 | Update main `opencode.md` to delegate to subcommand files | Quick |
| S3-T3 | Add minimum version check in `opencode-status.sh` (`opencode --version` >= required) | Quick |
| S3-T4 | Reduce SKILL.md trigger set — remove overly broad triggers like individual model names | Quick |
| S3-T5 | Update README with corrected alias behavior and config file location | Quick |

---

## Task Priority Matrix

| Priority | Tasks |
|----------|-------|
| P0 (Critical) | S1-T1, S1-T2 |
| P1 (High) | S1-T3, S1-T4, S1-T5, S2-T3, S2-T4 |
| P2 (Medium) | S2-T1, S2-T2, S2-T5, S3-T4, S3-T5 |
| P3 (Low) | S3-T1, S3-T2, S3-T3 |

---

## Skip Criteria (>2hr tasks)

- S3-T1 (split command spec) could be done in 30-45min. All tasks within limit.
