# delete
docker rm -f chef-converge.datameer
docker rm -f datameer
docker rmi datameer

cd ./build
chef-client -z destroy.rb -j config_build.json
cd ..