
application_name "datameer"
version '0.0.1'

# desc: build "chef", "bash", "dockerfile", "ruby"

build 'chef', {
    :base_image=> 'ubuntu-systemd',
    :base_image_tag=> '15.10',
    :main_cookbook=>'datameer_build',
    :main_recipe=>'default',
    :chef_env=>'default'
}


##### use in chef recipe:   node['config_name']['config_attr']

config_for :java, {
    :install_flavor=>'oracle',
    :jdk_version=> "7",
    :oracle=>{
        :accept_oracle_download_terms=> true
    }
}

config_for :datameer, {
    :release=> "5.11.14-cdh-5.7.0-mr2",
    :license_path=> "/"
}

config_for :base, {
    :command => 'systemd'

}



# main_recipe 'appname_something:yourcustomrecipename'


=begin
# desc: if you can't run your script from bootstrap for some reason change it to true and set command in override_command option (not recommended)
main_command_override false

# override for main command in the container (not recommended)
override_command ''

=end