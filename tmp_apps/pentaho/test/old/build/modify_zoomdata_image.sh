#!/usr/bin/env bash

docker pull zoomdata/quickstart

docker run -d --name=zoomdata_tmp --privileged=true zoomdata/quickstart

docker cp change_perm_in_zoomdata.sh zoomdata_tmp:/permissions.sh

docker exec zoomdata_tmp sudo chmod +x permissions.sh
docker exec zoomdata_tmp /permissions.sh

docker exec zoomdata_tmp sudo apt-get update
docker exec zoomdata_tmp sudo apt-get install -y coreutils


docker rmi gex_zoomdata:0.5
docker commit zoomdata_tmp gex_zoomdata:0.6
docker stop zoomdata_tmp
docker rm zoomdata_tmp
