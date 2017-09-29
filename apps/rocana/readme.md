## Setup workstation to run builds

Install ChefDK v. 0.15.16:

https://downloads.chef.io/chef-dk/

```bash
sudo dpkg -i chefdk_0.15.16-1_amd64.deb
```
Install gems:  
```bash
sudo gem install rspec
```
```bash
chef gem install chef-provisioning  -v 1.7.0
chef gem install chef-provisioning-docker  
```
```bash
chef gem install docker  
chef gem install docker-api
```

## Deploy build to repository

### upload app tar to files.gex

```
cd deploy

rake deploy:upload['rocana','0.0.1']
```





## Install in cluster

Workflow:
* download tar file with docker image
* [optional] create image from tar file
* run docker container from image (or tar file)
* provision master
* provision container



* create application on the API server

as a result a new record about App is on API server.


* download tar file

* download config.json from API server

```
wget http://api.gex/nodeFiles..?nodeID=XX&app_id=XX&file=
```

* create image from tar file


* setup master

```
sudo chef-client -z master_provision.rb -j config.json
```

test master:
```

config=config.json rake serverspec:master

# or
env TARGET_HOST=51.1.0.221 SSH_USER=cloudera SSH_PASSWORD=cloudera rspec spec/master/rocana_master_spec.rb
rspec spec/master/rocana_master_spec.rb
```


* run container from the image

* provision container

```
docker cp config.json rocana:/opt/gex/config

docker exec rocana bash -c 'sh /opt/gex/configure.sh'

```

* restart the container

* create systemd for container


* test installed container

```
rake serverspec:rocana

rspec spec/test-rocana/rocana_container_spec.rb
```


# Tests

## TODO:

* test solr
!!! api for solr

* metric consumer with hive

!!test with api



# Services

## Ports

```
8081 - webapp
5432 - postgresql

17320
17310
17317 - admin http for metric consumer

17315 - analytics
```

      
# TEST solr-consumer

!!! api for solr



* check

from UI:
```
http://localhost:8983/solr/#/~cloud
```


* Generate test events with the Rocana Data Tool.
```
bin/rocana-data --event-gen --event-size 300 --num-clients 1 --num-events 10 --use-text
```



* check generated data in solr UI `http://localhost:8983/solr/#/~cloud`





* check - text search

* test message
```
echo "<94>Apr 12 20:07:15 webtest-thisisatest simlogging[17155]: This is a log.info() message"| nc localhost 17320
```


* execute query in Solr UI
```
q=thisisatest
```




# TEST metric consumer with hive


* check
```
impala-shell -i <impala host>
use default;
invalidate metadata metrics;
select count(*) from metrics;
```

This should return something like:
```
Query: select count(*) from metrics
```


# global test



## send message

```
sudo echo "<94>Jun 06 20:07:15 hdfstest-thisisatest simlogging[17155]: This is a log.info() message" | nc localhost 17320
```

* TEST data

* hdfs:
```
su - hdfs
hdfs dfs -ls -R /datasets/rocana/default/events
```


* test from rocana node
```
bin/rocana-data --cat --repo repo:hdfs://quickstart.cloudera:8020/datasets/rocana --name events
```

?? filter by date


* View activity in the metrics UI at
```
http://quickstart.cloudera:17311/metrics?pretty=true
```