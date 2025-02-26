function option --description 'Get the value of an option by key'
    getopts $argv | while read -l key value
        test $key = _; and set filters $filters $value
    end

    getopts $argv | while read -l key value
        contains $key $filters; and echo $value
    end
end
