# Dotfiles

Personal machine setup for a fresh Mac. Clone this repo and follow the steps below.

## Prerequisites

```bash
# Install Xcode CLI tools (required for git, compilers)
xcode-select --install

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## 1. Clone this repo

The symlinks in this repo use relative paths that assume it lives at `~/Dotfiles`. Clone it there exactly:

```bash
git clone git@github.com:zachcristol/Dotfiles.git ~/Dotfiles
```

## 2. Install packages

```bash
cd ~/Dotfiles
brew bundle install
```

This installs everything in the `Brewfile` — CLI tools, apps, and fonts.

## 3. Set up symlinks

Symlinks wire config files from this repo into the places macOS/apps expect them.

Already wired (created manually, record them here if you redo them):

```bash
ln -sf ~/Dotfiles/.zshrc ~/.zshrc
ln -sf ~/Dotfiles/.config/alacritty ~/.config/alacritty
```

Still to be added to repo and wired:

```bash
# Neovim
cp -r ~/.config/nvim ~/Dotfiles/.config/nvim   # first time only - move it in
ln -sf ~/Dotfiles/.config/nvim ~/.config/nvim

# Starship
cp ~/.config/starship.toml ~/Dotfiles/.config/starship.toml
ln -sf ~/Dotfiles/.config/starship.toml ~/.config/starship.toml
```

## 4. Shell setup

Zinit (zsh plugin manager) installs itself automatically on first shell launch - no action needed.

```bash
# Reload shell
source ~/.zshrc
```

## 5. Manual steps

These can't be scripted easily - do them by hand:

- **SSH keys** - generate a new key and add to GitHub: `ssh-keygen -t ed25519 -C "your@email.com"`
- **1Password** - install from App Store, sign in
- **OpenSuperWhisper** - set trigger key to right Command (hold to record, release to transcribe)
- **Ghostty** - set as default terminal
- **LinearMouse** - configure sensitivity preferences
- **Tailscale** - sign in to your account
- **gh auth** - authenticate GitHub CLI: `gh auth login`

## What's in this repo

| File | Destination | Status |
|---|---|---|
| `.zshrc` | `~/.zshrc` | tracked + symlinked |
| `.config/alacritty/` | `~/.config/alacritty/` | tracked + symlinked |
| `.config/nvim/` | `~/.config/nvim/` | **not yet added** |
| `.config/starship.toml` | `~/.config/starship.toml` | **not yet added** |
| `Brewfile` | run from `~/Dotfiles/` | tracked |

## Keeping it up to date

When you install a new app or tool, add it to the `Brewfile` and commit:

```bash
brew bundle dump --force   # regenerates Brewfile from current state
git add Brewfile && git commit -m "add <package>"
git push
```
