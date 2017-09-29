# delete
docker rm -f chef-converge.gex_zoomdata_build
docker rm -f gex_zoomdata_build
docker rmi gex_zoomdata_build

chef-client -z destroy.rb -j config_build.json
