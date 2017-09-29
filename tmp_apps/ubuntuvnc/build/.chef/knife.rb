
dir_local_base = File.expand_path('../../', __FILE__)


log_level                :error
node_name                "ubuntu-systemd-1604-build"

# ???
ssl_verify_mode    :verify_none

dir_base_repo = '/work/chef-repo'


dirs = [
    "#{dir_base_repo}/cookbooks-apps",
    "#{dir_base_repo}/cookbooks",
    "#{dir_base_repo}/cookbooks-common",
    "#{dir_local_base}/cookbooks"
]

dirs_good = dirs.reject{|d| !Dir.exists?(d)}

cookbook_path dirs_good
