################################
#                              #
#     Debian - MongoDB v3.6    #
#                              #
################################
FROM testmongo:base

MAINTAINER Lyberteam <lyberteamltd@gmail.com>
LABEL Vendor="Lyberteam"
LABEL Description="MongoDB"
LABEL Version="1.1.0"

ENV LYBERTEAM_TIME_ZONE Europe/Kiev
ENV COMPOSE_MONGODB_STORAGE_ENGINE wiredTiger
ENV COMPOSE_MONGODB_AUTH no
ENV COMPOSE_MONGODB_ADMIN_NAME example_admin
ENV COMPOSE_MONGODB_ADMIN_PASS thispasswordnotsecure
ENV COMPOSE_MONGODB_USER_NAME test_user
ENV COMPOSE_MONGODB_USER_PASS test_user
ENV COMPOSE_MONGODB_DATABASE test_db

## https://docs.mongodb.com/manual/tutorial/install-mongodb-on-debian/

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2930ADAE8CAF5059EE73BB4B58712A2291FA4AD5 \
    &&  echo "deb http://repo.mongodb.org/apt/debian jessie/mongodb-org/3.6 main" \
        | tee /etc/apt/sources.list.d/mongodb-org-3.6.list

#RUN apt-get install -y mongodb-org
RUN apt-get update -yqq \
    &&  apt-get install -yqq \
        mongodb-org=3.6.2 \
        mongodb-org-server=3.6.2 \
        mongodb-org-shell=3.6.2 \
        mongodb-org-mongos=3.6.2 \
        mongodb-org-tools=3.6.2

VOLUME /data/db

RUN rm -rf /var/lib/apt/lists/* \
	&& rm -rf /tmp/* \
	&& apt-get clean -yqq

COPY run/* /
RUN chmod +x /run.sh

CMD ["/run.sh"]

WORKDIR /data/db

EXPOSE 27017