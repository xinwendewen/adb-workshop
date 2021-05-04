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

remotable_adb() {
    set -u
    local cmd=$1
    set +u
    if [[ -n ${HOST} && -n ${PORT} ]];
    then
        #echo "adb -H ${HOST} -P ${PORT} ${cmd}"
        adb -H ${HOST} -P ${PORT} ${cmd}
    else
        #echo "adb ${cmd}"
        adb ${cmd}
    fi
}

main() {
}

main $@
