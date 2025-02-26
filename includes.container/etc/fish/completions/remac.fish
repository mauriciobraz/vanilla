function __fish_remac_complete
    ip -o link show | awk -F': ' '{print $2}'
end

complete -c remac -a "(__fish_remac_complete)" -d "Network interface"
