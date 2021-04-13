#!/bin/bash
#
#

set -e
set -u

repo_sync() {
    local repo_dir=$1
    cd ${repo_dir}
    repo sync -j 32 -c
}
