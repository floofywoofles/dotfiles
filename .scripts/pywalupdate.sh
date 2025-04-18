#!/bin/bash

# Get wallpaper path with proper path expansion
wallpaper=$(awk -F= -v key="wallpaper" '
    $1 ~ "^[[:space:]]*" key "[[:space:]]*$" {
        gsub(/^[[:space:]]+|[[:space:]]+$/, "", $2);
        print $2;
        exit
    }' /home/floofywoofles/.config/waypaper/config.ini)

# Expand ~ to $HOME if present
wallpaper="${wallpaper/#\~/$HOME}"

# Debug output
echo "Extracted wallpaper path: '$wallpaper'"
echo "Does file exist? $(if [ -f "$wallpaper" ]; then echo "Yes"; else echo "No"; fi)"

# Verify file exists before proceeding
if [ ! -f "$wallpaper" ]; then
    echo "Error: Wallpaper file not found at '$wallpaper'"
    exit 1
fi

# Apply with wal and hyprpaper
echo "Applying wallpaper with wal..."
if ! wal -i  "$wallpaper" --backend hyprpaper -n; then
    echo "Error: Failed to apply wallpaper"
    exit 1
fi

# Restart Waybar
echo "Restarting Waybar..."
if pkill waybar; then
    nohup waybar &>/dev/null &
    echo "Waybar restarted successfully!"
else
    echo "Warning: Failed to restart Waybar (was it running?)"
    nohup waybar &>/dev/null &
fi

/usr/bin/wpg-install.sh -i -d -g
