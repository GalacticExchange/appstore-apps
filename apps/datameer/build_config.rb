application_name "datameer"
version '0.0.1'

COOKBOOK_PATHS = []

build 'packer', {
    base_image: {
        name: 'ubuntu-systemd',
        tag: '15.10',
    },
    #entrypoint: '',  # custom option
    recipe_name: 'default',

    cookbook_paths: COOKBOOK_PATHS,
    app_cookbooks_dir: "/build/cookbooks",

    properties: {
        attributes: {
            java: {
                :install_flavor => 'oracle',
                :jdk_version => "7",
                :oracle => {
                    :accept_oracle_download_terms => true
                }
            },
            datameer: {
                :release => "5.11.14-cdh-5.7.0-mr2",
                :license_path => "/"
            },
            base: {
                :command => 'systemd'

            }
        }
    }
}


=begin
# desc: if you can't run your script from bootstrap for some reason change it to true and set command in override_command option (not recommended)
main_command_override false

# override for main command in the container (not recommended)
override_command ''

=end