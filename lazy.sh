#!/usr/bin/env bash
#
# Download images from random wordpress sites

readonly EXTENSIONS='jpg,png,gif,jpeg'
readonly PARALLEL_SITES_DOWNLOAD=32
readonly SCAN_WORKERS=1500
readonly SCHEME='http'
readonly PORT=80
readonly wg='wget -q -e robots=off --user-agent Mozilla/5.0'

export SCHEME PORT EXTENSIONS wg


random_sites() {
    nmap -T5 --min-parallelism $SCAN_WORKERS --max-retries 1 \
        -n -Pn -iR 0 -p $PORT --open -oG - 2>/dev/null \
        | awk '/open/{print $2}'
}

has_index() {
    $wg -t1 -T7 "$1" -O- | fgrep 'Index of' >/dev/null
}

download() {
    $wg -r -np -nd -nc -Q 200M -A "$EXTENSIONS" -P "$2" "$1"
}

process() {
    local ip="$1"
    local uri="${SCHEME}://${ip}:${PORT}/wp-content/uploads/"
    local out_path="out/$ip/"

    has_index "$uri" && echo "$ip" && download "$uri" "$out_path"
}

export -f process has_index download

random_sites | xargs -P $PARALLEL_SITES_DOWNLOAD -I {} bash -c 'process {}'
