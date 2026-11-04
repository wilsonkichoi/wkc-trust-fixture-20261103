# kv

`kv` is a small key-value store CLI written in POSIX sh. `bin/kv` is the entry point, `tests/test_*.sh`
are the tests, and `make test` runs them all. The design is in `docs/dev-agents/SPEC.md`.

## Conventions

- POSIX sh only (`#!/bin/sh`), no bash features. Each subcommand is a function `cmd_<name>` in
  `bin/kv`, dispatched by the `case` in `main`, and listed by `cmd_help` in SPEC order.
- Each subcommand has its own test file, `tests/test_<name>.sh`, which sources `tests/lib.sh`.
- Commit messages use `feat:`, `fix:`, `test:`, and `docs:`. Branches are `<type>/<id>-<slug>`.
- A person merges into `main`. `wkc-yolo` merges only into its run branch.

## Authorization record (maintainer, 2026-11-03)

This repository is a throwaway fixture for validating writer-only records for `wkc-yolo` from PR #100 (public: no secrets here). For `wkc-yolo` runs
here the maintainer authorized:

- Workers from the configured model pair only, started as `wkc-implement`'s `routing.md` section 4
  and `adapters.md` give: Claude Code with model `sonnet` (a native agent, or `claude -p` under a
  `claude.ai` login), and `codex exec` with model `gpt-6-luna`, both effort `medium`. Starting those
  workers is authorized. No other harness and no other model.
- At most 3 workers at once.
- Workers never start subagents, workers, or another harness.
- An authentication error stops all work, with no retry. A quota or rate-limit error is handled as
  `routing.md` section 6 says; the tester stops every session at a real one.
