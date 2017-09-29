
# build

cd build

chef-client -z build.rb -j config_build.json

a new image 'rocana' should be created


# test

run tests:
```
rspec spec/test-rocana/rocana_container_spec.rb
```

# destroy

chef-client -z destroy.rb -j config.json


# Image

- based on Ubuntu 15.10 

- systemd

- java - oracle java 1.7 


# Test image
