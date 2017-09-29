
application_name "ubuntuvnc"
version '0.0.1'

# desc: build "chef", "bash", "dockerfile", "ruby"

build 'chef', {
    :base_image=> 'consol/ubuntu-xfce-vnc',
    :base_image_tag=> '1.0.2',
    :main_cookbook=>'ubuntu_build',
    :main_recipe=>'default',
    :chef_env=>'default'
}

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