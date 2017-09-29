#!/usr/bin/env bash

#set -e

docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)

sh destroy.sh
sh build.sh

sh create_test_container.sh


