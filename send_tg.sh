#!/usr/bin/env bash

MESSAGE=$1

if [ -z "$BOT_TOKEN" ] || [ -z "$CHAT_ID" ] || [ -z "$MESSAGE" ]; then
    echo "Error: Missing required parameters"
    echo "Usage: $0 <bot_token> <chat_id> <message>"
    exit 1
fi

curl -s -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" \
    -d chat_id="${CHAT_ID}" \
    -d text="${MESSAGE}" \
    -d parse_mode="HTML" \
    -d disable_web_page_preview="true" \
    > /dev/null

if [ $? -eq 0 ]; then
    echo "Telegram notification sent"
else
    echo "Failed to send Telegram notification"
    exit 1
fi
