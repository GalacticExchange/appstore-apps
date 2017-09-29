#!/usr/bin/env bash

echo "---------- run container "
docker run -d -p 81:8080 --name=temp-datameer --privileged datameer /lib/systemd/systemd
docker stop temp-datameer

echo "---------- Exporting container to tar..."
sudo docker export temp-datameer > ../distributive/app.tar
#sudo docker save datameer > ../distributive/app.tar

#&& docker rmi -f datameer &&  gzip ../distributive/app.tar

#&&  gzip ../distributive/app.tar

#&& docker rmi -f datameer &&  gzip ../distributive/app.tar



echo "-------- remove container"
docker rm -f temp-datameer
