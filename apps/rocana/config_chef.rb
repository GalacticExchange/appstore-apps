
application_name "rocana"
version '0.0.1'

# desc: build "chef", "bash", "dockerfile", "ruby"

build 'chef', {
    :base_image=> 'ubuntu-systemd',
    :base_image_tag=> '15.10',
    :main_cookbook=>'rocana-build',
    :main_recipe=>'build',
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

config_for :base, {
    command: 'systemd',
    files_server: "51.0.1.6"
}

config_for :mysql, {
    "root_password" => "PH_GEX_PASSWD1"
}

config_for :cdh, {
    "ip"=> "51.1.0.221",
    "host"=> "51.1.0.221",
    "zoookeper_quorum"=> "quickstart.cloudera:2181"
}

