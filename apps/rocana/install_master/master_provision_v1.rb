### provision cloudera cluster

require 'chef/provisioning'

# settings
class MySettings
  @@node_attributes = {}

  def self.init(_attr)
    @@node_attributes = _attr

  end
  def self.node
    @@node_attributes
  end

  def self.settings
    #puts "node=#{node.inspect}"
    #exit

    settings = {
        'host' => '51.1.0.221',
        'ssh' => {
            'user' => 'cloudera',
            'password' => 'cloudera',
        }
    }
  end

  def self.master_ssh_options
    {
      'host' => node['master']['host'],
      'user' => node['master']['ssh']['user'],
      'password' => node['master']['ssh']['password'],
    }
  end
end

MySettings.init(node)

def run_master(cmd)
  opt = MySettings.master_ssh_options
  #puts "opt=#{opt.inspect}"
  #exit

  #s = %Q[ssh vagrant@51.0.12.21 "docker exec hadoop #{cmd}" ]
  #s = %Q[ssh cloudera@51.1.0.221 "#{cmd}" ]
  #%x[#{s}]

  #cmd_docker = #s = %Q[ssh vagrant@51.0.12.21 "docker exec hadoop #{cmd}" ]
  cmd_docker = %Q[ #{cmd} ]

  s_debug = ""

  s_debug << "run cmd #{cmd_docker}"
  Net::SSH.start(opt['host'], opt['user'], :password => opt['password']) do |ssh|
    res = ssh.exec! cmd_docker
    s_debug << "; res: #{res}"
  end

  "echo 'ok'"
  "echo '#{s_debug}' > /tmp/myserver.log "
end



#machine_execute 'localhost' do
#  machine 'localhost'
  #attribute 'value' # see properties section below

#  driver Chef::Provisioning::Driver

#  command 'touch /tmp/5.txt'
#  action :run
#end

puts 'go'


### WORK


def hell_out(cmd)
  "out-#{cmd}"
end

lambda_hell_out = lambda { hell_out('555')}

execute "debug" do
  def hell(cmd)
    "000#{cmd}"
  end

  command lazy {
    x = lambda_hell_out.call
    [
        "echo '#{hell('333')}' > /tmp/1.log ",
      "echo '#{x}' > /tmp/2.log "
    ].join("; ")
  }
end



ruby_block 'debug' do
  block do
    %x[touch /tmp/6.txt]
    #run_master('touch /tmp/7.txt')
  end
  action :run
end



###

lambda_run_master = lambda do |cmd|
  run_master(cmd)
end


execute "debug-master" do
  command lazy {
    lambda_run_master.call("touch /tmp/3.log")
  }
end



### kafka

# kafka - create topic
# Apache Kafka
#bin/kafka-topics.sh --create --zookeeper quickstart.cloudera:2181 --replication-factor 2 --partitions 25 --topic events

# Cloudera’s Kafka distribution.
#kafka-topics --create --zookeeper quickstart.cloudera:2181 --replication-factor 2 --partitions 25 --topic events

execute "debug-master" do
  command lazy {
    cmd = 'kafka-topics --create --zookeeper quickstart.cloudera:2181 --replication-factor 1 --partitions 2 --topic events2'
    lambda_run_master.call(cmd)
  }
end



=begin

#require 'chef_metal_ssh'

#with_ssh_cluster("~/metal_ssh")

with_driver 'metal-ssh'
machine "cloudera_master" do
  #action [:ready, :converge]
  action [:converge]

  recipe 'rocana::cluster'

  machine_options 'ip_address' => '51.0.12.21',
                  'ssh_options' => {
                      'user' => 'vagrant',
                      'password' => 'vagrant'
                  }



end

=end
