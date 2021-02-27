# !/bin/bash
#
#
CURRENT_DIR="$(cd "$(dirname "$BASH_SOURCE[0]")" && pwd)"
source ${CURRENT_DIR}/adb.conf

if [[ -n "${HOST}" && -n "${PORT}" ]]; then
    if [[ "$(uname)" == "Darwin" ]]; then
        gtimeout 5 adb -H "${HOST}" -P "${PORT}" shell echo "device connected"
    else
        timeout 5 adb -H "${HOST}" -P "${PORT}" shell echo "device connected"
    fi
    if [[ $? -ne 0 ]]; then
        echo "failed to connect to ${HOST}:${PORT}"
        exit 1
    fi
    alias adb="adb -H ${HOST} -P ${PORT}"
fi
