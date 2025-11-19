# Quick Phone Mirror Script

This bash script automates the process of connecting to an Android device over WiFi using ADB (Android Debug Bridge) and launching scrcpy for screen mirroring.

## What the Script Does

1. Checks if any Android devices are already connected via ADB.
2. If a device is connected, it skips to running scrcpy.
3. If no device is connected:
   - Enables TCP/IP mode on the device (`adb tcpip 5555`).
   - Attempts to use a cached IP address from `.cache` file.
   - If the cached IP works, connects to it.
   - If not, prompts the user for the phone's IP address, connects, and caches it for future use.
4. Launches scrcpy for screen mirroring.
5. Cleans up by disconnecting the device if it was connected via IP.

## Prerequisites

### macOS
- Install ADB:
  ```
  brew install android-platform-tools
  ```
- Install scrcpy:
  ```
  brew install scrcpy
  ```

### Linux
- Install ADB (Ubuntu/Debian):
  ```
  sudo apt update
  sudo apt install android-tools-adb android-tools-fastboot
  ```
- Install scrcpy (Ubuntu/Debian):
  ```
  sudo apt install scrcpy
  ```
  Or via Snap:
  ```
  sudo snap install scrcpy
  ```

### General Requirements
- Android device with USB debugging enabled.
- Device initially connected via USB for the first setup.
- WiFi connection between your computer and the Android device.

## How to Run

1. Ensure your Android device is connected via USB and USB debugging is enabled.
2. Run the script:
   ```
   ./run.sh
   ```
3. If prompted, enter your phone's IP address (found in Settings > About Phone > Status > IP Address).
4. The script will connect wirelessly and start scrcpy for mirroring.

## Notes
- The IP address is cached in a `.cache` file (ignored by Git) for convenience.
- If the connection fails, you'll be prompted to enter a new IP address.
- Ensure both your computer and phone are on the same WiFi network.
