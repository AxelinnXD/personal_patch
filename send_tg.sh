#!/bin/bash

# send_tg.sh - Telegram Notification Script
# Usage: bash send_tg.sh <bot_token> <chat_id> <message> [parse_mode] [disable_preview]

BOT_TOKEN="$1"
CHAT_ID="$2"
MESSAGE="$3"
PARSE_MODE="${4:-Markdown}"
DISABLE_WEB_PREVIEW="${5:-true}"

if [ -z "$BOT_TOKEN" ] || [ -z "$CHAT_ID" ] || [ -z "$MESSAGE" ]; then
    echo "Error: Missing required parameters"
    echo "Usage: $0 <bot_token> <chat_id> <message> [parse_mode] [disable_preview]"
    exit 1
fi

curl -s -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" \
    -d chat_id="${CHAT_ID}" \
    -d text="${MESSAGE}" \
    -d parse_mode="${PARSE_MODE}" \
    -d disable_web_page_preview="${DISABLE_WEB_PREVIEW}" \
    > /dev/null

if [ $? -eq 0 ]; then
    echo "Telegram notification sent"
else
    echo "Failed to send Telegram notification"
    exit 1
fi
