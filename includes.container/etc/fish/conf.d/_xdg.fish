# System
set -q XDG_CONFIG_DIRS; or set -x XDG_CONFIG_DIRS /etc/xdg
set -q XDG_DATA_DIRS; or set -x XDG_DATA_DIRS /usr/share /usr/local/share

# User
set -q XDG_STATE_HOME; or set -x XDG_STATE_HOME $HOME/.local/state
set -q XDG_DATA_HOME; or set -x XDG_DATA_HOME $HOME/.local/share

set -q XDG_CONFIG_HOME; or set -x XDG_CONFIG_HOME $HOME/.config
set -q XDG_CACHE_HOME; or set -x XDG_CACHE_HOME $HOME/.cache

set -q XDG_MUSIC_DIR; or set -x XDG_MUSIC_DIR $HOME/Music
set -q XDG_VIDEOS_DIR; or set -x XDG_VIDEOS_DIR $HOME/Videos
set -q XDG_DESKTOP_DIR; or set -x XDG_DESKTOP_DIR $HOME/Desktop

set -q XDG_PICTURES_DIR; or set -x XDG_PICTURES_DIR $HOME/Pictures
set -q XDG_DOWNLOAD_DIR; or set -x XDG_DOWNLOAD_DIR $HOME/Downloads
set -q XDG_DOCUMENTS_DIR; or set -x XDG_DOCUMENTS_DIR $HOME/Documents
