#!/usr/bin/env bash
sudo docker save gex_zoomdata:0.6 > app.tar && docker rmi gex_zoomdata:0.6
