#!/usr/bin/env bash

# Wait for a short period to ensure the session is fully initialized
sleep 1

# Maximum number of retries
MAX_RETRIES=5
retry_count=0

while [ $retry_count -lt $MAX_RETRIES ]; do
    if ! pgrep -x "waybar" > /dev/null; then
        echo "Starting Waybar..."
        waybar &
    else
        echo "Waybar is already running"
        exit 0
    fi
    
    sleep 1
    retry_count=$((retry_count + 1))
done

echo "Failed to start Waybar after $MAX_RETRIES attempts"
exit 1
