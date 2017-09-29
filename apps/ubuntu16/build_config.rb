
application_name "ubuntu16"
version '0.0.1'

# desc: build "chef", "bash", "dockerfile", "ruby"

build 'chef', {
    :base_image=> 'ubuntu-systemd',
    :base_image_tag=> '16.04',
    :main_cookbook=>'ubuntu_build',
    :main_recipe=>'default',
    :chef_env=>'default'
}

config_for :base, {
    :command => 'systemd'
}


=begin


build :from_git, {
  type: 'dockerfile',
  path_to_dockerfile: '/test/Dockerfile'
}


=end



=begin

build :external, { }

deploy :from_git, {
    git_url: 'https://github.com/antirez/redis',
    metadata_path: 'gex/metadata.rb',
    file_path: 'gex/distributive.tar',
    ext: 'tar',

    # todo: move to metadata
    run_file: '/etc/bootstrap',
    env: {
        'MY_APP_PATH': '/tgh/gh/gh',
        'REDIS_HOME': '/apps/redis'
    }



}
=end



# main_recipe 'appname_something:yourcustomrecipename'
=begin
# desc: if you can't run your script from bootstrap for some reason change it to true and set command in override_command option (not recommended)
main_command_override false

# override for main command in the container (not recommended)
override_command ''

=end