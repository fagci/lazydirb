#!/usr/bin/env bash

readonly DIR='/wp-content/uploads/'

ip_gen() {
    nmap -n -iR 1000000 -sL | awk '/report for/ {print $NF}'
}

check() {
    local ip="$1"
    curl -sA "Mozilla/5.0" -m5 --connect-timeout 1 --max-filesize 20K --tcp-nodelay \
        "http://$ip$DIR" | fgrep 'Index of' > /dev/null
}

download() {
    local ip="$1"
    wget -q -e robots=off -r -np -nd \
        -A jpg,png,gif,jpeg -P "out/$ip/" "http://$ip$DIR"
}

export -f check
export -f download
export DIR

ip_gen | xargs -P 1024 -I {} bash -c 'check {} && echo {} && download {}'
