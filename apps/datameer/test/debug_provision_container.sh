# copy provision files to container

docker cp /mnt/data/projects/mmx/chef-repo/cookbooks/gex-app-nginx/files/default/provision app-nginx:/opt/gex

# run provision from container
docker cp ../config/config.json rocana:/opt/gex/config/
docker exec app-nginx bash -c 'sh /opt/gex/configure.sh'



