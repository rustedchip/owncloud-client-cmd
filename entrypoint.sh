#!/bin/bash
OWNCLOUD_URL=${OWNCLOUD_URL}
OWNCLOUD_USERNAME=${OWNCLOUD_USERNAME}
OWNCLOUD_PASSWORD=${OWNCLOUD_PASSWORD}
REMOTE_SYNC_DIR=${REMOTE_SYNC_DIR}
EXCLUDE_PATTERNS=${OWNCLOUD_EXCLUDE}
SYNC_INTERVAL=${SYNC_INTERVAL}

# this-version-of-owncloud-needs-exclude-file

EXCLUDE_FILE="/tmp/exclude-list.txt"

create_exclude_file() {
    echo "Creating exclude list file at $EXCLUDE_FILE..."
    if [ -n "$EXCLUDE_PATTERNS" ]; then
        echo "$EXCLUDE_PATTERNS" | tr ',' '\n' > "$EXCLUDE_FILE"
        echo "exclude-file-created :: patterns :: "
        cat "$EXCLUDE_FILE"
    else
        touch "$EXCLUDE_FILE"
        echo "exclude-file-created :: no-patterns"
    fi
}

sync_files() {
    echo "running-owncloud-sync"
    if [ -f "$EXCLUDE_FILE" ]; then
        echo "using-exclude-file :: $EXCLUDE_FILE"
        owncloudcmd --non-interactive --user "$OWNCLOUD_USERNAME" --password "$OWNCLOUD_PASSWORD" --exclude "$EXCLUDE_FILE" /sync "$OWNCLOUD_URL$REMOTE_SYNC_DIR"
    else
        echo "exclude-file-not-found :: skipping-exclude-option"
        owncloudcmd --non-interactive --user "$OWNCLOUD_USERNAME" --password "$OWNCLOUD_PASSWORD" /sync "$OWNCLOUD_URL$REMOTE_SYNC_DIR"
    fi

    echo "[ sync-has-been-completed ]"
}

mkdir -p /sync

create_exclude_file

while true; do
    sync_files
    echo "waiting-$SYNC_INTERVAL-seconds-before-next-sync"
    sleep "$SYNC_INTERVAL"
done
