# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="fletcherm"
plugins=(git)
source $ZSH/oh-my-zsh.sh

# History
HISTFILE=~/.local/share/zsh/history
HISTSIZE=10000
SAVEHIST=10000
setopt EXTENDED_HISTORY INC_APPEND_HISTORY SHARE_HISTORY

# Options
setopt AUTO_CD AUTO_PUSHD PUSHD_IGNORE_DUPS EXTENDED_GLOB
autoload -Uz compinit && compinit

# Wayland
export MOZ_ENABLE_WAYLAND=1

# Plugins
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Keybinds
bindkey '^e' autosuggest-accept
bindkey '^k' up-line-or-search
bindkey '^j' down-line-or-search

# Yazi (cd with preview)
y() {
  local tmp=$(mktemp -t "yazi-cwd.XXXXXX")
  yazi "$@" --cwd-file="$tmp"
  local cwd=$(cat -- "$tmp")
  [[ -n "$cwd" && "$cwd" != "$PWD" ]] && cd -- "$cwd"
  rm -f -- "$tmp"
}

# Git
alias gc="git commit -m"
alias gca="git commit -a -m"
alias gp="git push origin HEAD"
alias gpu="git pull origin"
alias gst="git status"
alias gco="git checkout"
alias gb="git branch"
alias ga="git add -p"
alias gadd="git add"
alias gdiff="git diff"
alias glog="git log --graph --pretty='%C(yellow)%h %C(cyan)%ar %C(green)%an%n%C(white)%s' --abbrev-commit"
alias gre="git reset"

# Navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias cl="clear"

# fzf
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow'
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
fcd() { cd "$(find . -type d -not -path '*/.*' | fzf)"; }
fv() { nvim "$(find . -type f -not -path '*/.*' | fzf)"; }

# Tools
eval "$(zoxide init zsh)"
eval "$(atuin init zsh)"
eval "$(starship init zsh)"
export STARSHIP_CONFIG=~/.config/starship/themes/current.toml

# NVM (optional)
export NVM_DIR="$HOME/.config/nvm"
[[ -s "$NVM_DIR/nvm.sh" ]] && . "$NVM_DIR/nvm.sh"
