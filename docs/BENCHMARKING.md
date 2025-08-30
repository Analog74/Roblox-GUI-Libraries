# Benchmarking

## Existing
`BenchmarkPanel.lua` measures:
- Mount time (os.clock delta + debug.profile scopes)
- 25 reactive updates

## Interpreting
Times are milliseconds; variability expected (GC, frame scheduling). Compare relative, not absolute.

## Extending
Add framework-specific suite:
```lua
local function benchMyFramework()
  local mountMs = time("myfw_mount", function() ... end)
  local updateMs = time("myfw_updates", function() for i=1,25 do ... end end)
end
```
Insert into panel & output formatted line.

## Cautions
- Keep iteration counts small to avoid UI hitching.
- Avoid measuring first frame after large GC (multiple samples recommended).
