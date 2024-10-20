#!/usr/bin/env bash

update_status() {
    is_muted=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')
    if [ "$is_muted" = "yes" ]; then
        volume="mute"
    else
        volume=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '[0-9]{1,3}(?=%)' | head -1)
        volume="${volume}%"
    fi
    
    date_time=$(date +'%a %Y-%m-%d %I:%M:%S %p')

    wifi_network=$(iwgetid -r)
    if [ -z "$wifi_network" ]; then
        wifi_network="Disconnected"
    fi

    echo "vol: $volume | wifi: $wifi_network | $date_time"
}

cleanup() {
    kill $(jobs -p)
    exit
}

trap cleanup EXIT

pactl subscribe | grep --line-buffered "sink" | while read -r; do
    update_status
done &

while true; do
    update_status
    sleep 1
done
