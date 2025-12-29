#!/usr/bin/env bash

_log() {
  echo "[INFO] $1"
}

fetch_kernel_common() {
  BRANCH=$1
  GKI_ROOT=$(pwd)/gki-kernel
  local BRANCH GKI_ROOT

  _log "Target kernel branch: $BRANCH"

  if [ -d $GKI_ROOT/.repo ]; then
    _log "Kernel repo already exists, skipping repo init"
  else
    _log "Preparing workspace: $GKI_ROOT"
    mkdir $GKI_ROOT
    cd $GKI_ROOT

    _log "[1/2] repo init"
    repo init \
      --depth=1 \
      -u https://android.googlesource.com/kernel/manifest \
      -b $BRANCH

    _log "Pause 5s (network / auth sanity check)"
    sleep 5
  fi

  cd $GKI_ROOT

  _log "[2/2] repo sync (this may take a while)"
  repo sync \
    -c \
    -j"$(nproc)" \
    --no-tags \
    --fail-fast
}

fetch_kernel_common "$@"
