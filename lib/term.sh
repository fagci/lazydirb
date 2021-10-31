export C_RESET='\033[0m'
export C_RED='\033[0;31m'
export C_GREEN='\033[0;32m'
export C_YELLOW='\033[0;33m'
export C_BLUE='\033[0;34m'
export C_PURPLE='\033[0;35m'
export C_CYAN='\033[0;36m'
export C_WHITE='\033[0;37m'

info() {
    printf "${C_BLUE}[i] $@ ${C_RESET}\n" >&2
}

export -f info
