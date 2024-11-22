#!/bin/bash

CONFIG_DIR="$HOME/.config"

GTK3_SETTINGS="$CONFIG_DIR/gtk-3.0/settings.ini"
GTK4_SETTINGS="$CONFIG_DIR/gtk-4.0/settings.ini"

QT5CT_SETTINGS="$CONFIG_DIR/qt5ct/qt5ct.conf"
QT6CT_SETTINGS="$CONFIG_DIR/qt6ct/qt6ct.conf"

if grep -q 'gtk-application-prefer-dark-theme=1' "$GTK3_SETTINGS"; then
    sed -i 's/gtk-application-prefer-dark-theme=1/gtk-application-prefer-dark-theme=0/' "$GTK3_SETTINGS" "$GTK4_SETTINGS"
    sed -i 's/gtk-theme-name=Adwaita-dark/gtk-theme-name=Adwaita/' "$GTK3_SETTINGS" "$GTK4_SETTINGS"

    sed -i 's/style=Adwaita-dark/style=Adwaita/' "$QT5CT_SETTINGS"
    sed -i 's/style=Adwaita-dark/style=Adwaita/' "$QT6CT_SETTINGS"

    THEME="Light"
else
    sed -i 's/gtk-application-prefer-dark-theme=0/gtk-application-prefer-dark-theme=1/' "$GTK3_SETTINGS" "$GTK4_SETTINGS"
    sed -i 's/gtk-theme-name=Adwaita/gtk-theme-name=Adwaita-dark/' "$GTK3_SETTINGS" "$GTK4_SETTINGS"

    sed -i 's/style=Adwaita/style=Adwaita-dark/' "$QT5CT_SETTINGS"
    sed -i 's/style=Adwaita/style=Adwaita-dark/' "$QT6CT_SETTINGS"

    THEME="Dark"
fi

notify-send "Theme switched to $THEME"

i3-msg reload
