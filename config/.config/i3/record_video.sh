#!/bin/bash

# Get the selected region coordinates using slop
REGION=$(slop -f "%x %y %w %h")

# Extract coordinates and dimensions
read -r X Y W H <<< "$REGION"

# Create the recording using ffmpeg
ffmpeg \
    -video_size "${W}x${H}" \
    -framerate 30 \
    -f x11grab \
    -i "$DISPLAY+$X,$Y" \
    -c:v libx264 \
    -preset ultrafast \
    ~/recording_$(date +%Y-%m-%d_%H-%M-%S).mp4
