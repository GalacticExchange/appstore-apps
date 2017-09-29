#docker run --name=rocana -d --privileged=true rocana
#docker run --name=rocana -d --privileged=true -v /mnt/data/projects/mmx/my-servers/dev-server/rocana-docker-chef/data/hosts:/etc/hosts -p 8081:8081 rocana ""
docker run --name=rocana -d --privileged=true -p 8081:8081 rocana ""
