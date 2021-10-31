#!/usr/bin/env bash
#
# Download images from FTPs

source ./lib/gen.sh
source ./lib/tools.sh

process() {
    local ip="$1"
    local uri="ftp://$ip/"
    local out_path="out/$ip/"

    curl -s "$uri"  \
        && echo $ip \
        && download_recursive "$uri" 'jpg,png,gif,jpeg' "$out_path"

}

export -f process

random_ips T:21 | xargs -P 16 -I {} bash -c 'process {}'
