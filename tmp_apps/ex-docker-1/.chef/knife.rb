log_level                :error
#root = File.absolute_path(File.dirname(__FILE__))
current_dir = File.dirname(__FILE__)

#node_name                "provisioner"
#client_key               "#{current_dir}/dummy.pem"
#validation_client_name   "validator"

#cookbook_path [ '/vagrant/chef-repo/cookbooks', "#{current_dir}/../cookbooks" ]
cookbook_path [ '/mnt/data/projects/mmx/chef-repo/cookbooks' ]



