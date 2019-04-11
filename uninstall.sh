#!/bin/bash

set -o errexit
set -o nounset

GO_ROOT='/usr/local/go'
ZSHRC_FILE="$HOME/.zshrc"

echo_stderr() {
  (>&2 echo $@)
}

run_as_root() {
  if [ "$UID" -ne 0 ]
  then
    sudo "$@"
  else
    "$@"
  fi
  return $?
}

remove_go_installation() {
  if [ -d $1 ]
  then
    run_as_root rm -rf $1
  fi
}

backup_file() {
  if [ -f $1 ]
  then
    cp $1 "$1.bak"
  fi
}

clean_up_environment() {
  # this assumes zsh for now
  if [ -f $1 ]
  then
    sed --in-place '/# Golang configuration -- created by golang install.sh/d' $1
    sed --in-place '/export GOROOT=\/usr\/local\/go/d' $1
    sed --in-place '/export GOPATH=\$HOME\/go/d' $1
    sed --in-place '/export PATH=\$PATH\:\$GOROOT\/bin/d' $1
  fi
  return 0
}

# 1. remove go installation folder
remove_go_installation $GO_ROOT
if [ $? -eq 0 ]
then
  echo "Removed go installation from $GO_ROOT"
fi

# 2. clean up environment
backup_file $ZSHRC_FILE
if [ $? -eq 0 ]
then
  echo "Backed up $ZSHRC_FILE to $ZSHRC_FILE.bak"
else
  echo_stderr "Unable to backup $ZSHRC_FILE! Exiting..."
  exit 1
fi

clean_up_environment $ZSHRC_FILE
if [ $? -eq 0 ]
then
  echo "Removed go environment configuration from $ZSHRC_FILE"
fi

echo ""
echo "Removed Golang from your system"
