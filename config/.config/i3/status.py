#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import json
import subprocess

def get_mic_status():
    """ Get the microphone status (mute status and volume). Returns tuple of (text, color) """
    try:
        mic_status_cmd = "pactl list sources"
        mic_status = subprocess.check_output(mic_status_cmd, shell=True).decode("utf-8")
        
        sections = mic_status.split("Name: ")
        mic_section = ""
        for section in sections:
            if section.startswith("alsa_input.pci-0000_00_1f.3.analog-stereo"):
                mic_section = section
                break
                
        if not mic_section:
            return ("mic: not found", None)
            
        lines = mic_section.splitlines()
        
        mute_status = "unknown"
        volume_value = "0"
        
        for line in lines:
            line = line.strip()
            if line.startswith("Mute:"):
                mute_status = line.split(":", 1)[1].strip()
            elif line.startswith("Volume:"):
                volume_parts = line.split("%")
                if len(volume_parts) > 0:
                    volume_str = volume_parts[0].split("/")[-1].strip()
                    volume_value = volume_str
        
        if mute_status == "yes":
            return (f"mic: muted ({volume_value}%)", "#FFFF00")
        else:
            return (f"mic: {volume_value}%", None)
            
    except subprocess.CalledProcessError:
        return ("mic: error", None)
    except Exception as e:
        return (f"mic: error ({str(e)})", None)

def print_line(message):
    """ Non-buffered printing to stdout. """
    sys.stdout.write(message + '\n')
    sys.stdout.flush()

def read_line():
    """ Interrupted respecting reader for stdin. """
    try:
        line = sys.stdin.readline().strip()
        if not line:
            sys.exit(3)
        return line
    except KeyboardInterrupt:
        sys.exit()

if __name__ == '__main__':
    print_line(read_line())
    print_line(read_line())

    while True:
        line, prefix = read_line(), ''
        if line.startswith(','):
            line, prefix = line[1:], ','

        j = json.loads(line)

        mic_text, mic_color = get_mic_status()
        status_obj = {'full_text': mic_text, 'name': 'mic_status'}
        if mic_color:
            status_obj['color'] = mic_color
        j.insert(0, status_obj)

        print_line(prefix + json.dumps(j))

