#!/bin/bash

update_status() {
    battery_0=$(cat /sys/class/power_supply/BAT0/capacity)
    battery_1=$(cat /sys/class/power_supply/BAT1/capacity)
    
    is_muted=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')
    if [ "$is_muted" = "yes" ]; then
        volume="mute"
    else
        volume=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '[0-9]{1,3}(?=%)' | head -1)
        volume="${volume}%"
    fi
    
    brightness=$(brightnessctl -m -d intel_backlight | cut -d',' -f4 | tr -d %)
    date_time=$(date +'%Y-%m-%d %I:%M:%S %p')
    echo "bat main: $battery_0% | bat alt: $battery_1% | vol: $volume | bright: $brightness% | date: $date_time "
}

cleanup() {
    kill $(jobs -p)
    exit
}

trap cleanup EXIT

pactl subscribe | grep --line-buffered "sink" | while read -r; do
    update_status
done &

(
    while true; do
        inotifywait -q -e modify /sys/class/power_supply/BAT0/capacity /sys/class/power_supply/BAT1/capacity /sys/class/backlight/intel_backlight/brightness > /dev/null 2>&1
        update_status
    done
) &

while true; do
    update_status
    sleep 1
done
