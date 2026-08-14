# ── Zinit bootstrap ──────────────────────────────────────────────────────────
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME/.git" ]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

# ── Plugins ───────────────────────────────────────────────────────────────────
zinit light zsh-users/zsh-completions   # adds completions to fpath (must be before compinit)

# Useful OMZ snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo        # press Escape twice to prefix last cmd with sudo

# ── Completions ───────────────────────────────────────────────────────────────
autoload -Uz compinit
compinit

zinit cdreplay -q   # replay completions cached by zinit

# These must load AFTER compinit
zinit light Aloxaf/fzf-tab                        # fzf-tab hijacks completion menu
zinit light zsh-users/zsh-autosuggestions         # autosuggestions wraps zle widgets
zinit light zdharma-continuum/fast-syntax-highlighting

# ── History ───────────────────────────────────────────────────────────────────
HISTSIZE=10000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space      # lines starting with space are not saved
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# ── Keybindings ───────────────────────────────────────────────────────────────
bindkey -v                               # vim mode
bindkey -M vicmd 'k' history-beginning-search-backward
bindkey -M vicmd 'j' history-beginning-search-forward
bindkey '^[[A' history-beginning-search-backward # Up arrow — prefix search
bindkey '^[[B' history-beginning-search-forward  # Down arrow — prefix search

# ── Completion styling ────────────────────────────────────────────────────────
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'   # case-insensitive
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no                             # let fzf-tab handle menu

# fzf-tab: preview directories with eza (falls back to ls)
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath 2>/dev/null || ls -1 --color=always $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -1 --color=always $realpath 2>/dev/null || ls -1 --color=always $realpath'

# ── Functions ─────────────────────────────────────────────────────────────────

# Fuzzy-find and attach to a tmux session
tms() {
  local session
  session=$(tmux ls 2>/dev/null | fzf | cut -d: -f1) && tmux attach -t "$session"
}

# Create a new plain tmux session
stat() {
  local name=${1:?Usage: stat <session-name>}
  tmux new-session -s "$name"
}

# Create a new tmux session with claude on top, terminal on bottom
tmc() {
  local name=${1:?Usage: tmc <session-name>}
  tmux new-session -d -s "$name" \; \
    send-keys "claude" Enter \; \
    split-window -v \; \
    attach-session -t "$name"
}

# ── Aliases ───────────────────────────────────────────────────────────────────
alias ls='ls --color'
alias la='ls -la'
alias ll='ls -l'
alias vim='nvim'
alias vi='nvim'
alias c='clear'

# ── Shell integrations ────────────────────────────────────────────────────────

# fzf — fuzzy finder (Ctrl+R history, Ctrl+T files, Alt+C cd)
if command -v fzf &>/dev/null; then
  eval "$(fzf --zsh)"
fi

# zoxide — smarter cd with frecency tracking
# `z foo` jumps to best match; `zi foo` opens interactive fzf picker
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init --cmd cd zsh)"
fi

# ── SSH Agent ────────────────────────────────────────────────────────────────
if [ -z "$SSH_AUTH_SOCK" ]; then
  eval "$(ssh-agent -s)" > /dev/null
  ssh-add ~/.ssh/id_ed25519_github 2>/dev/null
fi

# ── Prompt (Starship) ─────────────────────────────────────────────────────────
if command -v starship &>/dev/null; then
  eval "$(starship init zsh)"
fi

# Created by `pipx` on 2026-03-26 22:33:13
export PATH="$PATH:/Users/zachcristol/.local/bin"
export PATH="$HOME/Library/Python/3.11/bin:$PATH"
export OLLAMA_API_BASE=http://localhost:11434
