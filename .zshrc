export HISTSIZE=10000
export SAVEHIST=10000
export EDITOR="nvim"
export XDG_CONFIG_HOME="$HOME/.config"
export PATH="$PATH:/usr/local/bin"

# difftastic
export DFT_PARSE_ERROR_LIMIT=20

export ELIXIR_ERL_OPTIONS="-kernel shell_history enabled"

if [[ -f "/opt/homebrew/bin/brew" ]]; then
	eval "$(/opt/homebrew/bin/brew shellenv)"
else
	eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

alias ls='ls --color=auto'
alias grep='grep --color=auto'

alias zed-editor='open -a "Zed Preview"'

setopt histignorealldups

autoload -Uz promptinit
promptinit

autoload -Uz compinit
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
	compinit -u;
else
	compinit -C;
fi;

eval "$(direnv hook zsh)"
eval "$(mise activate zsh)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

if [[ -f "$HOME/.claude/local/claude" ]]; then
	alias claude="$HOME/.claude/local/claude"
fi
