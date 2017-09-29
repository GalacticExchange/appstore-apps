#
execute "apt-get-update" do
  command "apt-get update"
end
# some packages
apt_package 'ca-certificates'

#our
apt_package 'ssh'
apt_package 'sudo'
apt_package 'net-tools' # to enable ipconfig
apt_package 'wget'
apt_package 'software-properties-common'  # to enable add-apt-repository
apt_package 'iputils-ping'
apt_package 'telnet'
apt_package 'dnsutils'  # to enable dig
apt_package 'curl'

bash 'install_java_8' do
  code <<-EOH
    add-apt-repository -y ppa:webupd8team/java
    apt-get update
    echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
    echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
    apt-get -y install oracle-java8-installer
    apt-get -y install oracle-java8-set-default
  EOH
end

bash 'set_password' do
  code <<-EOH
    sed -i "s/PermitRootLogin prohibit-password/PermitRootLogin yes/g" /etc/ssh/sshd_config
    echo -e "root\nroot" | passwd root
  EOH
end


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

cookbook_file '/opt/gex/configure.sh' do
  source 'provision/configure.sh'
  owner 'root'
  group 'root'
  mode '0775'
end


cookbook_file '/etc/bootstrap' do
  source 'bootstrap'
  owner 'root'
  group 'root'
  mode '0775'
end
