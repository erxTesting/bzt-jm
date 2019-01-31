# BlazeMeter Taurus and JMeter container
# See https://hub.docker.com/r/erxx/bzt-jm
# Taurus / JMeter only layered container	bzt-erx:v0.4.1 
# https://github.com/erxTesting/erx-bzt-container
# https://cloud.docker.com/u/erxx/repository/docker/erxx/bzt-jm

# Use phusion/baseimage as base image. To make your builds reproducible, make
# sure you lock down to a specific version, not to `latest`!
# See https://github.com/phusion/baseimage-docker/blob/master/Changelog.md for
# a list of version numbers.
# Build:	docker build -t bzt-erx:latest .
# Run:		docker run -t -i --rm bzt-erx:<VERSION> /sbin/my_init -- bash -l
FROM phusion/baseimage:0.11
# was FROM debian:latest

LABEL maintainer="Eric Berg ERX <perfology@gmail.com>"

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Install Python, Libs and Upgrade PIP
RUN apt-get update \
    && apt-get install -y wget python python-dev python-pip zip bzip2 file imagemagick libxml2-dev \
	    libxslt-dev make xz-utils zlib1g-dev unzip curl python-tk git xmlstarlet apt-utils \
    && pip install --upgrade pip \
    && update-ca-certificates -f \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Taurus and it's Tools #~ may be useful> && bzt -install-tools -v 
RUN pip install --upgrade bzt \
    && echo $'settings:\n  artifacts-dir: /var/log/jmeter/%Y-%m-%d_%H-%M-%S.%f' > ~/.bzt-rc \
    && rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/* 
# ADD bzt /root/.bzt

# Install Java and JMeter Libs and validate #~ may be useful> && apt-get -y install openjdk-$JAVA_VERSION-jdk 
ENV JAVA_VERSION=11 \
    JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64" \
    JDK_HOME="/usr/lib/jvm/java-11-openjdk-amd64" \
    JRE_HOME="/usr/lib/jvm/java-11-openjdk-amd64/jre" 
WORKDIR ~/.bzt/jmeter-taurus
COPY . .
RUN apt-get update \
    && apt-get -y install openjdk-11-jdk \
    && apt-get clean \
    && bzt jmeter_default.yaml \
	   -o execution.0.concurrency=1 \
	   -o execution.0.iterations=1 \
	   http://blazedemo.com/ \
    && ls -la /tmp && cat /tmp/jpgc-*.log && ls -la ~/.bzt/jmeter-taurus/*/lib/ext \
	&& ls -la ~/.bzt/jmeter-taurus/*/lib/ext/jmeter-plugins-tst-*.jar 

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
