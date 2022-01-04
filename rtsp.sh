#!/usr/bin/env bash
#
# Download images from random open rtsp cameras
# status: beta

source ./lib/gen.sh

dl(){
    ffmpeg -loglevel error \
        -y -rtsp_transport tcp -i "$1" \
        -frames:v 1 -r 1 \
        -stimeout 20000000 \
        "$2" 2>&1
}

process_path() {
    local ip="$1"
    local path="$2"

    local uri="rtsp://${ip}:554${path}"
    local out_path="out/rtsp/${ip}_${path/\//_}.png"

    echo "[*] ${ip}${path}"
    local err="$(dl "$uri" "$out_path")"

    grep -qF ' 401 ' <<< "$err" && echo "401 ${ip}" && exit 255

    if [[ -z "${err}" ]]; then
        echo "[+] ${ip}${path}"
        exit 255
    fi

    echo "${err}"
}

process_ip() {
    local ip="$1"
    xargs -a ./rtsp.txt -P 1 -I {} bash -c "process_path ${ip} {}" 2>/dev/null
}

export -f process_path process_ip dl

mkdir -p ./out/rtsp/

random_rtsp | xargs -P 128 -I {} bash -c 'process_ip {}'
