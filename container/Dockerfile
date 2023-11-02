FROM ubuntu:20.04 AS bts-container

ENV NO_ARCH_OPT 1
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get -y install --no-install-suggests \
    build-essential libgsm1-dev libusb-1.0-0-dev autoconf \
    wget nano apache2 libbladerf-dev automake bladerf cmake php libapache2-mod-php \
    git doxygen bash net-tools tcpdump iproute2 telnet libqt5multimediawidgets5 libqt5multimedia5-plugins \
    libboost-system-dev libboost-test-dev libboost-thread-dev libqwt-qt5-dev qtbase5-dev qtmultimedia5-dev \
    cmake make gcc g++ pkg-config libfftw3-dev libmbedtls-dev libsctp-dev libyaml-cpp-dev libgtest-dev \
    libboost-program-options-dev libconfig++-dev libsctp-dev gnuradio libpcsclite-dev libdw-dev \
    && \
    echo 'export PS1="[bts]$PS1"' >> ~/.bashrc

ENV TERM xterm

# gsmtap, doesn't work proper use 
# --pcap option of run_yate.sh
#EXPOSE 4729/udp

#apache
EXPOSE 80/tcp

ENV IS_DOCKER="1"

WORKDIR /usr/src/

ENTRYPOINT /bin/bash
