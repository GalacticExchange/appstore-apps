require 'chef/provisioning'

# env
chef_env = 'default'

with_driver 'docker'
machine_image node['base']['container_name'] do
  action :create

  recipe 'nginx-build::build'

  #chef_environment chef_env

  # attr
  node.keys.each do |k|
    attribute k, node[k]
  end


  attribute 'nginx', node['nginx']


  machine_options docker_options: {
      base_image: {
          name: node['base']['base_image'],
          repository: node['base']['base_image'],
          tag: node['base']['base_image_tag']
      },
      privileged: true

    }


end


