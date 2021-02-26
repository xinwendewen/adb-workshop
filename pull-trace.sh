#!/bin/bash
#
#
set -u
set -e

main() {
    local package="$1"
    local trace_name="$2"
    local trace_file="${trace_name}.trace"
    adb pull /storage/emulated/0/Android/data/${package}/files/${trace_file}
}

main $1 $2
