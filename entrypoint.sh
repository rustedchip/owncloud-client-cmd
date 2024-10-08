#!/bin/bash

# Environment variables
OWNCLOUD_URL=${OWNCLOUD_URL}
OWNCLOUD_USERNAME=${OWNCLOUD_USERNAME}
OWNCLOUD_PASSWORD=${OWNCLOUD_PASSWORD}
LOCAL_SYNC_DIR=${LOCAL_SYNC_DIR}
REMOTE_SYNC_DIR=${REMOTE_SYNC_DIR}
EXCLUDE_PATTERNS=${OWNCLOUD_EXCLUDE}
SYNC_INTERVAL=${SYNC_INTERVAL}

# Path to the exclude list
EXCLUDE_FILE="/tmp/exclude-list.txt"

# Function to create the exclude file
create_exclude_file() {
    echo "Creating exclude list file at $EXCLUDE_FILE..."
    if [ -n "$EXCLUDE_PATTERNS" ]; then
        echo "$EXCLUDE_PATTERNS" | tr ',' '\n' > "$EXCLUDE_FILE"
        echo "Exclude file created with the following patterns:"
        cat "$EXCLUDE_FILE"
    else
        # Create an empty exclude list file
        touch "$EXCLUDE_FILE"
        echo "Exclude file created but is empty (no patterns to exclude)."
    fi
}

# Function to perform one-time sync with ownCloud
sync_files() {
    echo "Running ownCloud sync..."

    # Check if exclude file exists and use it
    if [ -f "$EXCLUDE_FILE" ]; then
        echo "Using exclude file: $EXCLUDE_FILE"
        owncloudcmd --user "$OWNCLOUD_USERNAME" --password "$OWNCLOUD_PASSWORD" --exclude "$EXCLUDE_FILE" "$LOCAL_SYNC_DIR" "$OWNCLOUD_URL$REMOTE_SYNC_DIR"
    else
        echo "Exclude file not found. Skipping --exclude option."
        owncloudcmd --user "$OWNCLOUD_USERNAME" --password "$OWNCLOUD_PASSWORD" "$LOCAL_SYNC_DIR" "$OWNCLOUD_URL$REMOTE_SYNC_DIR"
    fi

    echo "Sync complete."
}

# Ensure the sync directory exists
mkdir -p "$LOCAL_SYNC_DIR"

# Create exclude file
create_exclude_file

# Run the sync every X seconds
while true; do
    sync_files
    echo "Waiting $SYNC_INTERVAL seconds before next sync..."
    sleep "$SYNC_INTERVAL"
done
