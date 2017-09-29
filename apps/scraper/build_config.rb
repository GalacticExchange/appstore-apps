application_name 'scraper'
version '0.0.5'

build :external, { }

deploy :from_local, {
    metadata_path: '/home/serj/projects/framework_templates/scraper/docker/metadata.rb',
    file_path: '/home/serj/projects/framework_templates/scraper/docker/scraper.tar.gz',
    ext: 'tar.gz'
}