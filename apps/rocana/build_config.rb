application_name "rocana"
version '0.0.4'


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
            base: {
                command: 'systemd',
                #files_server: "51.0.1.6"
                files_server: "gex1.devgex.net:8090"
            },
            mysql: {
                "root_password" => "PH_GEX_PASSWD1"
            },
            cdh: {
                "ip" => "51.1.0.221",
                "host" => "51.1.0.221",
                "zoookeper_quorum" => "quickstart.cloudera:2181"
            }
        }
    }
}

