

#
execute "apt-get-update" do
  command "apt-get update"
end


# some packages
apt_package 'ca-certificates'



=begin

user 'nginx' do
  #comment 'A random user'
  #uid '1234'
  #gid '1234'
  home '/home'
  shell '/bin/bash'
  #password '$1$JJsvHslasdfjVEroftprNn4JHtDi'
end




# user: 'nginx'

directory '/data' do
  owner 'root'
  group 'root'
  mode '0775'
  action :create
end

directory '/data/www' do
  owner 'root'
  group 'root'
  mode '0775'
  action :create
end

directory '/data/images' do
  owner 'root'
  group 'root'
  mode '0775'
  action :create
end

file '/data/www/index.html' do
  content '<html>This is a placeholder for the home page.</html>'
  mode '0755'
  owner 'root'
  group 'root'
end

cookbook_file '/data/images/image.png' do
  source 'image.png'
  owner 'root'
  group 'root'
  mode '0775'
  action :create
end







=end


### gex
### /opt/gex
cookbook_file '/etc/bootstrap' do
  source 'bootstrap'
  owner 'root'
  group 'root'
  mode '0775'
  action :create
end


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


### copy gex configure
remote_directory '/opt/gex/provision' do
  source 'provision'
  owner 'root'
  group 'root'
  mode '0775'
  action :create
end

if node['base']['command'] == "systemd"
  execute 'create_hard_link' do
    command "ln /lib/systemd/systemd /etc/bootstrap"
  end
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
