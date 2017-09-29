# copy provision files to container

docker cp /mnt/data/projects/mmx/chef-repo/cookbooks/rocana/files/default/provision rocana:/opt/gex

# run provision from container
docker cp ../config/config.json rocana:/opt/gex/config/
docker exec rocana bash -c 'sh /opt/gex/configure.sh'

# restart
docker restart rocana


