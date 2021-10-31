random_sites() {
    local port="${1:-80}"
    local workers="${2:-1500}"
    nmap -T5 --min-parallelism "$workers" --max-retries 1 \
        -n -Pn -iR 0 -p "$port" --open -oG - 2>/dev/null \
        | awk '/open/{print $2}'
}

# vi: ft=bash
