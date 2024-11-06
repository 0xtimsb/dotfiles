#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import json
import subprocess
import requests

from config import ST_URL, API_KEY, FOLDER_ID


GRUVBOX_RED = "#cc241d"
GRUVBOX_GREEN = "#98971a"
GRUVBOX_YELLOW = "#d79921"
GRUVBOX_BLUE = "#458588"
GRUVBOX_WHITE = "#ebdbb2"
GRUVBOX_BG_LIGHT = "#3c3836"

SECTION_LENGTH_HOURS = 1

def get_mic_status():
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
            return (" mic: not found", None)
            
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
            return (f" mic: muted ({volume_value}%)", GRUVBOX_YELLOW)
        else:
            return (f" mic: {volume_value}%", GRUVBOX_WHITE)
            
    except subprocess.CalledProcessError:
        return (" mic: error", GRUVBOX_RED)
    except Exception as e:
        return (f" mic: error ({str(e)})", GRUVBOX_RED)

def get_syncthing_status():
    try:
        headers = {'X-API-Key': API_KEY}

        response = requests.get(f"{ST_URL}/db/status?folder={FOLDER_ID}", headers=headers)
        folder_status = response.json()

        if folder_status["state"] == "syncing":
            total_bytes = folder_status["globalBytes"]
            needed_bytes = folder_status["needBytes"]
            if total_bytes > 0:
                completion = ((total_bytes - needed_bytes) / total_bytes) * 100
                return (f" sync with phone: {completion:.1f}% ", GRUVBOX_YELLOW)
            return (" sync with phone: 0% ", GRUVBOX_YELLOW)
        else:
            size_bytes = folder_status["localBytes"]
            size_mb = size_bytes / (1024**2)
            return (f" sync with phone: {size_mb:.1f}MB ", GRUVBOX_WHITE)

    except Exception as e:
        return (f" sync with phone: error ", GRUVBOX_RED)

def print_line(message):
    """ Non-buffered printing to stdout. """
    sys.stdout.write(message + '\n')
    sys.stdout.flush()

def read_line():
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


        sync_text, sync_color = get_syncthing_status()
        sync_obj = {'full_text': sync_text, 'name': 'syncthing_status'}
        if sync_color:
            sync_obj['color'] = sync_color
        j.insert(0, sync_obj)

        mic_text, mic_color = get_mic_status()
        status_obj = {'full_text': mic_text, 'name': 'mic_status'}
        if mic_color:
            status_obj['color'] = mic_color
        j.insert(0, status_obj)
         
        print_line(prefix + json.dumps(j))

