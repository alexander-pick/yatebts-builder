#!/bin/bash

# Alexander Pick 2022/2023 
# contact@alexander-pick.com

docker stop yate
docker rm yate
docker image rm yate-image

# build a generic image with all needed packages needed inside
docker build -t yate-image ./container/ 

# create a container from image and add our buildroot on host to it,
# we pass all /dev to it, yes this is insecure and stuff but we build
# an enviorment dealing with hardware
docker run --privileged \
    -v /dev:/dev \
    -v $(pwd)/src/:/usr/src/ \
    --net=bridge \
    -p 80:80/tcp \
    -it --name yate yate-image bash

