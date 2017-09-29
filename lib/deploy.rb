require 'zlib'


class Deploy

  def initialize(app_name)
    @app_name = app_name
    @config = Helpers.load_config(app_name)
    @version = @config.app_version
    @full_version = Helpers.get_full_app_version(@version)

    files = [
        ["apps/#{app_name}/distributive/#{app_name}.tar.gz", "tar.gz"],
        ["apps/#{app_name}/distributive/#{app_name}.tar", "tar"],
        ["/vagrant/docker/#{app_name}.tar.gz", "tar"]
    ]

    files.each do |fp|
      next unless File.exist? fp[0]
      @file = fp[0]
      @ext = fp[1]
      break
    end

    gen_tmp_version_file(@file)

  end

  def deploy
    srv = $settings['server_files']
    method_name = "#{srv['type']}_deploy"
    send(method_name, srv)
  end


  def ssh_deploy(srv)
    srv_base_dir = srv['base_dir']

    puts "SSH upload to #{srv_base_dir}"

    ssh_upload_file(srv, @file, "#{srv_base_dir}gex-#{@app_name}-#{@full_version}.#{@ext}")

    # metadata
    ssh_upload_file(srv, get_metadata_path, "#{srv_base_dir}gex-#{@app_name}-#{@full_version}.metadata.rb")

    # version file
    ssh_upload_file(srv, "/tmp/deploy/#{@app_name}-version.txt", "#{srv_base_dir}")

    # permissions
    sshpass(srv, "ssh #{srv['user']}@#{srv['host']} 'sudo chmod 777 #{srv_base_dir}gex-#{@app_name}*'")
    sshpass(srv, "ssh #{srv['user']}@#{srv['host']} 'sudo chmod 777 #{srv_base_dir}#{@app_name}-*'")
  end


  def aws_deploy(srv)
    aws_upload_file(srv, "/tmp/deploy/#{@app_name}-version.txt", "#{@app_name}-version.txt", srv['bucket'], true)
    aws_upload_file(srv, @file, "gex-#{@app_name}-#{@full_version}.#{@ext}", srv['bucket'], false)
    aws_upload_file(srv, get_metadata_path, "gex-#{@app_name}-#{@full_version}.metadata.rb", srv['bucket'], false)
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

    aws_invalidate(bucket_name, file_name,srv) if invalidate

  end



  def get_metadata_path
    "apps/#{@app_name}/metadata.rb"
  end


  def gen_tmp_version_file(filename)
    execute_cmd_system("mkdir -p /tmp/deploy")

    path = File.join('/tmp/deploy', "#{@app_name}-version.txt")
    size = `stat --printf="%s" #{filename}`
    checksum = Zlib::crc32(File.read(filename), 0)

    content = "version=#{@full_version} \nsize=#{size} \nchecksum=#{checksum}"

    File.write(path, content)
    path
  end


  def aws_invalidate(bucket_name, file_name,srv)
    Aws.config.update({
      :access_key_id => srv['ACCESS_KEY_ID'],
      :secret_access_key => srv['SECRET_ACCESS_KEY']
    })

    # noinspection RubyArgCount
    cloudfront = Aws::CloudFront::Client.new(region: 'us-west-2')


    puts "INVALIDATE!!!!!!!"

    cloudfront.create_invalidation({
      distribution_id: CLOUDFRONT_IDS[bucket_name], # required
      invalidation_batch: {# required
        paths: {# required
          quantity: 1, # required
          items: ["/#{file_name}"],
        },
        caller_reference: "invalidation-#{Time.now.to_i}", # required
      },
    })
  end




end