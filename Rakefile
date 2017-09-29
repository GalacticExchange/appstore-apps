require_relative "lib/deploy_helpers"
require_relative "lib/common_helpers"
require_relative "lib/builder"
require_relative "lib/exporter"
require_relative "lib/checker"
require_relative "lib/configurator"
require_relative "lib/base_builder"
require_relative "lib/deploy"
require_relative "lib/db_helpers"
require_relative "lib/packer_builder"
require_relative "lib/apps_helper"

require 'json'

#require 'activerecord'
#require 'mysql2'

#
$gex_env = ENV['gex_env'] || 'dev'

$settings = JSON.parse(File.read("config.#{$gex_env}.json"))

#
dir_local_base = File.expand_path('../', __FILE__)
$settings['dir_base'] = dir_local_base

#
verbose = true
ENTRYPOINT = '/etc/bootstrap'

desc "Build image and create tar file"
namespace :build do

  task :all do

    apps = Dir['./apps/*'].map { |a| File.basename(a) }

    apps.each do |appname|
      builder = Builder.new appname
      builder.rebuild

      exporter = Exporter.new appname
      exporter.export
    end

  end


  task :full, [:arg1] do |t, args|
    appname = args[:arg1]

    builder = Builder.new appname
    builder.rebuild

    exporter = Exporter.new appname
    exporter.export

  end

  task :build, [:arg1] do |t, args|
    appname = args[:arg1]

    builder = Builder.new appname
    builder.build

  end


  task :destroy, [:arg1] do |t, args|
    appname = args[:arg1]

    builder = Builder.new appname
    builder.destroy

  end

  task :base_images do
    build_base_images
  end

  task :base_image, [:arg1] do |t, args|
    img = args[:arg1]

    base_images_dir = File.join(Dir.pwd,'base-images')
    path = File.join(base_images_dir,img)
    build_base_image(img,path)
  end

end


desc "Create tar from build image"
namespace :export do
  task :tar, [:arg1] do |t, args|
    appname = args[:arg1]

    exporter = Exporter.new appname
    exporter.export

  end
end


desc "Upload tar for app. [appname]"
namespace :deploy do


  task :all do

    apps = Dir['./apps/*'].map { |a| File.basename(a) }

    apps.each do |appname|
      deploy_container(appname)
    end

  end

  task :upload, [:arg1] do |t, args|
    appname = args[:arg1]
    deploy_container(appname)
  end

  task :update_metadata, [:arg1] do |t, args|
    appname = args[:arg1]
    deploy_metadata(appname)
  end




end


desc "Tests"
namespace :test do

  task :from_tar, [:arg1, :arg2] do |t,args|

    appname = args[:arg1]
    ports = args[:arg2]
    app_dir = File.join(Dir.pwd,'apps',appname)

    Dir.chdir app_dir

    d_rm appname
    d_rm "#{appname}_test"
    d_rmi "gex/#{appname}"

    puts "Unpacking..."
    execute_cmd "gunzip -k ./distributive/#{appname}.tar.gz"

    puts "Importing..."
    d_import "./distributive/#{appname}.tar", "gex/#{appname}"

    execute_cmd "docker run -d -p #{ports} --name=#{appname}_test --privileged gex/#{appname} #{ENTRYPOINT}"

    d_exec appname, '/bin/bash'

    ####### todo: provisioning container test

  end
end



