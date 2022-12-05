FROM ubuntu:18.04 AS yate-container

ENV NO_ARCH_OPT 1
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get -y install --no-install-suggests \
    build-essential libgsm1-dev libusb-1.0-0-dev autoconf subversion \
    wget nano apache2 php7.2 libbladerf-dev automake bladerf cmake \
    git doxygen kdoctools bash net-tools tcpdump\
    && \
    echo 'export PS1="[yate]$PS1"' >> ~/.bashrc

ENV TERM xterm

# gsmtap, doesn't work proper use 
# --pcap option of run_yate.sh
#EXPOSE 4729/udp

#apache
EXPOSE 80/tcp

ENV IS_DOCKER="1"

WORKDIR /usr/src/

ENTRYPOINT /bin/bash
