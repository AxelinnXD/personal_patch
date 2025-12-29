#!/usr/bin/env bash

_log() {
  echo "$1"
}

_log "Fetching AnyKernel"

AK_BRANCH=$1
AK_DIR=$2

[ -z $AK_BRANCH ] && AK_BRANCH=gki
[ -z $AK_DIR ] && AK_DIR=$(pwd)/AK

if [ ! -d "$AK_DIR" ]; then
  git clone --depth=1 --single-branch -b $AK_BRANCH \
    https://github.com/rufnx/anykernel.git $AK_DIR
  _log "AnyKernel cloned ($AK_BRANCH)"
  cd $AK_DIR
else
  cd $AK_DIR
  git fetch origin $AK_BRANCH
  git reset --hard origin/$AK_BRANCH
  _log "AnyKernel updated ($AK_BRANCH)"
fi
