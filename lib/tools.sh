wg(){
    wget -q -e robots=off --user-agent Mozilla/5.0 $@
}

download_recursive() {
    local uri="$1"
    local extensions="$2"
    local destination="$3"

    wg -r -np -nd -nc -Q 100M -A "$extensions" -P "$destination" "$uri"
}

has_index() {
    wg -t1 -T7 "$1" -O- | grep -F 'Index of' >/dev/null
}

export -f wg has_index download_recursive

# vi: ft=bash
