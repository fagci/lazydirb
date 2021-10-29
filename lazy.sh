#!/usr/bin/env bash

DIR='/wp-content/uploads/'

BL_IPS='10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,224-255.-.-.-'

function ip_gen() {
    nmap -n -iR 1000000 -sL --exclude $BL_IPS | awk '/report for/ {print $NF}'
}

function check() {
    local ip="$1"
    curl -s -A 'Mozilla/5.0' --url "http://$ip$DIR" \
        --connect-timeout 1 --max-time 5 --max-filesize 20K --tcp-nodelay \
        | fgrep 'Index of' > /dev/null
}

function download() {
    local ip="$1"
    wget -q -e robots=off -r -np -nd \
        -Ajpg,png,gif,jpeg -P "out/$ip/" "http://$ip$DIR"
}

export -f check
export -f download

ip_gen | xargs -P 1024 -I {} bash -c 'check {} && echo {} && download {}'
