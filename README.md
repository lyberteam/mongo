## MONGO

 **image from debian:jessie**

## Tags
   tag - 3.6 ( [3.6/Dockerfile](https://github.com/lyberteam/mongo/tree/master/3.6) )


## Using with docker-compose

    services:

        ## ...

        mongo:
            container_name: example_mongo
            image: lyberteam/mongo:3.6
            ports:
                - 27018:27017
            environment:
                COMPOSE_MONGODB_ADMIN_NAME: 'admin_user'
                COMPOSE_MONGODB_ADMIN_PASS: 'admin_pass'
                COMPOSE_MONGODB_USER_NAME: 'user'
                COMPOSE_MONGODB_USER_PASS: 'pass'
                COMPOSE_MONGODB_DATABASE: 'example_db'
                COMPOSE_MONGODB_AUTH: 'yes'
                COMPOSE_MONGODB_STORAGE_ENGINE: 'wiredTiger'
                LYBERTEAM_TIME_ZONE: 'Europe/Kiev'
            working_dir: /data/db
            volumes:
                - ./mongo_files/db:/data/db
                - ./mongo_files/configdb:/data/configdb
            command: ["/run.sh"]
