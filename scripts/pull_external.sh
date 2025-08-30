#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VENDOR_DIR="$ROOT_DIR/vendor"
EXT_DIR="$ROOT_DIR/src/ReplicatedStorage/External"

mkdir -p "$VENDOR_DIR" "$EXT_DIR"

clone_or_update() {
  local repo_url="$1"
  local target_dir="$2"
  if [ -d "$target_dir/.git" ]; then
    echo "[update] $target_dir"
    git -C "$target_dir" fetch --depth 1 origin main || git -C "$target_dir" fetch --depth 1 origin master || true
    git -C "$target_dir" reset --hard FETCH_HEAD || true
  else
    echo "[clone] $repo_url -> $target_dir"
    git clone --depth 1 "$repo_url" "$target_dir"
  fi
}

# Source repos (full, in vendor)
clone_or_update https://github.com/Quenty/NevermoreEngine.git "$VENDOR_DIR/NevermoreEngine"
clone_or_update https://github.com/EgoMoose/Rbx-Gui-Library.git "$VENDOR_DIR/Rbx-Gui-Library" || true
clone_or_update https://github.com/CatGuyMoment/Screen3D.git "$VENDOR_DIR/Screen3D" || true
clone_or_update https://github.com/OMouta/Rex.git "$VENDOR_DIR/Rex" || true
clone_or_update https://github.com/Sleitnick/AeroGameFramework.git "$VENDOR_DIR/AeroGameFramework" || true
# Valkyrie repo unknown -> skip placeholder

# Helper: copy a folder if exists
copy_if() {
  local src="$1"
  local dest="$2"
  if [ -d "$src" ]; then
    rm -rf "$dest"
    mkdir -p "$(dirname "$dest")"
    cp -R "$src" "$dest"
    echo "[copy] $(basename "$src") -> $dest"
  else
    echo "[skip] missing $src"
  fi
}

# Curate Nevermore subset
NEVER_SRC="$VENDOR_DIR/NevermoreEngine/src"
NEVER_DEST="$EXT_DIR/Nevermore"
mkdir -p "$NEVER_DEST"
copy_if "$NEVER_SRC/maid" "$NEVER_DEST/Maid"
copy_if "$NEVER_SRC/rx" "$NEVER_DEST/Rx"
copy_if "$NEVER_SRC/spring" "$NEVER_DEST/Spring"
copy_if "$NEVER_SRC/valueobject" "$NEVER_DEST/ValueObject"
copy_if "$NEVER_SRC/signal" "$NEVER_DEST/Signal"

# Rbx Gui Library components (grab full for now; user can trim)
RBXGUI_SRC="$VENDOR_DIR/Rbx-Gui-Library/src"
if [ -d "$RBXGUI_SRC" ]; then
  rm -rf "$EXT_DIR/RbxGui/Components"
  mkdir -p "$EXT_DIR/RbxGui"
  cp -R "$RBXGUI_SRC" "$EXT_DIR/RbxGui/Components"
  echo "[copy] Rbx-Gui-Library components"
fi

# Screen3D minimal (assume src folder root)
SCREEN3D_SRC="$VENDOR_DIR/Screen3D/src"
if [ -d "$SCREEN3D_SRC" ]; then
  rm -rf "$EXT_DIR/Screen3D/Core"
  mkdir -p "$EXT_DIR/Screen3D"
  cp -R "$SCREEN3D_SRC" "$EXT_DIR/Screen3D/Core"
  echo "[copy] Screen3D core"
fi

# Rex core
REX_SRC="$VENDOR_DIR/Rex/src"
if [ -d "$REX_SRC" ]; then
  rm -rf "$EXT_DIR/Rex/Core"
  mkdir -p "$EXT_DIR/Rex"
  cp -R "$REX_SRC" "$EXT_DIR/Rex/Core"
  echo "[copy] Rex core"
fi

# Aero subset: copy Shared utilities from ReplicatedStorage/Aero/Shared
AERO_SRC_RS="$VENDOR_DIR/AeroGameFramework/src/ReplicatedStorage/Aero/Shared"
if [ -d "$AERO_SRC_RS" ]; then
  rm -rf "$EXT_DIR/Aero/Core"
  mkdir -p "$EXT_DIR/Aero/Core"
  cp -R "$AERO_SRC_RS" "$EXT_DIR/Aero/Core/Shared"
  echo "[copy] Aero shared utilities"
fi

echo "Done. Review curated External/ directories."
