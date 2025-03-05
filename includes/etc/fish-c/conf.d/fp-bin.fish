set -gx flatpak_exports \
    "com.discordapp.Discord >> discord" \
    "com.github.alainm23.planner >> planner" \
    "com.github.maoschanz.drawing >> drawing" \
    "com.github.tchx84.Flatseal >> flatseal" \
    "com.google.Chrome >> chrome" \
    "com.obsproject.Studio >> obs" \
    "com.slack.Slack >> slack" \
    "com.spotify.Client >> spotify" \
    "com.valvesoftware.Steam >> steam" \
    "com.visualstudio.code >> code" \
    "dev.zed.Zed >> zed" \
    "org.blender.Blender >> blender" \
    "org.chromium.Chromium >> chromium" \
    "org.gimp.GIMP >> gimp" \
    "org.kde.kdenlive >> kdenlive" \
    "org.libreoffice.LibreOffice >> libreoffice" \
    "org.mozilla.firefox >> firefox" \
    "org.onlyoffice.desktopeditors >> onlyoffice" \
    "org.telegram.desktop >> telegram" \
    "org.videolan.VLC >> vlc"

if status is-interactive
    mkdir -p $HOME/.local/bin

    for entry in $flatpak_exports
        set -l parts (string split " >> " -- $entry)
        set -l app_path (flatpak info --show-location $parts[1])

        ln -sf $app_path/files/bin/$parts[2] $EXPORT_DIR/$parts[2]
    end
end
