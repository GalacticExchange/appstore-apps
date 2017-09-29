#!/usr/bin/env bash

docker stop zoomdata_gex_test
docker rm zoomdata_gex_test

#docker run -d --name=zoomdata_gex_test --privileged=true zoomdata_gex:0.2
docker run -p 81:8080 --name zoomdata_gex_test --sig-proxy=false zoomdata

docker exec -ti zoomdata_gex_test /bin/bash
