# External Libraries

## Strategy
- Full clone → `vendor/` (ignored by Argon)
- Curated subset → `src/ReplicatedStorage/External/<Lib>`

## Script
`./scripts/pull_external.sh` handles shallow clone & copy.

## Adding A New Library
1. Append clone block to script.
2. List curated folders for copy.
3. Run script; verify directories.
4. Create minimal `README.md` inside curated folder summarizing subset.

## Avoid
- Copying test suites unless needed.
- Syncing entire large libraries (keeps Studio fast).
