# Overview

process:
* build Docker image

# Build

* requirements

specify path to chef-repo with common cookbooks


* edit .chef/knife.rb
```
# change to your node name
node_name                "node-name"
```

* build

```
cd build

chef-client -z build.rb -j config_build.json
```

a new image 'app-nginx' should be created

```
docker images
```

# Install app


# Deploy

* upload app.tar to files.gex

```
cd deploy

rake deploy:upload['nginx','0.0.1']
```

check:
```
version:
http://files.gex/containers/nginx-version.txt

http://files.gex/containers/gex-nginx-0.0.1.06_22_2016_1466584298.tar
```
