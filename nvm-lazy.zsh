# --- Fast default Node (without loading nvm.sh) ---
export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"

# Read the default version from alias (if exists), otherwise from ~/.nvmrc
_nvm_default_ver=""
[ -r "$NVM_DIR/alias/default" ] && _nvm_default_ver="$(cat "$NVM_DIR/alias/default")"
[ -z "$_nvm_default_ver" ] && [ -r "$HOME/.nvmrc" ] && _nvm_default_ver="$(cat "$HOME/.nvmrc")"

# If version looks like vX.Y.Z and exists, prepend its bin directory to PATH
if [[ "$_nvm_default_ver" == v* ]] && [ -d "$NVM_DIR/versions/node/$_nvm_default_ver/bin" ]; then
  export PATH="$NVM_DIR/versions/node/$_nvm_default_ver/bin:$PATH"
fi
unset _nvm_default_ver

# --- Lazy-load nvm; load only when calling `nvm` ---
nvm() {
  unset -f nvm
  if [ -s "$NVM_DIR/nvm.sh" ]; then
    . "$NVM_DIR/nvm.sh"
  else
    print -u2 "nvm: cannot find $NVM_DIR/nvm.sh (NVM_DIR=$NVM_DIR)"
    return 127
  fi

  # Copy the real nvm function, then wrap it to auto-save version changes
  if typeset -f nvm >/dev/null; then
    functions -c nvm __nvm_real
    nvm() {
      if [[ "$1" == "use" && -n "$2" ]]; then
        # Switch version
        if __nvm_real use "$2"; then
          # Get the resolved version after switching (e.g. v20.12.2)
          local _resolved
          _resolved="$(__nvm_real current)"

          # Save it to both ~/.nvmrc and alias/default
          if [[ "$_resolved" == v* ]]; then
            print -r -- "$_resolved" > "$HOME/.nvmrc"
            mkdir -p "$NVM_DIR/alias"
            print -r -- "$_resolved" > "$NVM_DIR/alias/default"
          fi
          unset _resolved
        fi
      else
        __nvm_real "$@"
      fi
    }
  fi

  # Run the original command that triggered this function
  nvm "$@"
}

# Shortcut: manually apply project's .nvmrc when you want
alias nvmrc='[ -f .nvmrc ] && nvm use "$(cat .nvmrc)"'
