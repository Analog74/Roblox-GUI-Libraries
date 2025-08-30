# GuiLibraries Aggregation

## (New) Rojo Design System / Storybook
An incremental reboot is underway using Rojo + a lightweight in-house DesignSystem for rapid plugin GUI & menu prototyping.

New files:
- `design.project.json` – run `rojo serve design.project.json` to live preview stories in Play mode.
- `plugin.project.json` – build a plugin rbxm: `rojo build plugin.project.json -o DesignPlugin.rbxm`.
- `src/ReplicatedStorage/DesignSystem` – tokens, primitive components, story registry & sample stories.
- `StorybookLoader.client.lua` – auto-mounts a simple storybook in a local test session.
- `plugin/init.server.lua` – opens a DockWidget hosting the same stories inside Studio.

Quick start (storybook):
```sh
rojo serve design.project.json
```
In Studio, connect to the served project; press Play to open the Storybook GUI.

Quick start (plugin build):
```sh
rojo build plugin.project.json -o DesignPlugin.rbxm
```
Install the produced `DesignPlugin.rbxm` into Studio to browse stories via a DockWidget.

The legacy aggregation/DesignLab code remains for reference; migrate panels into `DesignSystem/Stories` over time.

This project aggregates multiple Roblox UI and framework libraries (Wally + curated manual extracts) for building Studio-styled plugins and game tooling using Argon (Rojo not used).

## Included / Planned Libraries

| Name | Purpose | Source / Install | Status |
|------|---------|------------------|--------|
| StudioComponents (Nevermore UI packages) | Pre-built Studio-like components | NevermoreEngine (manual clone subset) | Planned extraction |
| Fusion | Reactive UI | Wally: `elttob/fusion@^0.3.0` | Added (wally) |
| Roact | Declarative UI | Wally: `roblox/roact@^1.4.4` | Added (wally) |
| Aegis | Strict typed UI | Wally: `lumin/aegis@^0.1.0` | Added (wally) |
| Rbx Gui Library | Classic components | Script curated copy | Scripted (pending first pull) |
| Nevermore Engine | Utilities (Maid, Rx, Spring) | Script curated subset | Scripted (pending first pull) |
| Screen3D | 3D UI layer | Script curated copy | Scripted (pending first pull) |
| Rex | Reactive UI | Script curated copy | Scripted (pending first pull) |
| Knit | Service framework | Wally: `sleitnick/knit@^1.7.0` | Added (wally) |
| Aero Game Framework | Alt service framework | Script curated subset | Scripted (pending first pull) |
| Valkyrie | Modular framework | Manual (if repo located) | Planned |
| Cmdr | Command console | Wally: `evaera/cmdr@^1.9.0` | Added (wally server-dependency) |
| Wally | Package manager | Tool | Installed locally |
| Rojo | Sync tool | Tool | Installed locally |
| roblox-ts | TypeScript to Luau | Tool | Installed globally |

## Usage (Argon)
1. Install dependencies
   ```sh
   wally install
   ```
2. Start Argon live sync (example):
   ```sh
   argon serve
   ```
3. In Studio, packages appear under `ReplicatedStorage/Packages`.
4. Open `DesignLab` UI (auto-mounts via server loader) to view cross-framework demo panels.

## Adding / Updating External Libraries (Automated Curation)
Large upstream repos are shallow-cloned into `vendor/` (ignored by Argon) and curated subsets copied into `src/ReplicatedStorage/External/<LibName>` via `scripts/pull_external.sh`.

### Run curation script
```sh
chmod +x scripts/pull_external.sh
scripts/pull_external.sh
```
This performs:
1. Shallow clone/update NevermoreEngine, Rbx-Gui-Library, Screen3D, Rex, AeroGameFramework
2. Copy selected Nevermore packages: Maid, Rx, Spring, ValueObject, Signal
3. Copy full component sets for Rbx-Gui-Library (into `RbxGui/Components`)
4. Copy Screen3D core, Rex core, Aero core subset
5. Leave Valkyrie placeholder until a repo is confirmed

