#######################################################
# load Square specific zshrc; please don't change this bit.
#######################################################
source ~/Development/config_files/square/zshrc
#######################################################

###########################################
# Feel free to make your own changes below.
###########################################

# uncomment to automatically `bundle exec` common ruby commands
# if [[ -f "$SQUARE_HOME/config_files/square/bundler-exec.sh" ]]; then
#   source $SQUARE_HOME/config_files/square/bundler-exec.sh
# fi

# load the aliases in config_files files (optional)
source ~/Development/config_files/square/aliases

[[ -f "$HOME/.aliases" ]] && source "$HOME/.aliases"
[[ -f "$HOME/.localaliases" ]] && source "$HOME/.localaliases"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Homebrew path
eval "$(/opt/homebrew/bin/brew shellenv)"


# Load completions
autoload -Uz compinit && compinit

# Set the directory we want to store zinit (plugin manager) and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Plugins
zinit light ohmyzsh/ohmyzsh
zinit ice depth=1; zinit light romkatv/powerlevel10k
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
# Add in snippets
zinit snippet OMZP::git
zinit snippet OMZP::docker

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Keybindings
# Vim mode
bindkey -v
bindkey -M vicmd 'k' history-search-backward
bindkey -M vicmd 'j' history-search-forward

# History
HISTSIZE=10000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'

# Alias
alias v='nvim'
alias vi'nvim'
alias vz="v ~/.zshrc"
alias sz="source ~/.zshrc"
alias tldrf='tldr --list | fzf --preview "tldr {1} --color=always" --preview-window=right,70% | xargs tldr'
alias lsi='ls -la | fzf | pbcopy'

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)" # Need cd because zinit conflicts with alias

# DSI Util Pods Login
util_pod_login() {
  local usage="Usage: util_pod_login [prod|staging] (default: prod)"
  if [ $# -gt 1 ]; then
    echo "$usage"
    return 1
  fi

  local current_user
  current_user=$(whoami)
  local env="${1:-prod}"
  local users=(
    "luluc:us-east-1"
    "ahsieh:us-west-2"
    "jingxuan:us-west-2"
    "tianyu:us-west-2"
    "haoliang:us-west-2"
    "tsaraiva:us-west-2"
    "tmukarakate:us-west-2"
    "ethanchang:us-west-2"
    "robb:us-west-2"
    "saman:us-east-1"
    "hamdan:us-east-1"
    "zcristol:us-west-2"
  )
  declare -i counter=0
  local user
  local prev_region
  for user in "${users[@]}" ; do
    local ldap="${user%%:*}"
    local region="${user##*:}"
    if [[ $region == "$prev_region" ]]; then
      counter+=1
    else
      counter=1
    fi
    prev_region=$region
    if [[ $current_user == "$ldap" ]]; then
      break
    fi
  done

  if [[ $counter -gt "${#users[@]}" ]]; then
    echo "Could not find your username $current_user in the login script. Did you add yourself?"
    return 1
  fi

  local context="ski-${env}-green-${region}-dsi-util"
  local pod
  pod=$(kubectl --context "$context" get pods | tail -n +2 | cut -f1 -d' ' | sort | sed "${counter}q;d")

  if [[ -z $pod ]]; then
    echo "Could not find your pod. Check if there are enough pods running."
    return 1
  fi

  echo "Logging into dsi-util-ops pod (env: $env, region: $region)"
  echo "Tips: run \`init\` after logged in"
  kubectl exec --context "$context" -it "$pod" -c dsi-util-ops  -- bash
}


# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
export NODE_EXTRA_CA_CERTS=/opt/homebrew/etc/ca-certificates/cert.pem
export COREPACK_NPM_REGISTRY=https://artifactory.global.square/artifactory/api/npm/square-npm/
export COREPACK_INTEGRITY_KEYS=0
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

