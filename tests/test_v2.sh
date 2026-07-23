#!/bin/bash

# Test Suite for Tiny Rainfall v2 (Ground & Puddles)

# Source the script from the parent directory
source "$(dirname "$0")/../rain_v2.sh"

# Mock tput for testing
tput() {
    if [[ "$1" == "cols" ]]; then echo 80; fi
    if [[ "$1" == "lines" ]]; then echo 24; fi
}

test_puddle_accumulation() {
    echo -n "Testing puddle accumulation... "
    update_dimensions
    cols=10
    rows=5
    # Reset puddles for clean test
    for ((j=0; j<cols; j++)); do puddles[j]=0; done
    
    # Simulate a raindrop hitting the ground at index 3. update_buffer
    # shifts everything down one row first, so the drop placed one row
    # above the ground lands on buffer[rows-1] and is counted there.
    buffer[rows-2]="   .      " # One row above the ground
    update_buffer

    if [[ "${puddles[3]}" -eq 1 ]]; then
        echo "PASS"
    else
        echo "FAIL (puddles[3]=${puddles[3]})"
        exit 1
    fi
}

test_puddle_rendering() {
    echo -n "Testing puddle rendering thresholds... "
    update_dimensions
    cols=3
    rows=3
    for ((j=0; j<cols; j++)); do puddles[j]=0; done

    # Column 0: no puddle, column 1: shallow puddle, column 2: full puddle
    puddles[1]=1
    puddles[2]=$((PUDDLE_FULL + 1))
    buffer[rows-2]="   " # No incoming drops
    update_buffer

    local ground="${buffer[rows-1]}"
    if [[ "$ground" == " _~" ]]; then
        echo "PASS"
    else
        echo "FAIL (ground='$ground')"
        exit 1
    fi
}

echo "Running Tiny Rainfall v2 Tests..."
test_puddle_accumulation
test_puddle_rendering
