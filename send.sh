#!/usr/bin/env bash

_log() {
  echo
}

send() {

BOT_TOKEN=$BOT_TOKEN
CHAT_ID=$CHAT_ID
DATE=$(date -u "+%Y-%m-%d %H:%M:%S UTC")
FILE=$1
local BOT_TOKEN CHAT_ID DATE FILE LINK kernelver

if [ ! -f "$FILE" ]; then
  _log "File not found: $FILE"
  exit 1
fi

LINK=""

for server in store1 store2 store3 store4; do
  _log "Uploading to $server.gofile.io ..."
  response=$(curl -s -F "file=@$FILE" "https://$server.gofile.io/contents/uploadfile")

  LINK=$(_log "$response" | grep -oP '"downloadPage"\s*:\s*"\K[^"]+')

  if [ -n "$LINK" ]; then
    _log "Upload success on $server"
    break
  fi
done

if [ -z "$LINK" ]; then
  LINK="Upload failed"
fi

if [ -f Image.gz ]; then
  kernelver=$(zcat Image.gz | strings | grep "Linux version")
elif [ -f Image ]; then
  kernelver=$(strings Image | grep "Linux version")
else
  kernelver="Kernel image not found"
fi

# ===== CAPTION (Markdown) =====
caption="*Build Success* 
\`\`\`
$kernelver
\`\`\`
*Date:* $DATE
*Download:* $LINK"

curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendDocument" \
  -F chat_id="$CHAT_ID" \
  -F parse_mode=Markdown \
  -F caption="$caption"

echo "Done. Sent to Telegram."
}

send $@
