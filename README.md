# Dotfiles

Personal machine setup for a fresh Mac. Clone this repo and follow the steps below.

## Prerequisites

```bash
# Install Xcode CLI tools (required for git, compilers)
xcode-select --install

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## 1. SSH key for GitHub

Generate a key, add it to GitHub, then configure SSH to use it automatically.

```bash
# Generate key
ssh-keygen -t ed25519 -C "zachcristol@gmail.com" -f ~/.ssh/id_ed25519_github

# Start agent and load key
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519_github

# Copy public key - paste this into github.com/settings/keys → New SSH key
cat ~/.ssh/id_ed25519_github.pub
```

Create `~/.ssh/config`:

```
Host github.com
  IdentityFile ~/.ssh/id_ed25519_github
  AddKeysToAgent yes
```

Test it:

```bash
ssh -T git@github.com
# Should say: Hi zachcristol! You've successfully authenticated...
```

## 2. Clone this repo

```bash
git clone git@github.com:zachcristol/Dotfiles.git ~/Dotfiles
```

## 3. Install packages

```bash
cd ~/Dotfiles
brew bundle install
```

This installs everything in the `Brewfile` — CLI tools, apps, and fonts.

## 4. Set up symlinks

Run these to wire config files from this repo into the right places:

```bash
ln -sf ~/Dotfiles/.zshrc ~/.zshrc
ln -sf ~/Dotfiles/.config/alacritty ~/.config/alacritty
```

```bash
ln -sf ~/Dotfiles/.config/nvim ~/.config/nvim
ln -sf ~/Dotfiles/.config/starship.toml ~/.config/starship.toml
```

## 5. Shell setup

Reload the shell — Zinit installs itself automatically on first launch:

```bash
source ~/.zshrc
```

## 6. macOS settings

```bash
# Key repeat - as fast as possible (below UI minimum)
defaults write NSGlobalDomain KeyRepeat -int 1

# Delay until repeat - very short (below UI minimum)
defaults write NSGlobalDomain InitialKeyRepeat -float 8.5

# Three finger drag
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true
```

> Log out and back in to apply. The key repeat values are below what System Settings exposes so they won't show correctly in the UI slider — they are still active.

## 7. Manual steps

These can't be scripted — do them by hand:

- **gh auth** - authenticate GitHub CLI: `gh auth login`
- **OpenSuperWhisper** - set trigger key to right Command (hold to record, release to transcribe)
- **Ghostty** - set as default terminal
- **LinearMouse** - configure sensitivity preferences
- **Tailscale** - sign in to your account
- **Alfred** - license key needed; disable Spotlight (System Settings > Keyboard > Shortcuts > Spotlight) and set Alfred as replacement

### App Store only (no Homebrew cask)

- **Magnet** - window manager

## What's in this repo

| File | Destination | Status |
|---|---|---|
| `.zshrc` | `~/.zshrc` | tracked + symlinked |
| `.config/alacritty/` | `~/.config/alacritty/` | tracked + symlinked |
| `.config/nvim/` | `~/.config/nvim/` | tracked + symlinked |
| `.config/starship.toml` | `~/.config/starship.toml` | tracked + symlinked |
| `Brewfile` | run from `~/Dotfiles/` | tracked |

## Keeping it up to date

When you install a new app or tool, add it to the `Brewfile` and commit:

```bash
brew bundle dump --force   # regenerates Brewfile from current state
git add Brewfile && git commit -m "add <package>"
git push
```
