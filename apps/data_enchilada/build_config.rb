application_name 'data_enchilada'
version '0.0.80'

build :external, { }

deploy :from_local, {
    # from katya
    #metadata_path: '/media/khotkevych/594caf8b-ae44-489c-a7f2-b2633048db85/projects/framework_templates/data_enchilada/docker/metadata.rb',
    #file_path: '/media/khotkevych/594caf8b-ae44-489c-a7f2-b2633048db85/projects/framework_templates/data_enchilada/docker/data_enchilada.tar.gz',

    # from elvis
    metadata_path: '/mnt/elvisdata/work/framework_templates/data_enchilada/docker/metadata.rb',
    file_path: '/mnt/elvisdata/work/framework_templates/data_enchilada/docker/data_enchilada.tar.gz',

    ext: 'tar.gz'
}


