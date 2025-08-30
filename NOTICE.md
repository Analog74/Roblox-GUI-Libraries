# NOTICE

This repository aggregates and curates multiple third-party Roblox libraries and frameworks for the purpose of building and comparing GUI / Plugin UI patterns. Each third‑party library retains its original license. This NOTICE centralizes attribution only; consult each upstream project for full license terms.

## Aggregated Libraries

| Library | Upstream URL | License (indicative) | Notes |
|---------|--------------|----------------------|-------|
| Fusion | https://github.com/Elttob/Fusion | MIT | Pulled via Wally (elttob/fusion) |
| Roact | https://github.com/Roblox/roact | MIT | Pulled via Wally (roblox/roact) |
| Aegis | https://github.com/lumin-dev/aegis | MIT | Pulled via Wally (lumin/aegis) |
| Knit | https://github.com/Sleitnick/Knit | MIT | Wally (sleitnick/knit) |
| Cmdr | https://github.com/evaera/Cmdr | MIT | Wally (evaera/cmdr) |
| Rex | https://github.com/boatbomber/Rex | MIT | Curated subset (Core) copied into External |
| Nevermore Engine | https://github.com/Quenty/NevermoreEngine | MIT | Curated subset (Maid, Rx, Spring, ValueObject, Signal) |
| Rbx Gui Library | https://github.com/csqrl/Rbx-Gui-Library | MIT | Curated components subset |
| Screen3D | https://github.com/Fraktality/Screen3D | MIT | Core modules only |
| Aero Game Framework | https://github.com/Sleitnick/AeroGameFramework | MIT | Selected Shared utilities |
| Valkyrie (planned) | https://github.com/Thomas-Smyth/Valkyrie | MIT | Not yet integrated |
| roblox-ts (tool) | https://github.com/roblox-ts/roblox-ts | MIT | Toolchain only (integration experimental) |

If any license differs from MIT, update this table accordingly.

## Local Paths

- `Packages/` – Wally-installed packages (generated; do not edit).
- `vendor/` – Shallow clones (ignored by sync) used as sources for curated copies.
- `src/ReplicatedStorage/External/` – Curated minimal subsets copied from `vendor/`.
- `src/ReplicatedStorage/DesignSystem/` – In-house design system (original work in this repo).
- `DesignLab` directories – Legacy comparative panels (original work / glue code).

## How to Refresh Curated Subsets
Run the curation script (if present) or manually copy needed modules from `vendor/<Lib>` into `src/ReplicatedStorage/External/<LibName>` preserving original headers/license notices where available.

## Contributing
When adding a new external library:
1. Add it to this table (name, URL, license).
2. Include any LICENSE file or header from upstream in the copied subset if required.
3. Keep changes minimal; avoid editing third‑party code except for namespace paths.

## Disclaimer
This repository is a meta-aggregation for internal / exploratory purposes. It is not an official distribution of the listed third‑party libraries.
