set -gx fish_config_dir $XDG_CONFIG_HOME/fish

set -gx fish_confd_path $fish_config_dir/conf.d
set -gx fish_setup_path $fish_functions_dir/setups
set -gx fish_aliases_path $fish_functions_dir/aliases

set -gx fish_functions_dir $fish_config_dir/functions
set -gx fish_completions_dir $fish_config_dir/completions

fish_add_path --append --move --path \
    $HOME/.spicetify $HOME/.local/bin $HOME/.local/sbin \
    /usr/bin /usr/local/bin /usr/local/sbin /usr/sbin /sbin /bin
