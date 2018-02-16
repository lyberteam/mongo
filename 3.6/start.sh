#!/bin/bash
USER=${MONGODB_USER:-"admin"}
DATABASE=${MONGODB_DATABASE:-"admin"}
PASS=${MONGODB_PASS:-"admin"}
AUTH=${MONGODB_AUTH:-"yes"}

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
echo "$LYBERTEAM_TIME_ZONE" > /etc/timezone
echo "date.timezone=$LYBERTEAM_TIME_ZONE" > /etc/php/7.0/cli/conf.d/timezone.ini
dpkg-reconfigure -f noninteractive tzdata

set -m

COMMAND="mongod --storageEngine $MONGODB_STORAGE_ENGINE --httpinterface --rest --master"

if [ "$AUTH" == "yes" ]; then
    COMMAND="$COMMAND --auth"
fi

$COMMAND

if [ ! -f /data/db/.user_is_set ]; then
    add_user
fi