docker rm -f chef-converge.my-ex2
chef-client -z destroy.rb -j config1.json


#
chef-client -z build.rb -j config_build.json

# create container
docker run -d --name=temp-1 --privileged my-ex2

#sudo chef-client -z configure.rb -j config1.json
docker exec my-ex2 bash -c 'sh /opt/gex/confugure.sh'



