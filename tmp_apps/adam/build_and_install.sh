# destroy
#sh destroy.sh

# remove all
docker rm -f adam_gex


#
cd ././build/ && sh docker_build.sh && sh export.sh

#cd ../install && sh install_all.sh
cd ../install && sh install_container.sh
