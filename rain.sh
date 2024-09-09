#!/bin/bash

cols=$(tput cols)
rows=$(tput lines)
buffer=()

# Initialize the buffer with empty lines
for ((i=0; i<rows; i++)); do
    buffer[i]=""
done

while :; do
    tput sc  # Save cursor position
    tput ed  # Clear the screen

    # Shift buffer lines down
    for ((i=rows-1; i>0; i--)); do
        buffer[i]=${buffer[i-1]}
    done

    # Generate new top line
    new_line=""
    for ((j=0; j<cols; j++)); do
        if ((RANDOM % 10 < 1)); then
            new_line+=","
        else
            new_line+=" "
        fi
    done
    buffer[0]=$new_line

    # Print the buffer
    for ((i=0; i<rows; i++)); do
        printf "\033[$((i+1));1H${buffer[i]}"
    done

    tput rc  # Restore cursor position
    sleep 0.1  # Adjust sleep time for desired rain speed
done
