#!/usr/bin/env bash

docker rm -f datameer
docker rmi -f datameer

#
cd ./build && sh rebuild.sh && sh export.sh

#cd ../install && sh install_all.sh
cd ../install && sh install_container.sh
