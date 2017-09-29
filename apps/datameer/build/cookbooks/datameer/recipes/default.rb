

#
execute "apt-get-update" do
  command "apt-get update"
end


# some packages
apt_package 'ca-certificates'


###recipes
include_recipe "java"

### base
ENV['TERM'] = 'xterm'
bash 'env_test1' do
  code <<-EOF
  export TERM='xterm'
  EOF
end


apt_package 'vim'
apt_package 'nano'

apt_package 'unzip' do
  action :install
end


###datameer
datameer_root_folder_name = 'datameer'
datameer_release_path = File.join(datameer_root_folder_name,"Datameer-"+node['datameer']['release'])
datameer_bin_path = File.join(datameer_release_path, "bin")
datameer_conductor_path = File.join(datameer_bin_path,"conductor.sh")
conductor_commands = ["start", "stop", "restart"]
inject_examples = false


group 'datameer' do
  action :create
  system true
  append true
end

user 'datameer' do
  comment 'datameer user'
  #uid 'datameer'
  gid 'datameer'
  home '/home/datameer'
  shell '/bin/bash'
  password 'datameer'
  system true
end


=begin
remote_directory "#{datameer_root_folder_name}" do
  source "#{datameer_root_folder_name}"
  action :create
end
=end

remote_directory '/datameer' do
  cookbook 'datameer'
  source 'datameer'
  owner 'root'
  group 'root'
  mode '0775'
  action :create
end


cookbook_file '/datameer/run.sh' do
  source 'run.sh'
  owner 'root'
  group 'root'
  mode '0775'
  action :create
end


# download d.zip

bash "download d.zip" do
  command "cd /#{datameer_root_folder_name} && wget http://51.0.0.101/datameer/d.zip"
end



script "unzip" do
  interpreter "bash"
  user "root"
  cwd "/tmp"
  code <<-EOH
    cd /#{datameer_root_folder_name}
    unzip d.zip
  EOH
end

if node['datameer']['license_path'] == "/"
  trial = true
end










### gex
### /opt/gex
cookbook_file '/etc/bootstrap1' do
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


# systemd service for datameer
template "/etc/systemd/system/datameer.service" do
  source 'datameer.service.erb'

  variables({datameer_base_dir: datameer_release_path})
  owner 'root'
  group 'root'
  mode '0775'
end



bash "enable service" do
  command "systemctl enable datameer.service"
end

service "datameer" do
  #supports :start => true, :stop => true, :status => false
  action [ :enable ]
  #start_command "sudo /etc/init.d/jboss start"
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

