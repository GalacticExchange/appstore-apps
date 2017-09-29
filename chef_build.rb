require 'chef/provisioning'
require_relative 'lib/configurator'

chef_env = 'default'
appname = ENV['APP_NAME']
dir = ENV['DIR']

config_dir = File.join(dir,'apps',appname)
main_config = ConfigLoader.load_config(config_dir)


recipe_name = main_config.build_options[:main_cookbook] + "::" + main_config.build_options[:main_recipe]

#puts "recipe= #{recipe_name}"
#exit

with_driver 'docker'
machine_image appname do
  action :create

  recipe recipe_name
  #chef_environment chef_env

  #attributes
  main_config.configs.each do |config|
    attribute config[0], config[1]
  end


  machine_options docker_options: {
      base_image: {
          name: main_config.build_options[:base_image],
          repository: main_config.build_options[:base_image],
          tag: main_config.build_options[:base_image_tag]
      },
      privileged: true
  }

end
