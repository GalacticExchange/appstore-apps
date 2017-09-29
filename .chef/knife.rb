# settings
local_mode true

#
#log_level                :debug
log_level                :info


#
root = File.absolute_path(File.dirname(__FILE__))
current_dir = File.dirname(__FILE__)

#puts "root=#{root}"

#
appname =  ENV["APP_NAME"]
node_name  appname

#client_key               "#{current_dir}/dummy.pem"
#validation_client_name   "validator"

#p = File.join(root, '../', node_name, 'cookbooks')
#puts "p=#{p}"
#exit



dir_base_repo = '/work/chef-repo'

dirs = [
    "#{dir_base_repo}/cookbooks-apps",
    "#{dir_base_repo}/cookbooks",
    "#{dir_base_repo}/cookbooks-common",
]

dirs_good = dirs.reject{|d| !Dir.exists?(d)}

cookbook_path dirs_good


# load another knife file
file_knife_custom = File.expand_path("../../apps/#{appname}/build/.chef/knife.rb", __FILE__ )
#"/apps/#{appname}/.chef/knife.rb", __FILE__


if ::File.exist?(file_knife_custom)
  puts "include knife config from #{file_knife_custom}"
  Chef::Config.from_file(file_knife_custom)
end


# ssh
knife[:ssh_attribute] = "knife_zero.host"

# node name
knife[:force] = true
