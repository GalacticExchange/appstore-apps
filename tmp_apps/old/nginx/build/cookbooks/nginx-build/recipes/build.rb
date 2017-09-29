# debug
file '/tmp/debug_image.txt' do
  content "new world "
end


#
execute "apt-get-update" do
  command "apt-get update"
end


# nginx
apt_package 'nginx'


### gex
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
