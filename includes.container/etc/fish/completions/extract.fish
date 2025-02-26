function __fish_extract_complete
    for file in (ls)
        if test -f $file
            switch $file
                case "*.tar" "*.tar.bz2" "*.tbz2" "*.tar.gz" "*.tgz" "*.bz" "*.bz2" "*.gz" "*.rar" "*.zip" "*.Z" "*.pax" "*.7z"
                    echo $file
            end
        end
    end
end

complete -c extract -a "(__fish_extract_complete)"
