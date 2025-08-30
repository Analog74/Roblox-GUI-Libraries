# Workflows

## Update External Libraries
```
./scripts/pull_external.sh
```
Commits only the curated subset under `src/ReplicatedStorage/External`.

## Add New Framework Panel
1. Create `DesignLab/Demos/MyPanel.lua` (strict Luau).
2. Require dependencies defensively (`pcall`).
3. Register: `Registry.register("MyFramework", require(script.Demos.MyPanel), {category="framework"})` (or inline in `init.lua`).
4. Rebuild via top bar or rerun mount.

## Add Theme Variant
1. Edit `Theme/Manager.lua` → add entry in `variants` table with same color keys.
2. Toggle to test; ensure text contrast > 4.5:1 (manual check or add future contrast util).

## Measure Performance
- Open benchmark panel; note mount/update timings.
- For deeper analysis, attach micro-probes: wrap panel factory body with `os.clock()` or `debug.profilebegin`.

## TypeScript Panel
1. `npm install`
2. Add file under `rbxts/src/SomePanel.ts`
3. `npm run build`
4. Require/auto-detect (DesignLab already tries `TS/DesignLabTsPanel`).

## Plugin Docking
Use `PluginLab/PluginEntryTemplate.lua` snippet in a plugin project; mount DesignLab inside DockWidget.

## Wally Dependency Change
1. Edit `wally.toml`
2. Run `wally install`
3. Commit updated `wally.lock`.
