#!/usr/bin/env bash
default_branch='master'
repo_dir="$(dirname $0)/.."

# repo_dir=$(git rev-parse --show-toplevel)
. "${repo_dir}/scripts/functions"

diff_commits_number=$(git log origin/$default_branch..$1 --pretty=oneline | wc -l)
echo "Checking for files in the last $diff_commits_number commits"
changedfiles=$(git diff HEAD~$diff_commits_number --name-only | grep 'data/');

apps=$(echo "$changedfiles" | cut -d '/' -f 2 | sort | uniq)

for app in $apps; do
  echo_title "Testing $app"
  tp install $app
  tp test $app
  if [ "x$?" == "x0" ]; then
    result='success'
  else
    result='failure'
  fi
  echo_$result "## ${result}! ## Output written to tests/app/$2/${result}/$1"

done
