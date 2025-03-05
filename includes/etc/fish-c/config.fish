set -U fish_greeting
set -U FZF_COMPLETE 1

if type -q micro
    set -x EDITOR micro
    set -x VISUAL micro
end

if type -q vso
    if not test -e /etc/fish/completions/vso.fish
        vso completion fish > /etc/fish/completions/vso.fish
    end
end

if type -q abroot
    if not test -e /etc/fish/completions/abroot.fish
        abroot completion fish > /etc/fish/completions/abroot.fish
    end
end
