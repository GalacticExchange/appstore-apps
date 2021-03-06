### destroy
sh destroy.sh

# download config file


# download tar file
echo "---------- Downloading app.tar"
#cp ../build/app.tar .

# create image from tar file
echo "---------- Creating image from app.tar"
docker load < ../build/app.tar


# RUN on the client machine (node).

echo "---------- Creating Container"
sh create_container.sh

# provision container
echo "---------- Provisioning Container"

docker cp ../config/config.json app-nginx:/opt/gex/config/

docker exec app-nginx bash -c 'sh /opt/gex/configure.sh'
