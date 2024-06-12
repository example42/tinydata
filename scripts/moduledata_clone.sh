#!/bin/bash
name=$2
module=$1

showhelp () {
cat << EOF
Use this script to generate tinydata for a new app.

Use existing or sample data as a template to create a new tinydata dir:
$0 sample
Clone default sample data (data/sample) in a new app whose name is requested

$0 sample_command vim
Clone sample_command data (data/sample_command) into a data dir called vim (data/vim)

$0 sample_app discord
Clone sample_app data (for GUI apps) into a data dir called discord (data/discord)

$0 sample_repo hashicorp_repo
Clone sample_repo data (data/sample_repo) into a data dir called vim (data/hashicorp_repo)

EOF
}

showhelp

clone_from_module() {
  if [ ! -f data/$module/hiera.yaml ] ; then
    echo "I don't find data/$module/hiera.yaml "
    echo "Run this script from the base tinydata directory and specify a valid source moduledata"
    exit 1
  fi

  OLDMODULE=$module
  OLDMODULESTRING=$module

  clone
}

function clone() {
  echo
  if [ x$name == 'x' ] ; then
    echo -n "Enter the name of the new module data to create:"
    read NEWMODULE
  else
    NEWMODULE=$name
  fi
  
  if [ -f data/$NEWMODULE/hiera.yaml ] ; then
    echo "Data for $NEWMODULE already exists."
    echo "Move or delete it if you want to recreate it. Quitting."
    exit 1
  fi
  
  echo "COPYING MODULE"
  mkdir data/$NEWMODULE
  rsync -av --exclude=".git" --exclude "spec/fixtures" data/$OLDMODULE/ data/$NEWMODULE


  echo "---------------------------------------------------"
  echo "CHANGING FILE CONTENTS"
  for file in $( grep -R $OLDMODULESTRING data/$NEWMODULE | cut -d ":" -f 1 | uniq ) ; do
    # Detect OS
    if [ -f /System/Library/Accessibility/AccessibilityDefinitions.plist ] ; then
#    if [ -f /mach_kernel ] ; then
      sed -i "" -e "s/$OLDMODULESTRING/$NEWMODULE/g" $file && echo "Changed $file"
    else
      sed -i "s/$OLDMODULESTRING/$NEWMODULE/g" $file && echo "Changed $file"
    fi

  done

  echo "Data for $NEWMODULE created"
  echo "Start to edit the files in data/$NEWMODULE/ to customize it"

}

clone_from_module

