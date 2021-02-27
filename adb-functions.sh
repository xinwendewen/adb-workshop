#!/bin/bash
#
#
current_package() {
    adb shell dumpsys activity recents | grep -w "Recent #0" | cut -d '=' -f 2 | cut -d ' ' -f 1
}

pull() {
    adb pull "$1"
}

clear_dir() {
    adb shell rm -rf "$1/*"
}
