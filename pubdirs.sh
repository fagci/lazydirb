#!/usr/bin/env bash
#
# Download images from random sites

source ./lib/gen.sh
source ./lib/tools.sh

process_path() {
    local ip="$1"
    local path="$2"

    local uri="http://${ip}/${path}/"
    local out_path="out/${path/[/]/_/}/${ip}/"

    has_index "$uri" \
        && echo "${ip}: ${path}" \
        && download_recursive "$uri" 'jpg,png,gif,jpeg' "$out_path"
}

process_ip() {
    local ip="$1"
    xargs -a ./pubdirs.txt -P 2 -I {} bash -c "process_path ${ip} {}"
}

export -f process_ip
export -f process_path

random_http | xargs -P 32 -I {} bash -c 'process_ip {}'
