#!/bin/bash
#
#
set -e
set -u

FAILED_REPOS_FILE=failed-repos

repo_sync() {
    local repo_dir=$1
    cd ${repo_dir}
    shift
    if [ $# -eq 0 ]; then
        echo "sync all projects in dir ${repo_dir}"
        repo sync -j 32 -c 2>&1 >/dev/null | grep "Failing repos" > $FAILED_REPOS_FILE
    else
        echo "sync projects [$@] in dir ${repo_dir}"
        repo sync -j 32 -c $@ 2>&1 >/dev/null | grep "Failing repos" > $FAILED_REPOS_FILE
    fi
    sed -i '1d' $FAILED_REPOS_FILE
    echo "Total $(wc -l $FAILED_REPOS_FILE | awk '{print $1;}') failing repos:"
    while read project
    do
        show_project ${repo_dir} ${project}
    done < $FAILED_REPOS_FILE
}

show_project() {
    local repo_dir=$1
    cd ${repo_dir}
    shift
    repo list $@
}

