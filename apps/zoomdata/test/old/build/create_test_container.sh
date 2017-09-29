#!/usr/bin/env bash

docker run -d --name=zoomdata --privileged=true gex_zoomdata_build
docker exec -ti zoomdata /bin/bash