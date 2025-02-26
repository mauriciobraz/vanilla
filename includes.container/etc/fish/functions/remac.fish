function remac --description 'Randomizes MAC address using ip command'
    set -l HEX_FULL 0 1 2 3 4 5 6 7 8 9 A B C D E F
    set -l HEX_FIRST 0 2 4 6 8 A C E

    if test (count $argv) -eq 0
        echo "Usage: remac <interface>"
        return 1
    end

    set NET_IF $argv[1]

    if not ip link show dev $NET_IF > /dev/null 2>&1
        echo "Error: Interface '$NET_IF' not available."
        return 1
    end

    set -l MAC_PARTS

    for i in 1 2 3 4 5 6
        if test $i -eq 1
            set OCT1 (random choice $HEX_FIRST)
            set OCT2 (random choice $HEX_FIRST)
        else
            set OCT1 (random choice $HEX_FULL)
            set OCT2 (random choice $HEX_FULL)
        end

        set -a MAC_PARTS $OCT1$OCT2
    end

    set -l NEW_MAC (string join ":" $MAC_PARTS)

    set -l CURR_MAC (ip link show dev $NET_IF 2>/dev/null \
        | grep -Eo '([[:xdigit:]]{2}:){5}[[:xdigit:]]{2}' \
        | head -n1)

    if test -z "$CURR_MAC"
        echo "Error: Cannot determine current MAC for '$NET_IF'."
        return 1
    end

    echo "[*] Changing MAC ('$NET_IF') from '$CURR_MAC' to '$NEW_MAC'"

    if not sudo ip link set dev $NET_IF down 2>/dev/null
        echo "Error: Failed to bring down '$NET_IF'."
        return 1
    end

    if not sudo ip link set dev $NET_IF address $NEW_MAC 2>/dev/null
        echo "Error: Failed to set new MAC on '$NET_IF'."
        sudo ip link set dev $NET_IF up 2>/dev/null
        return 1
    end

    if not sudo ip link set dev $NET_IF up 2>/dev/null
        echo "Error: Failed to bring up '$NET_IF' after change."
        return 1
    end

    set -l UPDATED_MAC (ip link show dev $NET_IF 2>/dev/null \
        | grep -Eo '([[:xdigit:]]{2}:){5}[[:xdigit:]]{2}' \
        | head -n1)
    if test "$UPDATED_MAC" = "$NEW_MAC"
        echo "[+] MAC changed from $CURR_MAC to $NEW_MAC."
    else
        echo "[-] MAC change failed. Current MAC: $UPDATED_MAC."
        return 1
    end
end
