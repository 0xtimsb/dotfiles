#!/bin/bash

pactl set-sink-volume @DEFAULT_SINK@ +5%

current_volume=$(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' | sed 's/%//')

if [ "$current_volume" -gt "100" ]; then
    pactl set-sink-volume @DEFAULT_SINK@ 100%
fi
