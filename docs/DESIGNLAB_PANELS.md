# Panels Guide

## Panel Contract
```lua
(type) PanelFactory = function(parent: Instance) -> Instance?
```
Return root instance (or nil on failure). Avoid side-effects beyond UI creation.

## Best Practices
- Use `UIListLayout` / `UIGridLayout` for internal arrangement.
- Defer heavy logic with `task.defer` after creation.
- Use theme tokens; listen to theme changes only if dynamic recolor needed.
- Match cross-framework parity: similar interactions for fair comparison.

## Categories
- `framework`: primary framework examples
- `metrics`: instrumentation/benchmarking
- Add custom via `category="yourCategory"`.
