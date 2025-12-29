#!/usr/bin/env bash

set -euo pipefail

_log() {
  echo "[INFO] $*"
}

_warn() {
  echo "[WARN] $*" >&2
}

_err() {
  echo "[ERROR] $*" >&2
  exit 1
}

fetch_kernel_common() {
  local BRANCH="${1:-common-android12-5.10}"
  local WORKDIR="gki-kernel"

  _log "Target kernel branch: $BRANCH"

  if [ -d "$WORKDIR/.repo" ]; then
    _warn "Kernel repo already exists, skipping repo init"
  else
    _log "Preparing workspace: $WORKDIR"
    mkdir -p "$WORKDIR"
    cd "$WORKDIR"

    _log "[1/2] repo init"
    repo init \
      --depth=1 \
      -u https://android.googlesource.com/kernel/manifest \
      -b "$BRANCH"

    _log "Pause 5s (network / auth sanity check)"
    sleep 5
  fi

  cd "$WORKDIR"

  _log "[2/2] repo sync (this may take a while)"
  repo sync \
    -c \
    -j"$(nproc)" \
    --no-tags \
    --fail-fast
}

fetch_kernel_common "$@"
