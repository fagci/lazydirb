#!/usr/bin/env bash
# version: alpha

mkdir -p ./out/best/

find ./out/ \
    | xargs identify -format "%w %h %d/%f\n" \
    | awk '$1 >= 1240 && $2 >= 1024 {print}' \
    | cut -d ' ' -f3- \
    | xargs -I@ cp "@" ./out/best/

