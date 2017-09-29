application_name 'corenlp_server'
version '0.0.15'

build :external, { }

deploy :from_local, {
    metadata_path: '/home/iliya/Ruby/framework_templates/corenlp_server/docker/metadata.rb',
    file_path: '/home/iliya/Ruby/framework_templates/corenlp_server/docker/corenlp_server.tar.gz',
    ext: 'tar.gz'
}
