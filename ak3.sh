#!/usr/bin/env bash

echo "Fetching AnyKernel"

AK_BRANCH=$1
AK_DIR=$2

[ -z $AK_BRANCH ] && AK_BRANCH=gki
[ -z $AK_DIR ] && AK_DIR=ak

if [ ! -d "$AK_DIR" ]; then
  git clone --depth=1 --single-branch -b $AK_BRANCH \
    https://github.com/rufnx/anykernel.git $AK_DIR
  echo "AnyKernel cloned ($AK_BRANCH)"
else
  cd $AK_DIR
  git fetch origin $AK_BRANCH
  git reset --hard origin/$AK_BRANCH
  cd ..
  echo "AnyKernel updated ($AK_BRANCH)"
fi
