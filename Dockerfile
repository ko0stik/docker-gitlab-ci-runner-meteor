FROM node:0.10.41

MAINTAINER The Teknologist <teknologist@gmail.com>

RUN apt-get update \
  && apt-get upgrade -y \
	&& apt-get install -y --no-install-recommends \
		ca-certificates curl graphicsmagick openssh-client \
		numactl locales bzip2 build-essential python git libc6 libncurses5 libstdc++6 lib32z1 lib32stdc++6 \
		libcairo2-dev libjpeg-dev libpango1.0-dev libgif-dev build-essential g++ apt-transport-https ca-certificates \
	&& rm -rf /var/lib/apt/lists/* && \
    apt-get autoremove -y && \
    apt-get clean

RUN curl https://install.meteor.com/ | sh

# upgrade NPM itself
RUN npm -g install npm@latest-2

RUN npm install -g gulp node-gyp

# fix issue with MongoDB and missing locale
# https://github.com/meteor/meteor/issues/4019
RUN dpkg-reconfigure locales && \
    locale-gen C.UTF-8 && \
    /usr/sbin/update-locale LANG=C.UTF-8

ENV LC_ALL C.UTF-8

EXPOSE 5000
EXPOSE 3000
EXPOSE 3001
