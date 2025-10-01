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
