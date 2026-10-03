#!/usr/bin/env bash
set -euo pipefail

echo "============================================="
echo "       LazyVim Configuration Installer       "
echo "============================================="
echo ""

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"

# 1. Check prerequisites
echo "[1/4] Checking prerequisites..."
MISSING_TOOLS=()

for cmd in nvim git rg; do
  if command -v "$cmd" >/dev/null 2>&1; then
    echo "  [+] Found $cmd"
  else
    echo "  [-] Missing $cmd"
    MISSING_TOOLS+=("$cmd")
  fi
done

if [ ${#MISSING_TOOLS[@]} -gt 0 ]; then
  echo ""
  echo "WARNING: The following recommended tools are missing: ${MISSING_TOOLS[*]}"
  echo "Please install them via your package manager (e.g., brew, apt, pacman, dnf)."
  echo ""
fi

# 2. Check target path and backup if needed
echo "[2/4] Verifying destination directory..."
echo "  Target: $TARGET"
echo "  Source: $SCRIPT_DIR"

ALREADY_LINKED=false

if [ -L "$TARGET" ]; then
  RESOLVED_TARGET="$(readlink -f "$TARGET" 2>/dev/null || readlink "$TARGET" 2>/dev/null || true)"
  if [ "$RESOLVED_TARGET" = "$SCRIPT_DIR" ]; then
    echo "  [OK] Destination is already linked to this repository."
    ALREADY_LINKED=true
  fi
fi

if [ "$ALREADY_LINKED" = false ] && { [ -e "$TARGET" ] || [ -L "$TARGET" ]; }; then
  TIMESTAMP="$(date +%Y%m%d%H%M%S)"
  BACKUP="${TARGET}.bak.${TIMESTAMP}"
  echo "  Existing configuration detected. Backing up to:"
  echo "  $BACKUP"
  mv "$TARGET" "$BACKUP"
  echo "  Backup created successfully."
fi

# 3. Create symlink
echo "[3/4] Linking configuration..."
if [ "$ALREADY_LINKED" = true ]; then
  echo "  Symlink already exists, skipping."
else
  mkdir -p "$(dirname "$TARGET")"
  ln -sf "$SCRIPT_DIR" "$TARGET"
  echo "  [OK] Created symlink: $TARGET -> $SCRIPT_DIR"
fi

# 4. Finish
echo ""
echo "[4/4] Installation complete!"
echo ""
echo "Run 'nvim' to initialize LazyVim and automatic plugin downloads."