Adjust the script to refine or reduce copied modules as the design lab evolves.

## DesignLab
`ReplicatedStorage/DesignLab` contains:
- `Theme` shared token set (colors, radius, padding)
- Demo panels for Fusion, Roact, Aegis, Rex, Benchmark, StudioComponents (placeholder)
- Bootstrap `init.lua` and a server loader script to mount panels in each player's `PlayerGui` for rapid comparison.

### TypeScript (roblox-ts) Integration
Added optional roblox-ts toolchain:
- `package.json`, `tsconfig.json`
- Source in `rbxts/src`, compiled output to `src/ReplicatedStorage/TS`
- Sample `DesignLabTsPanel.ts` auto-detected by DesignLab (loaded if built)

Build steps:
1. Install Node deps: `npm install`
2. Compile once: `npm run build` (or watch: `npm run watch`)
3. Run Argon; the compiled Lua module appears under `ReplicatedStorage/TS/DesignLabTsPanel`.

If the TypeScript panel isn't visible, ensure you've built and Argon has synced the `src/` tree.

## Advanced DesignLab Architecture
New modules added:
- `DesignLab/Registry.lua` central panel registration (supports categories & tags)
- `DesignLab/TopBar.lua` runtime controls (theme cycle, rebuild)
- `DesignLab/Metrics.lua` lightweight FPS & memory overlay
- `DesignLab/Theme/Manager.lua` dynamic light/dark/high_contrast variants
- `PluginLab/PluginEntryTemplate.lua` template snippet for DockWidget integration

### Theme Variants
Call `require(DesignLab.Theme.Manager).nextVariant()` to cycle dark -> light -> high_contrast. Panels using token colors update in-place. High contrast variant boosts accessibility with stronger separation & yellow accents.

### Search & Performance Badges
Use the search bar under the top bar to live-filter panels by name. Each panel now displays its mount time (ms) in a small badge (coarse measurement using `os.clock`). Extendable to include update metrics.

### Adding Panels
```lua
local Registry = require(ReplicatedStorage.DesignLab.Registry)
Registry.register("MyPanel", function(parent)
   -- build UI under parent
end, { category = "experiment", tags = {"internal"} })
```
Press Rebuild in the top bar (or call the rebuild function you hold) to refresh.

### Metrics
Simple overlay shows approximate FPS (Heartbeat averaged per second) and Lua memory (collectgarbage count). Extend to include specific framework mount timings as needed.

### Plugin Usage
Use the template in `PluginLab/PluginEntryTemplate.lua` inside a real plugin context to host DesignLab inside a dock widget for rapid iteration on plugin UI patterns.


Extend by adding new demo modules in `DesignLab/Demos` following existing patterns.

### TypeScript Theme Tokens Generation
Run `npm run gen-theme` to emit a `rbxts/src/ThemeTokens.generated.ts` file mirroring the current dark variant tokens for TS-side consumption (manual sync for now; update the generator as variants evolve).

## Argon Ignore
`.argonignore` excludes `vendor/` and markdown files to reduce sync overhead.

## TypeScript (roblox-ts)
To add TS support later:
```sh
npm init -y
npm install --save-dev roblox-ts @rbxts/types
npx rbxtsc --init
```
Emit compiled TS to a folder Argon maps (e.g., `out/`); add that path in Argon config if needed.

## License
Each third-party library retains its original license. This meta-project is private.

### License Attribution Automation
Run `npm run gen-notice` to regenerate `AUTO_NOTICE.md` (machine-derived summary of library sources & detected license types, scanning vendor/ and Packages/). Edit `NOTICE.md` manually for curated explanations; do not hand-edit `AUTO_NOTICE.md`.

### Theme Variants (DesignSystem)
Cycle variants (dark, light, high_contrast) via the Theme button in Storybook sidebar or plugin toolbar row. Components pull colors from mutable `Tokens.colors` updated in-place by `DesignSystem/Theme.lua`.
