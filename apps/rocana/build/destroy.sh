# delete
docker rm -f chef-converge.temp-rocana
docker rm -f chef-converge.rocana

docker rm -f temp-rocana
docker rm -f rocana
docker rmi temp-rocana
docker rmi rocana

chef-client -z destroy.rb -j config_build.json
