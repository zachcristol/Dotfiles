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
ln -sf ~/Dotfiles/.config/nvim ~/.config/nvim
ln -sf ~/Dotfiles/.config/starship.toml ~/.config/starship.toml
ln -sf ~/Dotfiles/.tmux.conf ~/.tmux.conf
ln -sf ~/Dotfiles/.config/ghostty ~/Library/Application\ Support/com.mitchellh.ghostty/config
ln -sf ~/Dotfiles/.config/agent.md ~/.claude/CLAUDE.md
ln -sf ~/Dotfiles/.gitconfig ~/.gitconfig
ln -sf ~/Dotfiles/.agents/skills/no-mistakes ~/.claude/skills/no-mistakes
ln -sf ~/Dotfiles/.agents/skills/lavish ~/.claude/skills/lavish
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

## 7. Agentic stack

Tools for working with AI agents. All by [Kun Chen (kunchenguid)](https://github.com/kunchenguid).

### No Mistakes — automated code review + PR pipeline

```bash
curl -fsSL https://raw.githubusercontent.com/kunchenguid/no-mistakes/main/docs/install.sh | sh
```

Then run `no-mistakes init` once inside each git repo you want to use it with (sets up the local gate).
The `/no-mistakes` Claude skill is already tracked in this repo and wired via the symlink step above.

### Treehouse — parallel agent worktrees

```bash
curl -fsSL https://kunchenguid.github.io/treehouse/install.sh | sh
```

Usage: `treehouse` drops you into an isolated git worktree. `exit` returns it to the pool.
Run multiple Claude instances in parallel without them conflicting.

### Lavish — visual HTML planning artifacts

```bash
npx skills add kunchenguid/lavish-axi --skill lavish
```

Installs as a Claude Code skill. Tell Claude to "plan with lavish" — it generates an HTML
artifact that opens in the browser for annotating and making decisions visually.

### Good Night Have Fun — overnight autonomous loops

```bash
# Install (from ~/Developer/gnhf after cloning)
git clone https://github.com/kunchenguid/gnhf.git ~/Developer/gnhf
cd ~/Developer/gnhf
pnpm setup         # adds pnpm to PATH in .zshrc
source ~/.zshrc
COREPACK_INTEGRITY_KEYS=0 pnpm add --global .
```

Usage: `gnhf "your objective"` — runs Claude in a loop until the objective is met.
Good for: overnight test coverage improvements, performance work, UI polish passes.

> Note: `COREPACK_INTEGRITY_KEYS=0` is needed due to a corepack keyring issue with pnpm@11 on this Node version.

### First Mate — orchestrator meta-agent

```bash
git clone https://github.com/kunchenguid/firstmate.git ~/Developer/firstmate
cd ~/Developer/firstmate
# Run your agent harness from inside this directory
# First launch detects missing tools and tells you exactly what to install
```

First Mate manages parallel tmux sessions, calls Treehouse for worktrees, launches agents
per task, runs No Mistakes on each, and reports status. Talk to it in high-level terms.

## 8. Manual steps

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
| `.config/ghostty` | `~/Library/Application Support/com.mitchellh.ghostty/config` | tracked + symlinked |
| `.tmux.conf` | `~/.tmux.conf` | tracked + symlinked |
| `.config/agent.md` | `~/.claude/CLAUDE.md` | tracked + symlinked |
| `.gitconfig` | `~/.gitconfig` | tracked + symlinked |
| `.agents/skills/no-mistakes/` | `~/.claude/skills/no-mistakes/` | tracked + symlinked |
| `.agents/skills/lavish/` | `~/.claude/skills/lavish/` | tracked + symlinked |
| `Brewfile` | run from `~/Dotfiles/` | tracked |

## Keeping it up to date

When you install a new app or tool, add it to the `Brewfile` and commit:

```bash
brew bundle dump --force   # regenerates Brewfile from current state
git add Brewfile && git commit -m "add <package>"
git push
```
