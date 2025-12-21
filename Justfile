plugins := "Vanilla-OS/vib-fsguard:v1.5.3"
vibversion := `grep '^vibversion:' recipe.yml | awk '{print $2}'`

[private]
default:
    just --list

build arch="amd64":
    just compile {{arch}}
    podman build .

compile arch="amd64":
    #!/usr/bin/env bash
    set -euxo pipefail

    ARCH="{{arch}}"
    PLUGINS="{{plugins}}"
    VIBVERSION="{{vibversion}}"

    if ! command -v vib &> /dev/null; then
        mkdir -p $HOME/.local/bin

        if [ ! -f $HOME/.local/bin/vib ]; then
            wget -O $HOME/.local/bin/vib "https://github.com/Vanilla-OS/Vib/releases/download/v${VIBVERSION}/vib-${ARCH}"
            chmod +x $HOME/.local/bin/vib
        fi

        export PATH="$HOME/.local/bin:$PATH"
    fi

    if [ ! -d plugins ]; then
        TMPDIR=$(mktemp -d)

        wget -O "${TMPDIR}/plugins-${ARCH}.tar.gz" "https://github.com/Vanilla-OS/Vib/releases/download/v${VIBVERSION}/plugins-${ARCH}.tar.gz"
        tar -xf "${TMPDIR}/plugins-${ARCH}.tar.gz" -C "${TMPDIR}"

        cp -r "${TMPDIR}/build/plugins" ./
        rm -rf "${TMPDIR}"
    fi

    IFS=',' read -ra PLUGIN_LIST <<<"${PLUGINS}"
    for PLUGIN in "${PLUGIN_LIST[@]}"; do
        TAG=$(echo "$PLUGIN" | awk -F':' '{print $2}')
        REPO=$(echo "$PLUGIN" | awk -F':' '{print $1}')

        ASSETS_URL="https://api.github.com/repos/${REPO}/releases/tags/${TAG}"
        ASSET_URLS=$(curl -s "$ASSETS_URL" | grep -o -E "https://github.com/[^\"]+-${ARCH}\.so" || true)

        if [ -z "$ASSET_URLS" ]; then
            ASSET_URLS=$(curl -s "$ASSETS_URL" | grep -o -E 'https://github.com/[^"]+\.so' || true)
        fi

        if [ -z "$ASSET_URLS" ]; then
            echo "Warning: No plugin assets found for ${REPO}:${TAG}"
            continue
        fi

        for ASSET_URL in $ASSET_URLS; do
            FILENAME=$(basename "$ASSET_URL")

            if [[ "$FILENAME" == *-${ARCH}.so ]]; then
                PLUGIN_NAME=$(basename "$FILENAME" "-${ARCH}.so")
                FINAL_PATH="plugins/${PLUGIN_NAME}.so"
            else
                FINAL_PATH="plugins/$FILENAME"
            fi

            if [ -f "$FINAL_PATH" ]; then
                echo "Plugin already exists: $FINAL_PATH"
                continue
            fi

            wget -O "plugins/$FILENAME" "$ASSET_URL"

            if [[ "$FILENAME" == *-${ARCH}.so ]]; then
                PLUGIN_NAME=$(basename "$FILENAME" "-${ARCH}.so")
                mv "plugins/$FILENAME" "plugins/${PLUGIN_NAME}.so"
            fi
        done
    done

    rm -rf sources
    vib build recipe.yml
