rocana_base_dir = '/opt/rocana/rocana-1.4.2/'

# debug
#file '/tmp/debug_image.txt' do
#  content "new world "
#end

#
execute "apt-get-update" do
  command "apt-get update"
end


# some packages
apt_package 'ca-certificates'


# java
include_recipe "java"


### base
ENV['TERM'] = 'xterm'
bash 'env_test1' do
  code <<-EOF
  export TERM='xterm'
  EOF
end
#export TERM=xterm

apt_package 'vim'
apt_package 'nano'



### user
#user 'rocana' do
#  comment 'Rocana user'
#  home '/home/rocana'
#  shell '/bin/bash'
#password '$1$JJsvHslasdfjVEroftprNn4JHtDi'
#end

execute 'add user' do
  command 'adduser --disabled-password rocana'
end




### /opt/gex
directory '/opt/gex' do
  owner 'root'
  group 'root'
  mode '0775'
  action :create
end

['/opt/gex/provision', '/opt/gex/config'].each do |d|
  directory d do
    owner 'root'
    group 'root'
    mode '0775'
    action :create
  end
end


### openvpn
apt_package 'openvpn'

### download
apt_package 'wget'

directory '/opt/rocana' do
  owner 'rocana'
  group 'rocana'
  mode '0775'
  action :create
end


execute 'download distributive' do
  command "cd /home/rocana && wget http://#{node['base']['files_server']}/rocana/rocana-1.4.2.tar.gz && mv rocana-1.4.2.tar.gz /opt/rocana/"
  user 'rocana'
end

execute 'unzip ' do
  command 'cd /opt/rocana/ && tar -xzvf rocana-1.4.2.tar.gz'
  user 'rocana'
end

### rocana.conf
cookbook_file '/etc/security/limits.d/rocana.conf' do
  source 'rocana/limits_rocana.conf'
  owner 'rocana'
  group 'rocana'
  mode '0775'
  #action :create
end


## env
cookbook_file '/opt/gex/rocana-env.sh' do
  source 'rocana/rocana-env.sh'
  owner 'rocana'
  group 'rocana'
  mode '0775'
  #action :create
end

cookbook_file '/opt/gex/rocana-env' do
  source 'rocana/rocana-env'
  owner 'rocana'
  group 'rocana'
  mode '0775'
  #action :create
end

#cd /opt/rocana/rocana-1.4.2
#source ./bin/rocana-env


### Rocana data tool


### Rocana agent
execute 'agent - default config file' do
  command [
              #"source /opt/gex/rocana-env.sh",
              "cd #{rocana_base_dir}conf/rocana-agent",
              'mv agent.cfg agent-example.cfg',
              'mv agent-example.conf agent.conf'
          ].join(" && ")

  user 'rocana'

end


# systemd service for rocana-agent
template "/etc/systemd/system/rocana-agent.service" do
  source 'rocana-agent.service.erb'

  variables({rocana_base_dir: rocana_base_dir})
  owner 'root'
  group 'root'
  mode '0775'
end


=begin
systemd_service 'rocana-agent' do
  description 'Rocana Agent'
  service do
    exec_start "sudo -u rocana nohup #{rocana_base_dir}bin/rocana-agent > #{rocana_base_dir}logs/rocana-agent.out 2> #{rocana_base_dir}logs/rocana-agent.err "
    restart 'always'
    restart_sec '60s'
  end

  after %w( network.target )

  install do
    wanted_by 'multi-user.target'
  end

end

service 'rocana-agent' do
  action [:enable]
end
=end


### hdfs-consumer

# systemd service for rocana-hdfs-consumer
template "/etc/systemd/system/rocana-hdfs-consumer.service" do
  source 'rocana-hdfs-consumer.service.erb'

  variables({rocana_base_dir: rocana_base_dir})
  owner 'root'
  group 'root'
  mode '0775'
end



### solr-consumer

# systemd service for rocana-solr-consumer
template "/etc/systemd/system/rocana-solr-consumer.service" do
  source 'rocana-solr-consumer.service.erb'

  variables({rocana_base_dir: rocana_base_dir})
  owner 'root'
  group 'root'
  mode '0775'
end


### metric-consumer

# systemd service for rocana-metric-consumer
template "/etc/systemd/system/rocana-metric-consumer.service" do
  source 'rocana-metric-consumer.service.erb'

  variables({rocana_base_dir: rocana_base_dir})
  owner 'root'
  group 'root'
  mode '0775'
end



### metadata-consumer

# systemd service for rocana-metadata-consumer
template "/etc/systemd/system/rocana-metadata-consumer.service" do
  source 'rocana-metadata-consumer.service.erb'

  variables({rocana_base_dir: rocana_base_dir})
  owner 'root'
  group 'root'
  mode '0775'
end




### analytics

# systemd service for rocana-analytics
template "/etc/systemd/system/rocana-analytics.service" do
  source 'rocana-analytics.service.erb'

  variables({rocana_base_dir: rocana_base_dir})
  owner 'root'
  group 'root'
  mode '0775'
end



### postgresql 9.4
#include_recipe 'postgresql::server'

=begin
template "/etc/systemd/system/postgresql.service" do
  source 'postgresql.service.erb'

  variables({node: node})
  owner 'root'
  group 'root'
  mode '0775'
end
=end

apt_package "postgresql-9.4"
apt_package "postgresql-contrib"
apt_package "postgresql-client"




### rocana webapp

# systemd service for rocana-webapp
template "/etc/systemd/system/rocana-webapp.service" do
  source 'rocana-webapp.service.erb'

  variables({rocana_base_dir: rocana_base_dir})
  owner 'root'
  group 'root'
  mode '0775'
end



### copy gex configure

remote_directory '/opt/gex/provision' do
  source 'provision'
  owner 'root'
  group 'root'
  mode '0775'
  action :create
end

cookbook_file '/opt/gex/config/config.json' do
  source 'provision/config.json'
  owner 'root'
  group 'root'
  mode '0775'
end


cookbook_file '/opt/gex/configure.sh' do
  source 'provision/configure.sh'
  owner 'root'
  group 'root'
  mode '0775'
end


file '/var/chef/cache/jdk-7u75-linux-x64.tar.gz' do
  action :delete
end

file '/opt/rocana/rocana-1.4.2.tar.gz' do
  action :delete
end


### start command

apt_package "hardlink"

if node['base']['command'] == "systemd"
  execute 'create_hard_link' do
    command "ln /lib/systemd/systemd /etc/bootstrap"
  end
end
