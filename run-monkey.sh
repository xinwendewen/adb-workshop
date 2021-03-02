#!/bin/bash
#
#
CURRENT_DIR="$(cd "$(dirname "$BASH_SOURCE[0]")" && pwd)"

readonly DROPBOX_PATH="/data/system/dropbox"
readonly ANR_PATH="/data/anr"
readonly TOMBSTOMES_PATH="/data/tombstones"

readonly MONKEY_LOG_PATH="${CURRENT_DIR}/monkey_logs"

shopt -s expand_aliases
source ${CURRENT_DIR}/env-setup.sh
source ${CURRENT_DIR}/adb-functions.sh

yse_or_no() {
    local propmt="$1"
    read -p "${propmt} (n/y) " -t 5
    if [[ "${REPLY}" = "y" ]]; then
        return
    fi
    false
}

run_monkey() {
    echo "Welcome to the monkey runner, here are some questions:"
    if yse_or_no "Need to clear ${DROPBOX_PATH}?"; then
        clear_dir "${DROPBOX_PATH}"
    fi
    if yse_or_no "Need to clear ${ANR_PATH}?"; then
        clear_dir "${ANR_PATH}"
    fi
    if yse_or_no "Need to clear ${TOMBSTOMES_PATH}?"; then
        clear_dir "${TOMBSTOMES_PATH}"
    fi
    local monkey_options="-v -v"
    if yse_or_no "Ignore crashes?" ; then
        monkey_options="${monkey_options} --ignore-crashes"
    fi
    if yse_or_no "Ignore timeout?" ; then
        monkey_options="${monkey_options} --ignore-timeouts"
    fi
    read -p "event interval(ms):" -t 5 throttle
    if [[ -n "${throttle}" ]]; then
        monkey_options="${monkey_options} --throttle ${throttle}"
    fi
    read -p "input target packages: " -a packages
    for package in ${packages[@]}
    do
        monkey_options="${monkey_options} -p ${package}"
    done
    read -p "event count: " count
    if [[ -z "${count}" ]]; then
        echo "no input event count"
        return 1
    fi
    echo "Here is the monkey command:"
    echo "adb shell monkey ${monkey_options} ${count}"
    local suffix="$(date "+%y-%m-%d_%H-%M")"
    local log_file="${MONKEY_LOG_PATH}/monkey-${suffix}.log"
    read -p "Run the command right now? (n/y)"
    if [[ "${REPLY}" = "y" ]]; then
        if [[ ! -d "${MONKEY_LOG_PATH}" ]]; then
            mkdir -p "${MONKEY_LOG_PATH}"
        fi
        adb shell monkey ${monkey_options} ${count} 2>&1 | tee ${log_file}
    fi

    cd "${MONKEY_LOG_PATH}"
    adb pull "${DROPBOX_PATH}"
    adb pull "${ANR_PATH}"
    adb pull "${TOMBSTOMES_PATH}"
}

main() {
    run_monkey
}

main
