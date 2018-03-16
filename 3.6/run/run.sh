#!/bin/bash

AUTH=${COMPOSE_MONGODB_AUTH:-"yes"}
ENGINE=${COMPOSE_MONGODB_STORAGE_ENGINE:-"wiredTiger"}
TIMEZONE=${LYBERTEAM_TIME_ZONE:-"Europe/Kiev"}

# Add default timezone
echo "$TIMEZONE" > /etc/timezone
dpkg-reconfigure -f noninteractive tzdata

set -m ## Enable job control

COMMAND="mongod --bind_ip_all --master --storageEngine $ENGINE"
if [ "$AUTH" == "yes" ]; then
    COMMAND="$COMMAND --auth"
fi
echo "---> Starting! ------------------------------" >> /data/db/install_log.txt
$COMMAND &

if [ ! -f /data/db/.user_is_set ]; then
    if [ ! -f /data/db/.admin_is_set ]; then
        /set_admin.sh
    fi

    /set_user.sh
fi

fg ## Bring command to foreground