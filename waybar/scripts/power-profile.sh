#!/bin/bash

get_profile() {
    CURRENT_PROFILE=$(powerprofilesctl get)
    
    case "$CURRENT_PROFILE" in
        "performance")
            ICON=""  # Bolt icon
            CLASS="performance"
            ;;
        "balanced")
            ICON=""  # Balance icon
            CLASS="balanced"
            ;;
        "power-saver")
            ICON=""  # Leaf icon
            CLASS="power-saver"
            ;;
        *)
            ICON=""
            CLASS="unknown"
            ;;
    esac
    
    echo "{\"text\":\"$CURRENT_PROFILE\", \"class\":\"$CLASS\", \"icon\":\"$ICON\"}"
}

cycle_profile() {
    CURRENT_PROFILE=$(powerprofilesctl get)
    
    case "$CURRENT_PROFILE" in
        "performance")
            powerprofilesctl set balanced
            ;;
        "balanced")
            powerprofilesctl set power-saver
            ;;
        "power-saver" | *)
            powerprofilesctl set performance
            ;;
    esac
}

if [[ "$1" == "cycle" ]]; then
    cycle_profile
else
    get_profile
fi