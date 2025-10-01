# nvm-lazy

[![Shell](https://img.shields.io/badge/shell-zsh-green.svg)](https://www.zsh.org/)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Status](https://img.shields.io/badge/status-stable-success.svg)]()

🚀 Lazy load [`nvm`](https://github.com/nvm-sh/nvm) in **zsh** + remember the last `nvm use` version across terminal sessions.  
Fast startup + persistent Node.js version management.

---

## ✨ Features

- ⚡ **Fast startup** — no `nvm.sh` loaded at shell init  
- 💾 **Persistent version** — remembers the last `nvm use <ver>`  
- 🔄 **Auto save** — writes resolved version to `~/.nvmrc` and `~/.nvm/alias/default`  
- 📂 **Project support** — optional `nvmrc` alias to load a project's `.nvmrc` manually  

---

## 📦 Installation / Uninstallation

### Install
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/veerapan-boo/nvm-lazy/main/install.sh)"
```

Reload your shell:
```bash
source ~/.zshrc
```

### Uninstall
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/veerapan-boo/nvm-lazy/main/uninstall.sh)"
```

Reload again:
```bash
source ~/.zshrc
```

---

## 🛠 Usage

- **Switch Node.js version and auto-save**:
  ```bash
  nvm use 20
  ```
  → Automatically saves `v20.x.x` to `~/.nvmrc` and `~/.nvm/alias/default`

- **Check Node version in a new terminal**:
  ```bash
  node -v
  ```
  → Instantly uses the saved default without loading `nvm.sh`

- **Apply a project’s `.nvmrc` manually**:
  ```bash
  nvmrc
  ```

---

## 📂 File Structure

```
nvm-lazy/
├─ nvm-lazy.zsh     # main script
├─ install.sh       # installation script
├─ uninstall.sh     # uninstallation script
└─ README.md        # this file
```

---

## 📄 License

MIT © [Veerapan Boonbuth](https://github.com/veerapan-boo)
