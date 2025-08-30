#!/usr/bin/env node
// Simple prebuild check ensuring @rbxts/types is installed so editors don't flood errors
const fs = require('fs');
const path = require('path');

const root = process.cwd();
// Modern @rbxts/types layout has 'include' directory not 'types/globals.d.ts'
const typesPath = path.join(root, 'node_modules', '@rbxts', 'types', 'include', 'roblox.d.ts');

if (!fs.existsSync(typesPath)) {
  console.error('\n[roblox-ts] Missing or unexpected layout for @rbxts/types. Run: npm install\n');
  process.exit(1);
}
console.log('[roblox-ts] Types located.');
