#!/bin/bash
#
#
set -e
set -u

repo_sync() {
    local repo_dir=$1
    cd ${repo_dir}
    shift
    if [ $# -eq 0 ]; then
        echo "sync all projects in dir ${repo_dir}"
        repo sync -j 32 -c
    else
        echo "sync projects [$@] in dir ${repo_dir}"
        repo sync -j 32 -c $@
    fi
}

