# owncloud-client-cmd 

A lightweight Dockerized OwnCloud client that uses `owncloudcmd` to sync files between your server and an OwnCloud instance that works with latest version of ownCloud.  

### ⚙️ Configuration  

| Environment Variable  | Description                     |
|----------------------|---------------------------------|
| `OWNCLOUD_URL`      | OwnCloud server URL             |
| `OWNCLOUD_USERNAME` | Username for authentication     |
| `OWNCLOUD_PASSWORD` | Password for authentication (If Two-factor Authentication is Enabled use/create App passwords)     |
| `REMOTE_SYNC_DIR`   | Remote directory to sync        |
| `SYNC_INTERVAL`     | Sync interval in seconds        |
| `OWNCLOUD_EXCLUDE`  | Files/directories to exclude  (Required for latest version of ownCloud)  |


