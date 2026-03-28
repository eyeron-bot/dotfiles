# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a **personal dotfiles repository** — the central configuration repo for macOS machine setup. It manages shell config, tmux, Homebrew packages, SSH, and key backup/restore via three tools:

- **GNU Stow** — symlinks files from `dot/` into `$HOME` (e.g., `dot/.zshrc` → `~/.zshrc`)
- **Strap** — bootstraps a fresh macOS machine (security, Xcode CLI, Homebrew, then runs `script/setup`)
- **Ansible Vault** — encrypts/decrypts SSH and GPG keys for portable backup

## Key Commands

```bash
# Bootstrap (runs stow, brew bundle, oh-my-zsh, zsh plugins, TPM)
./script/setup

# Backup keys to encrypted vault
ansible-playbook ansible/backup-keys.yml --vault-password-file .vault_password

# Restore keys from encrypted vault
ansible-playbook ansible/restore-keys.yml --vault-password-file .vault_password

# Update Brewfile from currently installed packages
brew bundle dump --file=~/.dotfiles/dot/.Brewfile --force
```

## Architecture

### Stow convention

All files under `dot/` mirror `$HOME`. When `stow dot/ --dir=~/.dotfiles --target=$HOME` runs, each file gets symlinked to its corresponding home path. To add a new dotfile, place it at `dot/<path-relative-to-home>`.

### Directory layout

- `dot/` — stow package (everything here becomes a symlink in `$HOME`)
- `script/setup` — idempotent bootstrap: stow → brew bundle → oh-my-zsh + plugins → TPM
- `script/strap-after-setup` — post-Strap hook that restores keys if `.vault_password` exists
- `ansible/` — playbooks for key backup/restore using ansible-vault; secrets go in `ansible/vars/secrets.yml` (encrypted, gitignored pattern via `.vault_password`)

### Custom tmux scripts (`dot/.local/bin/`)

- `tmux-sessionizer` — fzf-based session picker across `~/`, `~/src`, `~/playground`, `~/Desktop`; `-c` flag creates a "code" layout with a second AI window
- `tmux-split-layout` — creates a 3-pane layout: main editor (top-left 80×80%), Claude CLI (right 20%), terminal (bottom-left 20%)
- `tmux-resize-panes` — resets the 3-pane split-layout to its default proportions, or tiles if layout doesn't match

## Working in This Repo

- **Never edit `dot/.Brewfile` directly.** To add a package: `brew install <pkg>` then `brew bundle dump --file=~/.dotfiles/dot/.Brewfile --force` to regenerate it.
- After editing any file in `dot/`, re-run `stow dot/ --dir=~/.dotfiles --target=$HOME` to update symlinks (or just run `./script/setup`).
- The `.vault_password` file is gitignored — never commit it.
- Shell scripts in `dot/.local/bin/` must be executable (`chmod +x`).
