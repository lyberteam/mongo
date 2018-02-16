## MONGO

 **image from debian:jessie**

## Tags
   v3.6 ([3.6/Dockerfile](https://github.com/lyberteam/mongo/tree/master/3.6))


## Using with docker-compose

    services:

        ## ...

        mongo:
            container_name: example_mongo
            image: lyberteam/mongo:3.6
            ports:
                - 27017:27017
            environment:
                MONGODB_DATABASE: example_db
                MONGODB_USER: example_user
                MONGODB_PASS: example_pass
                MONGODB_AUTH: yes
                MONGODB_STORAGE_ENGINE: wiredTiger
                LYBERTEAM_TIME_ZONE: Europe/Kiev
            working_dir: /data/db