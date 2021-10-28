#!/usr/bin/env bash
BL_IPS='10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,224-255.-.-.-'

function gen() {
    nmap -n -iR 102400 -sL --exclude $BL_IPS \
        | awk '/report for/ {print $NF}'
}

function dl() {
    local ip="$1"
    wget -q -e robots=off -r \
        -np -nd \
        -Ajpg,png \
        -P "out/$ip/" \
        "http://$ip/wp-content/uploads/"
}

function check() {
    local ip="$1"
    curl -s -H 'User-Agent: Mozilla/5.0' \
        --connect-timeout 2 \
        --max-time 3 \
        "http://$ip/wp-content/uploads/" \
        | fgrep 'Index of' > /dev/null
}

export -f check
export -f dl

gen | xargs -P 2048 -I {} bash -c 'check {} && echo {} && dl {}'
