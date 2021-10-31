#!/usr/bin/env bash

readonly EXTENSIONS='jpg,png,gif,jpeg'
readonly T_PATH='/wp-content/uploads/'
readonly T_RESPONSE='Index of'
readonly SCHEME='http'
readonly PORT=80
readonly SCAN_W=1500
readonly CHECK_W=32
readonly SCAN_COUNT=1000000

log() { echo $(date +%H:%M:%S) "$@" 1>&2; }

get_webservers() {
    log 'Start'
    nmap -n -Pn -T5 -iR $SCAN_COUNT -p $PORT \
        --host-timeout 1s --min-parallelism $SCAN_W --max-retries 1 \
        --open -oG - 2>/dev/null \
        | awk '/\/open\//{print $2}'
    log 'Got ips'
}

check() {
    local uri="${SCHEME}://${1}:${PORT}${T_PATH}"
    curl -sm 5 -A 'Mozilla/5.0' "$uri" \
        | fgrep "${T_RESPONSE}" >/dev/null
}

download() {
    local uri="${SCHEME}://${1}:${PORT}${T_PATH}"
    local out_path="out/$1/"
    wget -q -e robots=off -r -np -nd -A "${EXTENSIONS}" -P "$out_path" "$uri"
}

export -f check download
export SCHEME PORT T_PATH T_RESPONSE EXTENSIONS

get_webservers | xargs -P $CHECK_W -I {} bash -c 'check {} && echo {} && download {}'
