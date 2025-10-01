#!/usr/bin/env bash
set -euo pipefail

TARGET_DIR="$HOME/.config/zsh"
TARGET_FILE="$TARGET_DIR/nvm-lazy.zsh"
ZSHRC="${ZDOTDIR:-$HOME}/.zshrc"

MARK_START="# >>> nvm-lazy start >>>"
MARK_END="# <<< nvm-lazy end <<<"

echo "[nvm-lazy] Installing..."

# ensure target dir
mkdir -p "$TARGET_DIR"

# download nvm-lazy.zsh from GitHub
curl -fsSL https://raw.githubusercontent.com/veerapan-boo/nvm-lazy/main/nvm-lazy.zsh -o "$TARGET_FILE"

# backup .zshrc
if [[ -f "$ZSHRC" ]]; then
  cp "$ZSHRC" "$ZSHRC.bak.$(date +%Y%m%d%H%M%S)"
fi

# remove old block if exists
if grep -q "$MARK_START" "$ZSHRC" 2>/dev/null; then
  awk -v s="$MARK_START" -v e="$MARK_END" '
    $0 ~ s {skip=1}
    !skip {print}
    $0 ~ e {skip=0}
  ' "$ZSHRC" > "$ZSHRC.tmp"
  mv "$ZSHRC.tmp" "$ZSHRC"
fi

# append new block with $HOME (escaped so it stays in .zshrc)
{
  echo ""
  echo "$MARK_START"
  echo "if [ -r \"\$HOME/.config/zsh/nvm-lazy.zsh\" ]; then"
  echo "  source \"\$HOME/.config/zsh/nvm-lazy.zsh\""
  echo "fi"
  echo "$MARK_END"
  echo ""
} >> "$ZSHRC"

echo "[nvm-lazy] Installed successfully!"
echo "[nvm-lazy] Run: source \"$ZSHRC\""
