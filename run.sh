#!/bin/bash

if adb devices | tail -n +2 | grep -q "device"; then
    echo "Device already connected. Running scrcpy."
    scrcpy
else
    adb tcpip 5555

    CACHE_FILE=".cache"

    if [ -f "$CACHE_FILE" ]; then
        ipaddress=$(cat "$CACHE_FILE")
        echo "Trying cached IP: $ipaddress"
        if adb connect ${ipaddress}:5555 >/dev/null 2>&1; then
            echo "Connected using cached IP."
        else
            echo "Cached IP failed. Please enter a new IP address."
            read -p "Enter phone IP address: " ipaddress
            adb connect ${ipaddress}:5555
            echo "$ipaddress" > "$CACHE_FILE"
        fi
    else
        read -p "Enter phone IP address: " ipaddress
        adb connect ${ipaddress}:5555
        echo "$ipaddress" > "$CACHE_FILE"
    fi

    scrcpy

    adb disconnect ${ipaddress}:5555
fi
