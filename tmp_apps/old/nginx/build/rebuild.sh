# clean docker
#sudo docker rmi $(docker images -f "dangling=true" -q)

# destroy
sh destroy.sh

# build
sh build.sh


# create container
sh create_test_container.sh

