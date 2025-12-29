#!/usr/bin/env bash

set -e

_log() {
  echo "[INFO] $1"
}

send() {
  local FILE=$1
  local DATE
  local LINK=""
  local kernelver=""
  local response=""

  DATE=$(date -u "+%Y-%m-%d %H:%M:%S UTC")

  [ -z ${BOT_TOKEN:-} ] && { echo "BOT_TOKEN not set"; exit 1; }
  [ -z ${CHAT_ID:-} ] && { echo "CHAT_ID not set"; exit 1; }

  if [ ! -f "$FILE" ]; then
    _log "File not found: $FILE"
    exit 1
  fi

  for server in store1 store2 store3 store4; do
    _log "Uploading to $server.gofile.io ..."
    response=$(curl -fsSL -F "file=@$FILE" \
      "https://$server.gofile.io/contents/uploadfile" || true)

    LINK=$(echo "$response" | grep -oP '"downloadPage"\s*:\s*"\K[^"]+')

    if [ -n "$LINK" ]; then
      _log "Upload success on $server"
      break
    fi
  done

  [ -z "$LINK" ] && LINK="Upload failed"

  if [ -f Image.gz ]; then
    kernelver=$(zcat Image.gz | strings | grep "Linux version" || true)
  elif [ -f Image ]; then
    kernelver=$(strings Image | grep "Linux version" || true)
  else
    kernelver="Kernel image not found"
  fi

  caption="*Build Success*
\`\`\`
$kernelver
\`\`\`
*Date:* $DATE
*Download:* $LINK"

  curl -fsSL -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" \
    -F chat_id="$CHAT_ID" \
    -F parse_mode=Markdown \
    -F text="$caption"

  _log "Done. Message sent."
}

send "$@"
