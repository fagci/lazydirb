#!/usr/bin/env bash
#
# Download images from FTPs

source ./lib/gen.sh
source ./lib/tools.sh
source ./lib/term.sh

process() {
    local ip="$1"
    local uri="ftp://$ip/"
    local out_path="out/ftp/$ip/"

    local contents=$(curl -s "$uri")

    if [ ! -z "$contents" ]; then
        info "$ip"
        echo "$contents"
        download_recursive "$uri" 'jpg,png,gif,jpeg' "$out_path"
    fi
}

export -f process

random_ftp | xargs -P 16 -I {} bash -c 'process {}'
