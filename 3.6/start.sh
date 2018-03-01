#!/bin/bash
ADMIN_USER=${COMPOSE_MONGODB_ADMIN_NAME:-""}
ADMIN_PASS=${COMPOSE_MONGODB_ADMIN_PASS:-""}
USER=${COMPOSE_MONGODB_USER_NAME:-""}
PASS=${COMPOSE_MONGODB_USER_PASS:-""}
DATABASE=${COMPOSE_MONGODB_DATABASE:-""}
AUTH=${COMPOSE_MONGODB_AUTH:-"no"}
ENGINE=${COMPOSE_MONGODB_STORAGE_ENGINE:-"wiredTiger"}
TIMEZONE=${LYBERTEAM_TIME_ZONE:-"Europe/Kiev"}

add_user() {
if [ "$COMPOSE_MONGODB_ADMIN_NAME" != "" ]; then
    mongo admin --eval "db.createUser({user: '$ADMIN_USER', pwd: '$ADMIN_PASS', roles:[{role:'userAdminAnyDatabase',db:'admin'}]});"

    if [ "$DATABASE" != "admin" ]; then
        echo "---> Set  user: ${USER} with password: ${PASS}"
        mongo  admin -u $ADMIN_USER -p: $ADMIN_PASS --authenticationDatabase "admin" << EOF
use $DATABASE;
db.createUser({user: '$USER', pwd: '$USER', roles:[ { role: "readWrite", db: "$DATABASE" },
             { role: "read", db: "reporting" } ]});
EOF
    fi

    echo "---> User successfully added!"
    touch /data/db/.user_is_set
fi
}

if [ ! -e /data/db/.user_is_set ]; then
    add_user
fi

# Add default timezone
echo "$TIMEZONE" > /etc/timezone
dpkg-reconfigure -f noninteractive tzdata

set -m
COMMAND="mongod --bind_ip_all --storageEngine $ENGINE"

if [ "$AUTH" == "yes" ]; then
    COMMAND="$COMMAND --auth"
fi

$COMMAND