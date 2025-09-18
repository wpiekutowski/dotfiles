export HISTSIZE=1000000000
export SAVEHIST=1000000000
export EDITOR="nvim"
export XDG_CONFIG_HOME="$HOME/.config"

export ELIXIR_ERL_OPTIONS="-kernel shell_history enabled"

eval "$(/opt/homebrew/bin/brew shellenv)"

autoload -Uz compinit
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
	compinit -u;
else
	compinit -C;
fi;

alias git-dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

eval "$(direnv hook zsh)"
eval "$(mise activate zsh)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
