#!/bin/bash

# Tiny Rain Simulator v1: falling rain with splashes on the bottom row.
# Usage: ./rain_v1.sh [--thunder]

# --- Configuration ---
COLOR_RAIN="\033[34m"     # Blue
COLOR_BRIGHT="\033[1;34m" # Bright Blue
COLOR_RESET="\033[0m"
COLOR_THUNDER="\033[107m" # Bright White Background

# Using only safe characters to avoid shell parsing issues
CHARACTERS=("." "," ":" "i" "|")
SPLASH_CHAR="v"

SPEED=0.05  # Seconds between frames
DENSITY=20  # 1-in-N chance of a raindrop per cell (lower = more rain)

# Global State
cols=0
rows=0
buffer=()
THUNDER_ENABLED=false

# --- Functions ---

# Get terminal dimensions and re-initialize state
update_dimensions() {
    local i empty_line
    cols=$(tput cols)
    rows=$(tput lines)
    buffer=()
    empty_line=$(printf "%${cols}s" "")
    for ((i=0; i<rows; i++)); do
        buffer[i]="$empty_line"
    done
}

# Restore the terminal on exit
cleanup() {
    tput cnorm # Show cursor
    printf "%b" "$COLOR_RESET"
    clear
}

# Generate a single line of raw rain characters
generate_line() {
    local j new_line=""
    for ((j=0; j<cols; j++)); do
        if ((RANDOM % DENSITY == 0)); then
            new_line+="${CHARACTERS[$RANDOM % ${#CHARACTERS[@]}]}"
        else
            new_line+=" "
        fi
    done
    printf "%s\n" "$new_line"
}

# Shift buffer and handle splashes
update_buffer() {
    local i b

    # Shift buffer down
    for ((i=rows-1; i>0; i--)); do
        buffer[i]="${buffer[i-1]}"
    done

    # Splash Logic: Transform raindrops that hit the bottom row into splashes
    b="${buffer[rows-1]}"
    # Replace any rain character in the set [.,:i|] with a splash character 'v'
    buffer[rows-1]="${b//[.,:i|]/$SPLASH_CHAR}"

    # New top line
    buffer[0]=$(generate_line)
}

# Render the current buffer with optimized coloring
draw_frame() {
    local i line frame=""

    # Move cursor to top-left
    printf "\033[H"

    # Thunder flash: fill the screen with a bright background for a moment,
    # then reset so the flash doesn't linger on blank lines of the next frame
    if [[ "$THUNDER_ENABLED" == "true" ]] && (( RANDOM % 80 == 0 )); then
        printf "%b\033[2J" "$COLOR_THUNDER"
        sleep 0.02
        printf "%b\033[H" "$COLOR_RESET"
    fi

    for ((i=0; i<rows; i++)); do
        line="${buffer[i]}"

        # Fast coloring using pattern replacement
        # We do this in one pass per character type
        if [[ "$line" == *[![:space:]]* ]]; then
            line="${line//./${COLOR_RAIN}.}"
            line="${line//,/${COLOR_RAIN},}"
            line="${line//:/${COLOR_RAIN}:}"
            line="${line//i/${COLOR_RAIN}i}"
            line="${line//|/${COLOR_RAIN}|}"
            line="${line//$SPLASH_CHAR/${COLOR_BRIGHT}${SPLASH_CHAR}}"
            line="${line}${COLOR_RESET}"
        fi

        # Avoid newline on the very last row to prevent scrolling
        if (( i < rows - 1 )); then
            frame+="$line\n"
        else
            frame+="$line"
        fi
    done

    printf "%b" "$frame"
}

# Main loop
main() {
    if [[ "$1" == "--thunder" || "$THUNDER" == "true" ]]; then
        THUNDER_ENABLED=true
    fi

    trap update_dimensions SIGWINCH
    # Run cleanup once on any exit; the INT/TERM traps just convert the
    # signal into an exit with the conventional code, which fires EXIT
    trap cleanup EXIT
    trap 'exit 130' SIGINT
    trap 'exit 143' SIGTERM

    tput civis # Hide cursor
    update_dimensions

    while :; do
        update_buffer
        draw_frame
        sleep "$SPEED"
    done
}

# Run main if not being sourced
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
