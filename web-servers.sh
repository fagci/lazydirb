#!/usr/bin/env bash
#
# Download images from random wordpress sites
readonly OUT_PATH="out/headers/"

mkdir -p "$OUT_PATH"

source ./lib/gen.sh
source ./lib/tools.sh

process() {
    local ip="$1"
    local uri="http://${ip}/"

    srv=$(wg -S --spider -O /dev/null 2>&1 "$uri" | awk '/Server:/{for(i=2;i<=NF;++i)print $i}' | xargs)
    if [ ! -z "$srv" ]; then
        echo "${ip} ${srv}"
    fi
}

export -f process

random_http | xargs -P 1024 -I {} bash -c 'process {}' >> "${OUT_PATH}/server.txt"

