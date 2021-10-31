#!/usr/bin/env bash
#
# Download images from random wordpress sites

readonly EXTENSIONS='jpg,png,gif,jpeg'
readonly SCHEME='http'
readonly PORT=80
readonly SCAN_WORKERS=1500
readonly UA='Mozilla/5.0'

export SCHEME PORT EXTENSIONS UA

random_sites() {
    nmap -T5 --min-parallelism $SCAN_WORKERS --host-timeout 1s --max-retries 1 \
        -n -Pn -iR 0 -p $PORT --open -oG - 2>/dev/null \
        | awk '/open/{print $2}'
}

has_index() {
    curl -sm 5 -A "$UA" "$1" | fgrep 'Index of' >/dev/null
}

download() {
    wget -q -e robots=off --user-agent="$UA" -r -np -nd -nc \
        -Q 200M -A "$EXTENSIONS" -P "$2" "$1"
}

process() {
    local ip="$1"
    local uri="${SCHEME}://${ip}:${PORT}/wp-content/uploads/"
    local out_path="out/$ip/"

    if has_index "$uri"; then 
        echo "$ip"
        download "$uri" "$out_path"
    fi
}

export -f process has_index download

random_sites | xargs -P 16 -I {} bash -c 'process {}'
