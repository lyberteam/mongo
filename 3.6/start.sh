#!/bin/bash
USER=${COMPOSE_MONGODB_NAME:-"admin"}
DATABASE=${COMPOSE_MONGODB_DATABASE:-"admin"}
PASS=${COMPOSE_MONGODB_PASS:-"admin"}
AUTH=${COMPOSE_MONGODB_AUTH:-"yes"}
ENGINE=${COMPOSE_MONGODB_STORAGE_ENGINE:-"wiredTiger"}
TIMEZONE=${LYBERTEAM_TIME_ZONE:-"Europe/Kiev"}

add_user() {
    echo "---> Set  user: ${USER} with password: ${PASS}"
    mongo admin --eval "db.createUser({user: '$USER', pwd: '$PASS', roles:[{role:'root',db:'admin'}]});"

if [ "$DATABASE" != "admin" ]; then
    echo "---> Set  user: ${USER} with password: ${PASS}"
    mongo admin -u $USER -p $PASS << EOF
use $DATABASE
db.createUser({user: '$USER', pwd: '$PASS', roles:[{role:'dbOwner',db:'$DATABASE'}]})
EOF
fi

    echo "---> User successfully added!"
    touch /data/db/.user_is_set
}

# Add default timezone
echo "$TIMEZONE" > /etc/timezone
echo "date.timezone=$TIMEZONE" > /etc/php/7.0/cli/conf.d/timezone.ini
dpkg-reconfigure -f noninteractive tzdata

set -m

COMMAND="mongod --storageEngine $ENGINE  --master"

if [ "$AUTH" == "yes" ]; then
    COMMAND="$COMMAND --auth"
fi

$COMMAND

if [ ! -f /data/db/.user_is_set ]; then
    add_user
fi