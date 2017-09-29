sh destroy.sh

# download config file


# download tar file


# create image from tar file


# RUN on the client machine (node).
# create and run container

echo "---------- Creating Container"
sh create_container.sh

# provision container
echo "---------- Provisioning Container"

docker cp ../config/config.json rocana:/opt/gex/config/

docker exec rocana bash -c 'sh /opt/gex/configure.sh'

# restart
docker restart rocana
