#!/bin/bash
# Alexander Pick 2022-2023
# Mail: contact@alexander-pick.com

# init and update submodules
git submodule update --init --recursive
git pull --recurse-submodules --jobs=10

# clean old stuff
docker stop bts-local
docker rm bts-local
docker image rm bts-local-image

# build a generic image with all needed packages needed inside
docker build -t bts-local-image ./container/ 

# create a container from image and add our buildroot on host to it,
# we pass all /dev to it, yes this is insecure and stuff but we build
# an enviorment dealing with hardware
docker run --privileged \
    -v /dev:/dev \
    -v $(pwd)/src/:/usr/src/ \
    --net=bridge \
    -p 8080:80/tcp \
    -it --name bts-local bts-local-image bash

