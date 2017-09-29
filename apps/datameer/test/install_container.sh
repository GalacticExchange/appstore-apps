### destroy
sh destroy.sh

# download config file


# download tar file
echo "---------- Downloading app.tar"
#cp ../build/app.tar .

# create image from tar file
echo "---------- Creating image from app.tar"
gunzip ../distributive/datameer.tar.gz
docker import  ../distributive/datameer.tar gex/datameer


# RUN on the client machine (node).

echo "---------- Creating Container"
#sh create_container.sh

#docker run --name=app-nginx -d --privileged=true -p 9080:80 app-nginx ""
docker run -d -p 81:8080 --name=datameer_test --privileged gex/datameer /lib/systemd/systemd


# provision container
echo "---------- Provisioning Container"

#docker cp ../config/config.json datameer_gex:/opt/gex/config/
#docker exec datameer bash -c 'sh /opt/gex/configure.sh'
