set -U fish_greeting
set -U FZF_COMPLETE 1

if status is-interactive
    if command -v micro > /dev/null 2>&1
        set -x EDITOR micro
        set -x VISUAL micro
    end

    if command -v atuin > /dev/null 2>&1
        atuin init fish | source
    end

    if command -v starship > /dev/null 2>&1
        starship init fish | source
    end

end

alias . 'cd .'

alias .1 'cd ..'
alias .. 'cd ..'

alias .2 'cd ../..'
alias ... 'cd ../..'

alias .3 'cd ../../..'
alias .... 'cd ../../..'

alias .4 'cd ../../../..'
alias ..... 'cd ../../../..'

alias lg 'lazygit'
alias ld 'lazydocker'

if command -v delta > /dev/null 2>&1
    set -x GIT_PAGER delta
end

alias du 'dust'
alias ps 'procs'

alias cat 'bat --style=auto'

alias ls 'eza --color=auto --icons --group-directories-first'
alias ll 'eza -la --color=auto --icons --group-directories-first'

alias tree 'eza --tree --color=auto --icons --group-directories-first'
