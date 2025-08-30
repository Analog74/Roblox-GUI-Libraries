# Theming

## Tokens
Defined in `Theme/init.lua` under `tokens` (colors, spacing, radius, font).

## Variants
Managed by `Theme/Manager.lua` (light/dark). Toggle via top bar or:
```lua
local ThemeManager = require(ReplicatedStorage.DesignLab.Theme.Manager)
ThemeManager.setVariant("light")
```
Changes mutate token color table so existing UI with references updates automatically.

## Adding New Tokens
Add field to `Theme.tokens` then integrate in panels; keep variant tables in sync.
