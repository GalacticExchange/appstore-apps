#!/usr/bin/env bash
#docker run --name=app-nginx -d --privileged=true -p 9080:80 app-nginx ""
docker run -d -p 81:8080 --name=datameer gex/datameer
