#!/usr/bin/env bash
#
# Download images from random sites (GNU paralleel version)

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

export -f process_path

random_http | parallel -j 64 process_path :::: - :::: ./pubdirs.txt
