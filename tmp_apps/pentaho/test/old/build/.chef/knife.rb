#current_dir = File.dirname(__FILE__)
dir_local_base = File.expand_path('../../', __FILE__)
#root = File.absolute_path(File.dirname(__FILE__))

dir_base_repo = '/work/chef-repo'
#dir_base_repo = '/mnt/data/projects/mmx/chef-repo'

log_level                :error

node_name                "app-zoomdata-build"



# ???
ssl_verify_mode    :verify_none

# ssh
#knife[:ssh_attribute] = "knife_zero.host"
#knife[:use_sudo] = true
#knife[:identity_file] = "~/.ssh/id_rsa"

#knife[:ssh_user] = 'zoomdata'
#knife[:ssh_password] = 'password'

#knife[:use_sudo] = true

#--no-host-key-verify
#knife[:host_key_verify] = false
#--use-sudo-password
#knife[:use_sudo_password] = true

#
#knife[:chef_node_name] = 'srvlocalbeta'
#knife[:force] = true




#client_key               "#{current_dir}/dummy.pem"
#validation_client_name   "validator"

dirs = [
    "#{dir_local_base}/cookbooks",

    "#{dir_base_repo}/cookbooks-apps",
    "#{dir_base_repo}/cookbooks",
    "#{dir_base_repo}/cookbooks-common",
]

dirs_good = dirs.reject{|d| !Dir.exists?(d)}

cookbook_path dirs_good
