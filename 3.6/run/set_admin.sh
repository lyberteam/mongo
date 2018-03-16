#!/usr/bin/env bash

ADMIN_USER=${COMPOSE_MONGODB_ADMIN_NAME:-"example_admin"}
ADMIN_PASS=${COMPOSE_MONGODB_ADMIN_PASS:-"thispasswordnotsecure"}

mongo_response=1
while [[ mongo_response -ne 0 ]]; do
    echo "---> Check whether MONGO has been started" >> /data/db/install_log.txt
    sleep 2
    mongo admin --eval "help" >/dev/null 2>&1
    mongo_response=$?
done

add_admin() {
    if [ "$ADMIN_USER" != "example_admin" ]; then
        echo "---> Trying to install admin user" >> /data/db/install_log.txt
        mongo admin << EOF
use admin;
db.createUser({
    user: '$ADMIN_USER',
    pwd: '$ADMIN_PASS',
    roles:[
        {
            role: 'userAdminAnyDatabase',
            db: 'admin'
        }, {
            role: 'clusterAdmin',
            db: 'admin'
        }, {
            role: 'readWriteAnyDatabase',
            db: 'admin'
        }, {
            role: 'dbAdminAnyDatabase',
            db: 'admin'
        }
    ]
});
EOF
        echo "---> Admin successfully added!" >> /data/db/install_log.txt
        touch /data/db/.admin_is_set
        echo $ADMIN_USER >> /data/db/.admin_is_set
    fi
}

add_admin