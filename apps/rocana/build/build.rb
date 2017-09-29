require 'chef/provisioning'

#puts "node: #{node.inspect}"

# env
chef_env = 'default'

with_driver 'docker'
machine_image 'rocana' do
  action :create

  recipe 'rocana-build::build'

  #chef_environment chef_env


  # attr
  attribute 'base', node['base']
  attribute 'java', node['java']
  attribute 'mysql', node['mysql']
  attribute 'cdh', node['cdh']


  machine_options docker_options: {
      base_image: {
          name: node['base']['base_image'],
          repository: node['base']['base_image'],
          tag: node['base']['base_image_tag']
      },
      #:command => '/usr/bin/supervisord -c /etc/supervisord.conf',
      privileged: true

    }


end


