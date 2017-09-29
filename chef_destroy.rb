require 'chef/provisioning'

appname = ENV['APP_NAME']
puts "Server name: #{appname}"


with_driver 'docker'
machine_image appname do
  action :destroy
end
