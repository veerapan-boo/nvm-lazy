# --- Fast default Node (without loading nvm.sh) ---
export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"

# 1) Prefer project's .nvmrc in $PWD (if present)
_nvm_project_ver=""
[ -r "$PWD/.nvmrc" ] && _nvm_project_ver="$(cat "$PWD/.nvmrc")"

# 2) Otherwise fall back to alias/default, then ~/.nvmrc
_nvm_default_ver=""
[ -z "$_nvm_project_ver" ] && [ -r "$NVM_DIR/alias/default" ] && _nvm_default_ver="$(cat "$NVM_DIR/alias/default")"
[ -z "$_nvm_project_ver$_nvm_default_ver" ] && [ -r "$HOME/.nvmrc" ] && _nvm_default_ver="$(cat "$HOME/.nvmrc")"

# 3) Resolve and prepend PATH (project wins)
_nvm_used_startup=""
if [ -n "$_nvm_project_ver" ]; then
  _v="$_nvm_project_ver"
  # allow "20" or "20.12" by expanding to highest installed v20* / v20.12*
  _glob="$([[ "$_v" == v* ]] && printf '%s' "$_v" || printf 'v%s*' "$_v")"
  _resolved="$(printf '%s\n' "$NVM_DIR/versions/node/"$_glob"" 2>/dev/null \
    | awk -F'/node/' 'NF>1{print $2}' | sort -V | tail -n1)"
  if [ -n "$_resolved" ] && [ -d "$NVM_DIR/versions/node/$_resolved/bin" ]; then
    export PATH="$NVM_DIR/versions/node/$_resolved/bin:$PATH"
    _nvm_used_startup=1
  fi
fi

# 4) Fallback to global default if project didn't resolve
if [ -z "$_nvm_used_startup" ] && [ -n "$_nvm_default_ver" ]; then
  if [[ "$_nvm_default_ver" == v* ]] && [ -d "$NVM_DIR/versions/node/$_nvm_default_ver/bin" ]; then
    export PATH="$NVM_DIR/versions/node/$_nvm_default_ver/bin:$PATH"
  fi
fi

unset _nvm_project_ver _nvm_default_ver _nvm_used_startup _resolved _glob _v

# --- Lazy-load nvm; load only when calling `nvm` ---
nvm() {
  unset -f nvm
  if [ -s "$NVM_DIR/nvm.sh" ]; then
    . "$NVM_DIR/nvm.sh"
  else
    print -u2 "nvm: cannot find $NVM_DIR/nvm.sh (NVM_DIR=$NVM_DIR)"
    return 127
  fi

  # Copy the real nvm function, then wrap it to persist whenever "current" changes
  if typeset -f nvm >/dev/null; then
    functions -c nvm __nvm_real
    nvm() {
      # current before
      local _before
      _before="$(__nvm_real current 2>/dev/null || true)"

      # run real nvm
      __nvm_real "$@"
      local _status=$?

      # current after
      local _after
      _after="$(__nvm_real current 2>/dev/null || true)"

      # if changed to a resolvable vX.Y.Z, persist to ~/.nvmrc and alias/default
      if [ "$_status" -eq 0 ] && [ -n "$_after" ] && [ "$_after" != "$_before" ] && [[ "$_after" == v* ]]; then
        print -r -- "$_after" > "$HOME/.nvmrc"
        mkdir -p "$NVM_DIR/alias"
        print -r -- "$_after" > "$NVM_DIR/alias/default"
      fi

      return $_status
    }
  fi

  # Run the original command that triggered this function
  nvm "$@"
}

# Shortcut: manually apply project's .nvmrc when you want
alias nvmrc='[ -f .nvmrc ] && nvm use "$(cat .nvmrc)"'
