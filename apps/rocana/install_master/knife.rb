current_dir = File.dirname(__FILE__)


local_mode true

knife[:ssh_attribute] = "knife_zero.host"
knife[:use_sudo] = true
## use specific key file to connect server instead of ssh_agent(use ssh_agent is set true by default).
knife[:identity_file] = "~/.ssh/id_rsa"


#chef_repo_path   File.expand_path('../' , __FILE__)
cookbook_path            ["#{current_dir}/../cookbooks", '/mnt/data/projects/mmx/chef-repo/cookbooks']



## Attributes of node objects will be saved to json file.
## the automatic_attribute_whitelist option limits the attributes to be saved.
knife[:automatic_attribute_whitelist] = %w[
  fqdn
  os
  os_version
  hostname
  ipaddress
  roles
  recipes
  ipaddress
  platform
  platform_version
  platform_version
  cloud
  cloud_v2
  chef_packages
]
