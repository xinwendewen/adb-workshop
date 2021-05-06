#!/bin/bash
#
#
set -e
set -u

repo_sync() {
    local root_dir=$1
    if [[ ! -d "$root_dir" ]];
    then
        echo "$root_dir is not a directory"
        return 1
    fi
    cd ${root_dir}
    shift
    if [[ -z "$*" ]];
    then
        echo "sync all projects in $root_dir"
        #echo "repo sync"
        repo sync
    else
        echo "sync projects:[$*] in $root_dir"
        #echo "repo sync $*"
        repo sync "$*"
    fi
}

show_project() {
    local repo_dir=$1
    cd ${repo_dir}
    shift
    repo list $@
}
