#!/usr/bin/env bash
set -euo pipefail

TARGET_DIR="${HOME}/.config/zsh"
TARGET_FILE="${TARGET_DIR}/nvm-lazy.zsh"
ZSHRC="${ZDOTDIR:-$HOME}/.zshrc"

MARK_START="# >>> nvm-lazy start >>>"
MARK_END="# <<< nvm-lazy end <<<"

if [[ -f "$ZSHRC" ]] && grep -q "$MARK_START" "$ZSHRC"; then
  awk -v s="$MARK_START" -v e="$MARK_END" '
    $0 ~ s {skip=1}
    !skip {print}
    $0 ~ e {skip=0}
  ' "$ZSHRC" > "$ZSHRC.tmp"
  mv "$ZSHRC.tmp" "$ZSHRC"
  echo "[nvm-lazy] Removed block from $ZSHRC"
fi

if [[ -f "$TARGET_FILE" ]]; then
  rm -f "$TARGET_FILE"
  rmdir "$TARGET_DIR" 2>/dev/null || true
  echo "[nvm-lazy] Removed $TARGET_FILE"
fi

echo "[nvm-lazy] Uninstalled. Run: source \"$ZSHRC\""
