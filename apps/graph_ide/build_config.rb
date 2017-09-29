application_name 'graph_ide'
version '0.0.2'

build :external, { }

deploy :from_local, {
    metadata_path: '/home/serj/projects/framework_templates/graph_ide/docker/metadata.rb',
    file_path: '/home/serj/projects/framework_templates/graph_ide/docker/graph_ide.tar.gz',
    ext: 'tar.gz'
}