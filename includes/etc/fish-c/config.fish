set -U fish_greeting
set -U FZF_COMPLETE 1

if type -q micro
    set -x EDITOR micro
    set -x VISUAL micro
end
