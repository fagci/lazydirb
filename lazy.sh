#!/usr/bin/env bash

readonly DIR='/wp-content/uploads/'

readonly BL_IPS='10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,224-255.-.-.-'

ip_gen() {
    nmap -n -iR 1000000 -sL --exclude "${BL_IPS}" | awk '/report for/ {print $NF}'
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

ip_gen | xargs -P 1024 -I {} bash -c 'check {} && echo {} && download {}'
