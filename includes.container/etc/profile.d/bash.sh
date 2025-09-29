if command -v atuin &> /dev/null; then
	if [ -n "$BASH_VERSION" ]; then
		eval "$(atuin init bash)"
	elif [ -n "$ZSH_VERSION" ]; then
		eval "$(atuin init zsh)"
	fi
fi

if command -v starship &> /dev/null; then
	if [ -n "$BASH_VERSION" ]; then
		eval "$(starship init bash)"
	elif [ -n "$ZSH_VERSION" ]; then
		eval "$(starship init zsh)"
	fi
fi

if command -v fzf &> /dev/null; then
	if [[ -f /usr/share/fzf/completion.bash ]]; then
		source /usr/share/fzf/completion.bash
	fi

	if [[ -f /usr/share/fzf/key-bindings.bash ]]; then
		source /usr/share/fzf/key-bindings.bash
	fi
fi

# shortcuts

alias ~='cd ~'
alias -='cd -'

alias cp='cp -i'
alias ln='ln -i'
alias mv='mv -i'
alias rm='rm -i'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# lazygit / lazydocker

alias lg='lazygit'
alias ld='lazydocker'

# bat

alias c='bat --style=plain'
alias cat='bat --style=auto'
alias batl='bat --style=numbers'

# dust

alias du='dust'

alias dud='dust -d 3'
alias dun='dust -n 20'

alias dur='dust -r'
alias dus='dust -s'
alias dux='dust -x'

# eza

alias tree='eza --tree'

alias lt='eza --tree --color=auto --icons'
alias ltr='eza --tree --color=auto --icons -L'
alias lta='eza --tree -a --color=auto --icons'

alias ls='eza --color=auto --group-directories-first --icons'
alias lS='eza -1 --color=auto --group-directories-first --icons'

alias la='eza -a --color=auto --group-directories-first --icons'
alias ll='eza -la --color=auto --group-directories-first --icons --header --git'

# git

alias g='git'

alias ga='git add'
alias gaa='git add .'
alias gap='git add -p'

alias gb='git branch'
alias gba='git branch -a'
alias gbd='git branch -d'

alias gco='git checkout'
alias gcb='git checkout -b'

alias gc='git commit -m'
alias gca='git commit --amend'
alias gcad='git commit -a --amend'
alias gcam='git commit -a -m'

alias gl='git log --oneline --graph --decorate -20'
alias gla='git log --oneline --graph --decorate --all -20'
alias gll='git log --graph --pretty=format:"%C(yellow)%h%Creset -%C(red)%d%Creset %s %C(green)(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'

alias gp='git push'
alias gpo='git push origin'
alias gpu='git push -u origin'

export GIT_PAGER='delta'

# procs

alias ps='procs'

alias pst='procs --tree'

alias psg='procs --grep'
alias psp='procs --pager'
alias psw='procs --watch'

alias psk='procs --sortd cpu'
alias psm='procs --sortd memory'

alias psu='procs --user $(whoami)'

# television

alias tv='television'

alias tvg='television git'
alias tvh='television help'
alias tvf='television files'
alias tvr='television recent'
alias tvp='television preview'

# trash-cli

alias rm='trash-put'
alias rmdir='trash-put'
alias empty='trash-empty'
alias restore='trash-restore'

# others

alias sd='sd'
alias rg='rg --hidden --glob !.git --glob !node_modules --glob !venv --glob !.venv --glob !__pycache__ --glob !*.pyc --glob !*.pyo --glob !*.pyd'

export EDITOR='micro'
export VISUAL='micro'

export LESS='-R -i -w -M -z-4'
