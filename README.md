### Before you start!

- On the new file server you'll need to manually copy version.txt file for hadoop_cdh

```bash
 echo version=0.0.1.05_24_2017_1495633152 >>  hadoop_cdh-version.txt
```

(You could use any valid version name for hadoop_cdh.)

Then deploy metadata.rb to the server: 
```bash
gex_env=ENV rake deploy:update_metadata['datameer']
```



## Commands 

```
build ALL images:
gex_env=dev rake build:all
deploy ALL images:
gex_env=dev rake deploy:all


// build

build base images:
gex_env=dev rake build:base_images

build base image:
gex_env=dev rake build:base_image['img_name']

destroy + build + pack to *.tar:
gex_env=dev rake build:full['app_name']

build:
gex_env=dev rake build:build['app_name']

destroy:
gex_env=dev rake build:destroy['app_name']

pack to tar:
gex_env=dev rake export:tar['app_name']

test from tar:
gex_env=dev rake test:from_tar['app_name','port_outside:port_inside']


// deploy

update metadata:
gex_env=main rake deploy:update_metadata['datameer']


deploy dev:         
gex_env=dev rake deploy:upload['app_name']

deploy main:
gex_env=main rake deploy:upload['app_name']

deploy prod (aws bucket):
gex_env=prod rake deploy:upload['app_name']

```


# Quickstart 

#### Setup workstation to run builds

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


Install SSHPass:
```bash
sudo apt-get install sshpass
```

#### Folder structure (for app)

```
REQUIRED: 

apps  
│
└───appname
│   └───config.rb

OPTIONAL:

apps  
│
└───appname
│   │
│   └───build
│   │   │   build.sh or build.rb
│   │   │   destroy.sh or destroy.rb
│   │   │   if chef build => config_build.json
│   └───distributive
│   │   │   .
│   └───test
│   │   │   connect.sh
│   │   │   etc...
│   └───config
│   │   │   config.json
│   └───metadata.rb
│   └───readme.md

```


### Notes

Main process - always /etc/bootstrap
If you want your own script to be main in the container - create hard link:

##### Chef example:
```
if node['base']['command'] == "systemd"
  execute 'create_hard_link' do
    command "ln /lib/systemd/systemd /etc/bootstrap"
  end
end
```
##### Bash:
```
ln /lib/systemd/systemd /etc/bootstrap
```




# Build image

* build image, export to tar.gz file in distributive/app.tar.gz
```
gex_env=dev rake build:build['app_name']
```


 If app is assembled with Chef you should have `build.rb`, `destroy.rb` and `config_build.json` in build folder
 If app is assembled  with sh scripts you should have `build.sh` and `destroy.sh` in build folder
 
##### NOTE: If app is assembled with Chef please don't include `build.sh` and `destroy.sh` in build folder

###### Required components:

- `build` directory
- `distributive` directory
- `/etc/bootstrap.sh` in image 

#### Test build from tar
```
gex_env=dev rake test:from_tar['app_name','ports']
```



# Deploy

* upload app tar to files.gex

```
gex_env=main rake deploy:upload['nginx','0.0.1']

// dev env
gex_env=dev rake deploy:upload['nginx','0.0.1']

```





