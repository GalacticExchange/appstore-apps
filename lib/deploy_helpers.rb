require 'zlib'

=begin
1) load config
2) find file to upload
3) generate full version string
4) generate tmp file with version, checksum, size
....
=end



# metadata


def deploy_metadata(appname)

  config = Helpers.load_config(appname)
  srv = $settings['server_files']
  metadata_filepath = get_metadata_path(appname, config)
  v = Helpers::Apps.app_current_version(srv, appname)

  mtd = "#{srv['type']}_upload_meta"
  send(mtd, srv, appname, v, metadata_filepath)
end


def ssh_upload_meta(srv, appname, version, filename_metadata)

  srv_base_dir = srv['base_dir']

  puts "SSH upload to #{srv_base_dir}"

  # metadata
  ssh_upload_file(srv, filename_metadata, "#{srv_base_dir}gex-#{appname}-#{version}.metadata.rb")
end


def aws_upload_meta(srv, appname, version, filename_metadata)
  aws_upload_file(srv, filename_metadata, "gex-#{appname}-#{version}.metadata.rb", srv['bucket'], false)
end



# containers

def deploy_container(appname)

  copy_cookbooks_to_chef_repo(appname)

  config = Helpers.load_config(appname)
  file = find_file(appname, config)

  full_version = Helpers.get_full_app_version(config.app_version)
  gen_tmp_version_file(appname, file[:path], full_version)

  srv = $settings['server_files']
  metadata_filepath = get_metadata_path(appname, config)
  method_name = "#{srv['type']}_deploy"

  send(method_name, srv, appname, full_version, file, metadata_filepath)
end


def find_file(appname, config)

  if config.deploy_type == :from_local

    file_path = config.deploy_options[:file_path]
    ext = config.deploy_options[:ext]

    files = [[file_path, ext]]
  else
    files = [
        ["apps/#{appname}/distributive/#{appname}.tar.gz", "tar.gz"],
        ["apps/#{appname}/distributive/#{appname}.tar", "tar"],
        ["/vagrant/docker/#{appname}.tar.gz", "tar"]
    ]
  end


  res = {}

  files.each do |fp|
    next unless File.exist? fp[0]
    res[:path] = fp[0]
    res[:ext] = fp[1]
    break
  end

  res
end

def gen_tmp_version_file(appname, filepath, full_version)
  execute_cmd_system("mkdir -p /tmp/deploy")

  path = File.join('/tmp/deploy', "#{appname}-version.txt")
  size = `stat --printf="%s" #{filepath}`
  checksum = Zlib::crc32(File.read(filepath), 0)

  content = "version=#{full_version} \nsize=#{size} \nchecksum=#{checksum}\n"

  File.write(path, content)
  path
end

def get_metadata_path(appname, config)
  config.deploy_type == :from_local ? config.deploy_options[:metadata_path] : "apps/#{appname}/metadata.rb"
end


def copy_cookbooks_to_chef_repo(app_name)
  checker = Checker.new([:cmd1, :cmd2, :cmd3])
  dir_base = $settings['chef_repo']
  dir_cookbooks_apps = File.join(dir_base, '/cookbooks-apps')
  app_cookbooks = File.join($settings['dir_base'], "/apps/#{app_name}/cookbooks")


  checker.res[:cmd1] = execute_cmd("cd #{dir_cookbooks_apps} && rm -rf #{app_name} ")
  checker.res[:cmd2] = execute_cmd("cd #{app_cookbooks} && cp -rf #{app_name} #{dir_cookbooks_apps}/")
  checker.res[:cmd3] = execute_cmd("cd #{dir_cookbooks_apps} && git add #{app_name}/* && git commit -m '#{app_name} distributive' && git push origin master ")

  checker.check
end


def ssh_upload_file(srv, filename, path_to)
  sshpass(srv, "scp -o StrictHostKeyChecking=no  #{filename} #{srv['user']}@#{srv['host']}:#{path_to}")

end


def aws_upload_file(srv, file_path, path_to, bucket_name, invalidate)
  require 'aws-sdk'

  Aws.config.update({
                        :access_key_id => srv['ACCESS_KEY_ID'],
                        :secret_access_key => srv['SECRET_ACCESS_KEY']
                    })

  s3 = Aws::S3::Resource.new(region: srv['region'])


  file_name = File.basename(path_to)

  puts "upload #{file_name}"

  #
  s3.bucket(bucket_name).object(file_name).upload_file(file_path, {acl: 'public-read'})

  #returning public url
  s3.bucket(bucket_name).object(file_name).public_url

  aws_invalidate(bucket_name, file_name, srv) if invalidate

end


def ssh_deploy(srv, appname, version, file, filename_metadata)

  filename = file[:path]
  ext = file[:ext]

  srv_base_dir = srv['base_dir']

  puts "SSH upload to #{srv_base_dir}"

  #
  ssh_upload_file(srv, filename, "#{srv_base_dir}gex-#{appname}-#{version}.#{ext}")

  # metadata
  ssh_upload_file(srv, filename_metadata, "#{srv_base_dir}gex-#{appname}-#{version}.metadata.rb")

  # version file
  ssh_upload_file(srv, "/tmp/deploy/#{appname}-version.txt", "#{srv_base_dir}")

  # permissions
  sshpass(srv, "ssh #{srv['user']}@#{srv['host']} 'sudo chmod 777 #{srv_base_dir}gex-#{appname}*'")
  sshpass(srv, "ssh #{srv['user']}@#{srv['host']} 'sudo chmod 777 #{srv_base_dir}#{appname}-*'")
end


def aws_deploy(srv, appname, version, file, filename_metadata)

  filename = file[:path]
  ext = file[:ext]

  aws_upload_file(srv, "/tmp/deploy/#{appname}-version.txt", "#{appname}-version.txt", srv['bucket'], true)
  aws_upload_file(srv, filename, "gex-#{appname}-#{version}.#{ext}", srv['bucket'], false)
  aws_upload_file(srv, filename_metadata, "gex-#{appname}-#{version}.metadata.rb", srv['bucket'], false)
end


def aws_invalidate(bucket_name, file_name, srv)
  Aws.config.update({
    :access_key_id => srv['ACCESS_KEY_ID'],
    :secret_access_key => srv['SECRET_ACCESS_KEY']
  })

  # noinspection RubyArgCount
  cloudfront = Aws::CloudFront::Client.new(region: 'us-west-2')
  #cloudfront_ids = {'clustergx-iso' => 'E2D1AQHH4KWP3Q', 'gex-boxes' => 'E5AGWVBUXNOML', 'gex-containers' => 'E2O3NCM6YLLH09', 'gex-debian' => 'E3AER9RGJ7UJH9'}

  cloudfront.create_invalidation({
     distribution_id: 'E2RSXSXZ11Y8QW', # required
     invalidation_batch: {# required
      paths: {# required
        quantity: 1, # required
        items: ["/#{file_name}"],
      },
      caller_reference: "invalidation-#{Time.now.to_i}", # required
     },
  })
end
