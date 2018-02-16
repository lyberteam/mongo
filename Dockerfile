################################
#                              #
#     Debian - MongoDB v3.6    #
#                              #
################################
FROM debian:jessie

MAINTAINER Lyberteam <lyberteamltd@gmail.com>
LABEL Vendor="Lyberteam"
LABEL Description="MongoDB v3.6"
LABEL Version="1.0.0"

ENV LYBERTEAM_TIME_ZONE Europe/Kiev
ENV AUTH yes
ENV STORAGE_ENGINE wiredTiger
ENV JOURNALING yes

# https://docs.mongodb.com/manual/tutorial/install-mongodb-on-debian/

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2930ADAE8CAF5059EE73BB4B58712A2291FA4AD5 \
    &&  echo "deb http://repo.mongodb.org/apt/debian jessie/mongodb-org/3.6 main" \
        | sudo tee /etc/apt/sources.list.d/mongodb-org-3.6.list

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

COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]

WORKDIR /var/www/lyberteam

EXPOSE 27017