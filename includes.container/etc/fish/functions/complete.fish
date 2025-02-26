function autocomplete --description 'Generate completions for a command'
    set exec (option $argv E exec)
    set name (option $argv N name)

    if not test -f $fish_completions_dir/$name.fish
        eval $exec >$fish_completions_dir/$name.fish
    end
end
