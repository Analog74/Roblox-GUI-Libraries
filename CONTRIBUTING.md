# Contributing Guide

## Principles
- Keep Argon sync fast: only curated subsets in `src/ReplicatedStorage/External`; full clones live in `vendor/`.
- Prefer small, composable panels in DesignLab; each should mount quickly (<5ms target) and avoid global side-effects.
- Maintain strict Luau (`--!strict`) for all new source files.
- Keep documentation updated when adding/removing frameworks or workflows.

## Workflow Summary
1. Add / update external libs via `scripts/pull_external.sh` (never commit large unused folders).
2. Run `wally install` when changing `wally.toml`.
3. Create a panel: register through `DesignLab/Registry.lua` (category + optional tags).
4. Update docs if introducing new categories, themes, or benchmarks.
5. Open a PR with clear summary + before/after notes.

## Code Style (Luau)
- File header: `--!strict`.
- Use descriptive local names; avoid single letter except short loops.
- Avoid cyclic requires (use dependency inversion via registries).
- Guard optional dependencies with `pcall`.

## Panels
- Return an `Instance` (root) or `nil` on failure.
- No yielding in top level; use `task.spawn` for async.
- Use theme tokens; never hardcode colors except transient debug output.

## Theme
- To add a variant: extend table in `Theme/Manager.lua` and keep color keys consistent.

## Benchmarks
- Keep micro-bench loops small (≤100 iterations) to prevent frame hitching.
- Label with `debug.profilebegin/end`.

<!-- TypeScript section removed -->

## Commit Message Hints
`feat(panel): add Fusion form panel`
`perf(benchmark): add mount timing for Roact`
`docs(theme): document high-contrast variant`

---
Happy building!
