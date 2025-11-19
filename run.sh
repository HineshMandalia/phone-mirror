#!/bin/bash

get_ip_address() {
    read -p "Enter phone IP address (or press enter to scan network): " ipaddress
    if [ -z "$ipaddress" ]; then
        if [[ "$OSTYPE" == "darwin"* ]]; then
            # macOS
            SUBNET=$(ifconfig en0 | grep "inet " | awk '{print $2}' | sed 's/\.[0-9]*$/.0\/24/')
        else
            # Linux
            SUBNET=$(ip route | grep "src" | awk '{print $1}')
        fi
        echo "Scanning $SUBNET for Android device with ADB on 5555..."
        HOST=$(nmap -p 5555 --open -n -T4 $SUBNET 2>/dev/null | \
               grep "Nmap scan report" | awk '{print $5}')
        if [ -z "$HOST" ]; then
            echo "No device found."
            exit 1
        fi
        echo "Found device at $HOST"
        ipaddress=$HOST
    fi
}

connect_device() {
    output=$(adb connect ${ipaddress}:5555 2>&1)
    if echo "$output" | grep -q "connected to"; then
        echo "$ipaddress" > "$CACHE_FILE"
    else
        echo "Failed to connect: $output"
        return 1
    fi
}

if adb devices | tail -n +2 | grep -q "device"; then
    echo "Device already connected. Running scrcpy."
    scrcpy
else
    CACHE_FILE=".cache"

    if [ -f "$CACHE_FILE" ]; then
        ipaddress=$(cat "$CACHE_FILE")
        echo "Trying cached IP: $ipaddress"
        connect_device
        e=$?
        if [ $e -ne 0 ]; then
            echo "Cached IP failed. Please enter a new IP."
            get_ip_address
            connect_device
            e=$?
        fi
    else
        get_ip_address
        connect_device
        e=$?
    fi
    if [ $e -ne 0 ]; then
        echo "Could not connect to device. Exiting."
        exit 1
    fi

    scrcpy

    adb disconnect ${ipaddress}:5555
fi
