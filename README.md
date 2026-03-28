# eyeron dotfiles

Personal dotfiles managed with [Strap](https://github.com/MikeMcQuaid/strap), [GNU Stow](https://www.gnu.org/software/stow/), and [Ansible](https://www.ansible.com/).

## Quick Start (New Machine)

1. Go to [strap.mikemcquaid.com](https://strap.mikemcquaid.com)
2. Sign in with your GitHub account
3. Download the generated `strap.sh`
4. Run it:

```bash
bash ~/Downloads/strap.sh
```

Strap will automatically:
- Harden macOS security settings
- Install Xcode CLI tools
- Install Homebrew
- Clone this repo to `~/.dotfiles`
- Run `script/setup` (installs packages, oh-my-zsh, plugins, stows dotfiles)
- Run `brew bundle --global` with the stowed `~/.Brewfile`
- Run `script/strap-after-setup` (restores keys from ansible vault if available)

## Manual Setup (Existing Machine)

```bash
git clone https://github.com/eyeron/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./script/setup
```

## What's Included

| Component | Description |
|-----------|-------------|
| `dot/.Brewfile` | Homebrew packages, casks, and dependencies |
| `dot/.zshrc` | Zsh config with oh-my-zsh, autosuggestions, and syntax highlighting |
| `dot/.tmux.conf` | Tmux config with vim keybindings, mouse support, and plugins |
| `dot/.ssh/config` | SSH config with keychain integration |
| `dot/.local/bin/` | Custom scripts (tmux-sessionizer, tmux-split-layout, etc.) |

## Managing Keys with Ansible Vault

### Initial Setup

Create a vault password (keep this safe, do not commit it):

```bash
echo "your-secure-password" > ~/.dotfiles/.vault_password
```

### Backup Keys

```bash
cd ~/.dotfiles
ansible-playbook ansible/backup-keys.yml --vault-password-file .vault_password
```

This encrypts your SSH and GPG keys into `ansible/vars/secrets.yml`.

### Restore Keys (on a new machine)

```bash
cd ~/.dotfiles
echo "your-secure-password" > .vault_password
ansible-playbook ansible/restore-keys.yml --vault-password-file .vault_password
```

### Generate GPG Key (first time)

```bash
gpg --full-generate-key
```

Then backup the new key with the ansible playbook above.

## Updating the Brewfile

```bash
brew bundle dump --file=~/.dotfiles/dot/.Brewfile --force
```

## Tmux

After setup, open tmux and install plugins:

```bash
tmux
# Press prefix (Ctrl-b) + I to install plugins
```

Key bindings:
- `prefix + v` — vertical split
- `prefix + b` — horizontal split
- `prefix + h/j/k/l` — vim-style pane navigation
- `prefix + C-h/C-j/C-k/C-l` — pane resizing
- `prefix + C-i` — split layout (main + claude + terminal)
- `prefix + =` — resize panes to default proportions
