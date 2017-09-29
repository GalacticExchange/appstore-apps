
application_name "datameer"

# desc: build "chef", "bash", "dockerfile", "ruby"

build 'chef', {
    :base_image=> 'nginx',
    :base_image_tag=> '1.10',
    :main_cookbook=>'default',
    :main_recipe=>'default',
    :chef_env=>'default'
}


##### use in chef recipe:   node['config_name']['config_attr']
config_for :base, {
    :command => 'bootstrap'
}



# main_recipe 'appname_something:yourcustomrecipename'


=begin
# desc: if you can't run your script from bootstrap for some reason change it to true and set command in override_command option (not recommended)
main_command_override false

# override for main command in the container (not recommended)
override_command ''

=end