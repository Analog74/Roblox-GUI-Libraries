# Architecture

## Layers
1. Dependency Layer
   - `wally.toml` packages resolved into `Packages/`
   - `vendor/` full git clones (ignored by Argon) + curated copies to `src/ReplicatedStorage/External`
2. DesignLab Layer
   - `DesignLab/init.lua` orchestrates UI
   - Registry (`Registry.lua`) registers factories
   - Theme system (`Theme/init.lua`, `Theme/Manager.lua`)
   - Panels under `DesignLab/Demos`
3. Instrumentation
   - `BenchmarkPanel.lua` micro timings
   - `Metrics.lua` runtime FPS & memory overlay
4. Optional TS
   - `rbxts/src` compiled to `src/ReplicatedStorage/TS`

## Data Flow
- Panels depend on Theme tokens (mutable color table updated by Theme Manager).
- Registry holds metadata; TopBar triggers rebuild or theme toggle; rebuild enumerates registry → invokes factories.

## Sync Strategy
- Argon uses `default.project.json` mapping; `.argonignore` excludes `vendor/`.
- External updates: script pulls & copies only required directories.

## Extensibility Points
- Add panel categories (e.g., `animation`, `inputs`).
- Insert new metrics modules (register additional overlays).
- Provide plugin docking via `PluginLab` template.
