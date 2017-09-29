#!/usr/bin/env bash

#docker run -d --name=datameer_gex --privileged=true datameer_gex
#docker run -d -p 81:8080 --name=datameer --privileged datameer
docker run -d -p 81:8080 --name=datameer_test --privileged gex/datameer /lib/systemd/systemd