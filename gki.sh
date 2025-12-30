#!/usr/bin/env bash

# variabel dir
KERNEL_ROOT=$(pwd)
GKI_DIR=$KERNEL_ROOT/gki-kernel

cd $KERNEL_ROOT
mkdir $GKI_DIR
cd $GKI_DIR

# Prompt for branch name
echo "Enter the branch name: "
read FORMATTED_BRANCH

# Initialize Kernel Source
repo init --depth=1 -u https://android.googlesource.com/kernel/manifest -b $FORMATTED_BRANCH

# Download Kernel Source
repo --trace sync -c -j$(nproc --all) --no-tags --fail-fast
