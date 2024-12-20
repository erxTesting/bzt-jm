# BlazeMeter Taurus and JMeter container
# See https://hub.docker.com/r/erxx/bzt-jm
# Taurus / JMeter only layered container	bzt-erx:v0.4.2
# https://github.com/erxTesting/erx-bzt-container
# Reference https://github.com/Blazemeter/taurus
# https://cloud.docker.com/u/erxx/repository/docker/erxx/bzt-jm

# Use phusion/baseimage as base image. To make your builds reproducible, make
# sure you lock down to a specific version, not to `latest`!
# See https://github.com/phusion/baseimage-docker/blob/master/Changelog.md for
# a list of version numbers.
# Build:	docker build -t bzt-erx:latest .
# Run:		docker run -t -i --rm bzt-erx:<VERSION> /sbin/my_init -- bash -l
FROM phusion/baseimage:noble-1.0.0
# was FROM phusion/baseimage:0.11 
# was FROM debian:latest

LABEL maintainer="Eric Berg ERX <perfology@gmail.com>"

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Install Python, Libs and Upgrade PIP
RUN apt-get -y update \
    && apt-get -y install --no-install-recommends \
        python3-full python3-tk python3-pip python3-dev \
        libxml2-dev libxslt-dev zlib1g-dev net-tools wget \
        zip unzip bzip2 file imagemagick libxml2-dev libxslt-dev \
        make xz-utils zlib1g-dev  curl git xmlstarlet apt-utils \
    && apt-get install --reinstall python3.12-distutils \
    # && pip install --upgrade setuptools --break-system-packages \
    && update-ca-certificates -f \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Taurus and it's Tools #~ may be useful> && bzt -install-tools -v 
RUN pip install --upgrade bzt  --break-system-packages \
    && echo $'settings:\n  artifacts-dir: /var/log/jmeter/%Y-%m-%d_%H-%M-%S.%f' > ~/.bzt-rc \
    && rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/* 
# ADD bzt /root/.bzt

# Install Java and JMeter Libs and validate 
#~ may be useful> && apt-get -y install openjdk-$JAVA_VERSION-jdk , latest is 21
ENV JAVA_VERSION=11 \
    JAVA_HOME="/usr/lib/jvm/java-$JAVA_VERSION-openjdk-amd64" \
    JDK_HOME="/usr/lib/jvm/java-$JAVA_VERSION-openjdk-amd64" \
    JRE_HOME="/usr/lib/jvm/java-$JAVA_VERSION-openjdk-amd64/jre" 
WORKDIR ~/.bzt/jmeter-taurus
COPY . .
RUN apt-get update \
    && apt-get -y install openjdk-$JAVA_VERSION-jdk \
    && apt-get clean \
    && bzt jmeter-default.yaml \
	   -o execution.0.concurrency=1 \
	   -o execution.0.iterations=1 \
	   http://blazedemo.com/ \
    && ls -la /tmp && cat /tmp/jpgc-*.log && ls -la ~/.bzt/jmeter-taurus/*/lib/ext \
	&& ls -la ~/.bzt/jmeter-taurus/*/lib/ext/jmeter-plugins-tst-*.jar 

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
