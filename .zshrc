export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="fletcherm"

plugins=(git)

source $ZSH/oh-my-zsh.sh

# ── History ──────────────────────────────────────────────────────────────────
HISTFILE=~/.local/share/zsh/history
HISTSIZE=10000
SAVEHIST=10000
setopt EXTENDED_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

# ── Options ──────────────────────────────────────────────────────────────────
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt EXTENDED_GLOB

# ── Completion ───────────────────────────────────────────────────────────────
autoload -Uz compinit && compinit

# NVM
export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

export MOZ_ENABLE_WAYLAND=1

# Plugins
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Keybinds
bindkey '^e' autosuggest-accept
bindkey '^k' up-line-or-search
bindkey '^j' down-line-or-search

# Yazi
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# Git
alias gc="git commit -m"
alias gca="git commit -a -m"
alias gp="git push origin HEAD"
alias gpu="git pull origin"
alias gst="git status"
alias gco="git checkout"
alias gb='git branch'
alias ga='git add -p'
alias gadd='git add'
alias gdiff="git diff"
alias glog="git log --graph --pretty='%C(yellow)%h %C(cyan)%ar %C(green)%an%n%C(white)%s' --abbrev-commit"
alias gre='git reset'

# Навигация
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias cl='clear'

# fzf
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow'
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
fcd() { cd "$(find . -type d -not -path '*/.*' | fzf)" && l; }
fv() { nvim "$(find . -type f -not -path '*/.*' | fzf)"; }

# Zoxide (smatr cd)
eval "$(zoxide init zsh)"

# Atuin (smart history)
eval "$(atuin init zsh)"

eval "$(starship init zsh)"
export STARSHIP_CONFIG=~/.config/starship/themes/current.toml
