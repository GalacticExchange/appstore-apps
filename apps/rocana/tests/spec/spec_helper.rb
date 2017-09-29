require 'serverspec'
require 'docker'
require 'net/ssh'
require 'json'
#require_relative 'helpers/server_options'


current_dir = File.dirname(__FILE__)

# config
puts "config: #{ENV['config']}"
host = ENV['TARGET_HOST']
puts "host=#{ENV['TARGET_HOST']}, type=#{ENV['TARGET_HOST_TYPE']}"

#puts "hosts: #{hosts.inspect}"
#puts "dir=#{current_dir}"

file_config = File.join(current_dir, "..", ENV['config'] )
#puts "f=#{file_config }"
$server_config = JSON.parse(File.read(file_config))
#ENV['server_config'] = server_config
#exit


############## BACKEND

## SSH

if ENV['TARGET_HOST_TYPE']=='ssh'
  set :backend, :ssh

  if ENV['ASK_SUDO_PASSWORD']
    begin
      require 'highline/import'
    rescue LoadError
      fail "highline is not available. Try installing it."
    end
    set :sudo_password, ask("Enter sudo password: ") { |q| q.echo = false }
  else
    set :sudo_password, ENV['SUDO_PASSWORD']
  end

  set :sudo_password, ENV['SSH_PASSWORD']

  host = ENV['TARGET_HOST']

  options = Net::SSH::Config.for(host)

  options[:user] ||= Etc.getlogin

  options[:user] = ENV['SSH_USER']
  options[:password] = ENV['SSH_PASSWORD']

  set :host,        options[:host_name] || host
  set :ssh_options, options

# Disable sudo
# set :disable_sudo, true


# Set environment variables
# set :env, :LANG => 'C', :LC_MESSAGES => 'C'

# Set PATH
# set :path, '/sbin:/usr/local/sbin:$PATH'



### v2. set options

=begin
RSpec.configure do |c|
  c.before :all do
    #c.path = '/sbin:/usr/sbin'

    host = ENV['TARGET_HOST']
    #c.host   = host

    puts "-- host = #{host} "
    #attr_set JSON.parse(File.read("./nodes/#{c.host}.json"))

    options  = Net::SSH::Config.for(c.host)
    user     = ENV['SSH_USER']
    options[:password] = ENV['SSH_PASSWORD']
    #c.ssh    = Net::SSH.start(c.host, user, options)
    #c.os     = backend.check_os
    #c.os = backend(Serverspec::Commands::Base).check_os
  end
end
=end

elsif ENV['TARGET_HOST_TYPE']=='docker'
  set :backend, :exec
end
