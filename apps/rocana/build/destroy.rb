require 'chef/provisioning'

with_driver 'docker'
machine_image 'rocana' do
  action :destroy
end
