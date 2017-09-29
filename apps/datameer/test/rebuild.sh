#!/usr/bin/env bash

cd "$(dirname "$0")"

#set -e

# remove all
echo "Rebuilding........................"


docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
docker rmi datameer

echo "Destroy!"
sh destroy.sh

echo "Build!"
sh build.sh



#sh create_test_container.sh


