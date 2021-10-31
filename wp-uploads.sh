#!/usr/bin/env bash
#
# Download images from random wordpress sites

source ./lib/gen.sh
source ./lib/tools.sh

process() {
    local ip="$1"
    local uri="http://${ip}:80/wp-content/uploads/"
    local out_path="out/$ip/"

    has_index "$uri" \
        && echo "$ip" \
        && download_recursive "$uri" 'jpg,png,gif,jpeg' "$out_path"
}

export -f process

random_sites | xargs -P 16 -I {} bash -c 'process {}'
