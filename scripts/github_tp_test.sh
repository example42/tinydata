#!/usr/bin/env bash
changedfiles="${1}"
repo_dir="$(dirname "${0}")/.."
. "${repo_dir}/scripts/functions"
outputfile="${repo_dir}/results.txt"

PATH:"$PATH":/usr/local/bin

# Detecting apps for which we have changes in the PR
#default_branch='master'
#diff_commits_number=$(git log $default_branch.."${1}" --pretty=oneline | wc -l)
#echo "Checking for files in the last $diff_commits_number commits"
#changedfiles=$(git diff HEAD~"${diff_commits_number}" --name-only | grep 'data/');
#changedfiles=$(git --no-pager diff --name-only FETCH_HEAD $(git merge-base FETCH_HEAD origin/$default_branch))

apps=$(for a in $changedfiles ; do echo "$a" ; done | grep '^data' | cut -d '/' -f 2 | sort | uniq)
exitcode='0'

for app in $apps; do

  echo_title "### Checking ${app}"
  tp install "${app}" | tee -a "$outputfile" || true
  if tp test "${app}"; then
    result='success'
  else
    result='failure'
    exitcode='1'
  fi
  echo_$result "### ${app} test: ${result}!"
  echo
  echo_title "### ${app} info"
  tp info "${app}"
  echo
  echo_title "### ${app} version"
  tp version "${app}"
  echo
  echo_title "### ${app} uninstall"
  tp uninstall "${app}" || true
  echo

done
exit 0
