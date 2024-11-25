#!/bin/bash
rm ./dconf-settings.dconf
dconf dump / > ./dconf-settings.dconf
