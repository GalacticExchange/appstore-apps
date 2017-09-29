cd /opt/gex/
#chef-client -z /opt/gex/configure.rb -j /opt/gex/config.json
chef-solo -c /opt/gex/provision/solo.rb -j /opt/gex/config/config.json -o 'recipe[app::provision]'

