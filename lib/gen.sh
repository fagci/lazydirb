random_ips() {
    local port="${1}"
    local workers="${2:-1500}"

    if [ -z "$port" ]; then
        echo 'Port not specified' 1>&2
        exit 255
    fi

    nmap -T5 --min-parallelism "$workers" --max-retries 1 \
        -n -Pn -iR 0 -p "$port" --open -oG - 2>/dev/null \
        | awk '/open/{print $2}'
}

export random_ips

# vi: ft=bash
