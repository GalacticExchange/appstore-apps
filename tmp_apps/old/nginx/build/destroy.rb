require 'chef/provisioning'

with_driver 'docker'
machine_image node['base']['container_name'] do
  action :destroy
end
