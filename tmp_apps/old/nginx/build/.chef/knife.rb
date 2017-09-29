#current_dir = File.dirname(__FILE__)
dir_local_base = File.expand_path('../../', __FILE__)
#root = File.absolute_path(File.dirname(__FILE__))

dir_base_repo = '/work/chef-repo'
#dir_base_repo = '/mnt/data/projects/mmx/chef-repo'

log_level                :info

node_name                "app-nginx-build"
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
