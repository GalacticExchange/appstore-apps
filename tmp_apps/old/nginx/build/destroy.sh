# delete
docker rm -f chef-converge.app-nginx
docker rm -f app-nginx
docker rmi app-nginx

chef-client -z destroy.rb -j config_build.json
