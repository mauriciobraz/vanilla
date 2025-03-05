function rmac --description "Change MAC Address of a network interface (default to current)"
    argparse -X 1 'd/decrement' 'r/random' 'm/mac=' 'i/interface=' 'h/help' -- $argv
    or return

    if set -q _flag_help
        echo "Usage: rmac [OPTIONS]"
        echo "Options:"
        echo "  -r/--random      Generate random valid MAC (default)"
        echo "  -i/--interface   Select network interface to use"
        echo "  -d/--decrement   Decrease MAC address by 1"
        echo "  -m/--mac MAC     Set specific MAC address"
        echo "  -h/--help        Show this help"
        return
    end

    function __detect_interface
        set -l active_iface (ip -br link | awk '{if($2 == "UP") {print $1; exit}}' 2>/dev/null)

        if test -n "$active_iface"
            echo $active_iface
            return
        end

        set -l first_iface (ip -br link | awk '!/lo/ {print $1; exit}' 2>/dev/null)

        if test -n "$first_iface"
            echo $first_iface
            return
        end

        echo "eth0"
    end

    function __get_random_mac
        openssl rand -hex 6 | sed "s/\(..\)/\1:/g; s/./0/2; s/.\$//" | tr 'a-f' 'A-F'
    end

    function __is_valid_mac
        string match -qr '^([0-9a-fA-F]{2}:){5}[0-9a-fA-F]{2}$' -- $argv[1]
        and string match -qr '^.:[02468aceACE]' -- $argv[1]
    end

    function __mac_to_int
        string replace -a ':' '' -- $argv[1] | xxd -r -p | od -An -t x8 | tr -d ' '
    end

    if set -q _flag_interface
        set interface $_flag_interface
    else
        set interface (__detect_interface)
    end

    if not ip -br link | awk '{print $1}' | grep -q "^$interface$"
        echo "[-] Interface '$interface' not found"
        return 1
    end

    set -l current_mac (ip -br link show dev $interface | awk '{print $3}')

    if set -q _flag_mac
        set -l new_mac (string upper $argv[-1])

        if not __is_valid_mac $new_mac
            echo "[-] Invalid MAC format! Must be XX:XX:XX:XX:XX:XX with 2nd character even (0,2,4,6,8,A,C,E)"
            return 1
        end
    else if set -q _flag_decrement
        set -l mac_int (math --base=hex (__mac_to_int $current_mac) -1)
        set -l new_mac (printf "%012x" $mac_int | fold -w2 | string join ':')

        if not __is_valid_mac $new_mac
            echo "[-] Decrement resulted in invalid MAC! Use --random instead"
            return 1
        end
    else
        set -l new_mac (__get_random_mac)
    end

    pkexec sh -c "\
        ip link set dev $interface down && \
        ip link set dev $interface address $new_mac && \
        ip link set dev $interface up"

    set -l updated_mac (ip -br link show dev $interface | awk '{print $3}')

    if test "$updated_mac" = "$new_mac"
        echo "[+] MAC address successfully changed!"
        echo "[+] Old: $current_mac"
        echo "[+] New: $new_mac"
    else
        echo "[-] Failed to change MAC address!"
        echo "[-] Current MAC: $updated_mac"
        return 1
    end
end
