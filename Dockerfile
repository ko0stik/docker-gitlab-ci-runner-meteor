FROM node:0.10.41

MAINTAINER The Teknologist <teknologist@gmail.com>

RUN apt-get update \
  && apt-get upgrade -y \
	&& apt-get install -y --no-install-recommends \
		ca-certificates curl graphicsmagick openssh-client \
		numactl locales bzip2 build-essential python git libc6 libncurses5 libstdc++6 lib32z1 lib32stdc++6 \
		libcairo2-dev libjpeg-dev libpango1.0-dev libgif-dev build-essential g++ \
	&& rm -rf /var/lib/apt/lists/* && \
    apt-get autoremove -y && \
    apt-get clean

# Install java through webupd8 repository
RUN \
    echo "===> add webupd8 repository..."  && \
    echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee /etc/apt/sources.list.d/webupd8team-java.list  && \
    echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list  && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886  && \
    apt-get update  && \
    \
    \
    echo "===> install Java"  && \
    echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections  && \
    echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections  && \
    DEBIAN_FRONTEND=noninteractive  apt-get install -y --force-yes oracle-java8-installer  && \
    \
    \
    echo "===> clean up..."  && \
    rm -rf /var/cache/oracle-jdk8-installer  && \
    apt-get clean  && \
    rm -rf /var/lib/apt/lists/*



# Installs Android SDK
ENV ANDROID_SDK_FILENAME android-sdk_r24.4.1-linux.tgz
ENV ANDROID_SDK_URL http://dl.google.com/android/${ANDROID_SDK_FILENAME}
ENV ANDROID_SDK_ITEMS tools,platform-tools,build-tools-23.0.2,android-23
ENV ANDROID_EXTRA_SUPPORT extra-android-support
ENV ANDROID_EXTRA_M2REPO extra-google-m2repository
ENV GOOGLE_ITEMS addon-google_apis-google-23,extra-google-google_play_services
ENV ANDROID_HOME /opt/android-sdk-linux
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools
RUN cd /opt && \
    wget -q ${ANDROID_SDK_URL} && \
    tar -xzf ${ANDROID_SDK_FILENAME} && \
    rm ${ANDROID_SDK_FILENAME}  && \
     echo y | android update sdk --no-ui -a -t ${ANDROID_SDK_ITEMS} && \
     echo y | android update sdk --no-ui -a -t ${ANDROID_EXTRA_SUPPORT}  && \
     echo y | android update sdk --no-ui -a -t ${ANDROID_EXTRA_M2REPO}  && \
     echo y | android update sdk --no-ui -a -t ${GOOGLE_ITEMS}
#    android update sdk --no-ui -a --filter tools,platform-tools,${ANDROID_SDKS},${ANDROID_BUILD_TOOLS},extra,extra-android-m2repository
RUN curl https://install.meteor.com/ | sh

# upgrade NPM itself
RUN npm -g install npm@latest-2

RUN npm install -g velocity-cli gulp node-gyp

ENV JASMINE_BROWSER PhantomJS
ENV PORT 3000
ENV JASMINE_MIRROR_PORT 5000

# fix issue with MongoDB and missing locale
# https://github.com/meteor/meteor/issues/4019
RUN dpkg-reconfigure locales && \
    locale-gen C.UTF-8 && \
    /usr/sbin/update-locale LANG=C.UTF-8

ENV LC_ALL C.UTF-8

EXPOSE 5000
EXPOSE 3000
EXPOSE 3001
