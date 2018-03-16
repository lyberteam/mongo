#!/usr/bin/env bash

ADMIN_USER=${COMPOSE_MONGODB_ADMIN_NAME:-"example_admin"}
ADMIN_PASS=${COMPOSE_MONGODB_ADMIN_PASS:-"thispasswordnotsecure"}
USER=${COMPOSE_MONGODB_USER_NAME:-"test"}
PASS=${COMPOSE_MONGODB_USER_PASS:-"test"}
DATABASE=${COMPOSE_MONGODB_DATABASE:-"test_db"}

mongo_response=1
while [[ mongo_response -ne 0 ]]; do
    echo "---> Check whether MONGO has been started" >> /data/db/install_log.txt
    sleep 2
    mongo admin --eval "help" >/dev/null 2>&1
    mongo_response=$?
done

add_user() {
    if [ "$DATABASE" != "admin" ] && [ "$USER" != "test" ] ; then
        sleep 2;

        echo "---> Set  user: ${USER} with password: ${PASS}" >> /data/db/install_log.txt

mongo admin -u $ADMIN_USER -p $ADMIN_PASS << EOF
 use $DATABASE;
 db.createUser({
     user: "$USER",
     pwd: "$PASS",
     roles:[
         {
             role: "dbOwner",
             db: "$DATABASE"
         }, {
             role: "read",
             db: "reporting"
         }
     ]
 });
EOF

        echo "---> User $USER has been successfully added!" >> /data/db/install_log.txt
        touch /data/db/.user_is_set
        echo $USER >> /data/db/.user_is_set
    fi
}

add_user