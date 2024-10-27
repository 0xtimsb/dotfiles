#!/bin/bash
i3status | while :
do
    read line

    mic_status=$(pactl list sources | grep -A 7 alsa_input.pci-0000_00_1f.3.analog-stereo)
    mic_mute=$(echo "$mic_status" | grep "Mute:" | awk '{print $2}')
    mic_volume=$(echo "$mic_status" | grep "Volume:" | awk '{print $5}')
    if [ "$mic_mute" = "yes" ]; then
        mic_display="mic: muted ($mic_volume)"
    else
        mic_display="mic: $mic_volume"
    fi

    echo "$mic_display | $line" || exit 1
done
