#!/usr/bin/env bash
default_branch='master'
repo_dir="$(dirname "${0}")/.."

# repo_dir=$(git rev-parse --show-toplevel)
. "${repo_dir}/scripts/functions"

# Detecting apps for which we have changes in the PR
#diff_commits_number=$(git log $default_branch.."${1}" --pretty=oneline | wc -l)
#echo "Checking for files in the last $diff_commits_number commits"
#changedfiles=$(git diff HEAD~"${diff_commits_number}" --name-only | grep 'data/');
changedfiles=$(git --no-pager diff --name-only FETCH_HEAD $(git merge-base FETCH_HEAD $default_branch))

apps=$(echo "$changedfiles" | grep '^data' | cut -d '/' -f 2 | sort | uniq)

for app in $apps; do
  echo_title "Testing $app"
  tp install "${app}"
  
  if tp test "${app}"; then
    result='success'
  else
    result='failure'
  fi
  echo_$result "## ${result}!"

  tp info "${app}"
  tp version "${app}"

done

