class PackerBuilder

  attr_accessor :server

  def server=(v)
    @server = v
    @server
  end

  def server
    @server
  end

  def settings
    server
  end


  def initialize(_settings)
    self.server = _settings

  end

  def build
    # config json
    save_packer_config
    execute_cmd_system "packer build #{filename_config}"
  end

  # helpers
  def save_packer_config
    require 'json'
    filename = filename_config
    FileUtils.mkdir_p(File.dirname(filename))
    File.open(filename,"w+") do |f|
      f.write(build_packer_config.to_json)
    end

    true
  end

  def filename_config
    File.join(Dir.pwd, 'temp', "packer-#{settings.appname}.json")
  end

  def build_packer_config
    res = {}

    res['variables'] = {}

    res['builders'] = []

    bi = settings.build_options[:base_image]
    base_image_name = "#{bi[:name]}:#{bi[:tag]}"
    builder1 = {
        pull: false,
        type: "docker",
        image: base_image_name,
        commit: true
    }


    # changes
    entrypoint = settings.build_options[:entrypoint]
    if entrypoint
      builder1['changes'] ||= []
      builder1['changes'] << "ENTRYPOINT #{entrypoint}"
    end

    res['builders'] << builder1


    #
    recipe_name = settings.build_options[:recipe_name] || 'build'
    cookbook_paths = settings.build_options[:cookbook_paths] || []
    cookbook_paths.concat get_default_chef_repos


    app_cookbooks_dir = File.join(Dir.pwd, 'apps', settings.appname, settings.build_options[:app_cookbooks_dir])
    cookbook_paths << app_cookbooks_dir

    res["provisioners"] = [
        {
            type: "chef-solo",
            prevent_sudo: true,
            cookbook_paths: cookbook_paths,
            json: settings.build_options[:properties][:attributes],
            run_list: ["recipe[#{settings.appname}::#{recipe_name}]"]
        },
    ]

    # tag image
    res["post-processors"] = [
        {
            repository: "gex-#{settings.appname}",
            type: "docker-tag"
        }
    ]

    res
  end

  def get_default_chef_repos
    chef_repo_path = "/home/#{ENV['USER']}/projects/chef-repo"
    [File.join(chef_repo_path,'cookbooks'),File.join(chef_repo_path,'cookbooks-common')]
  end


end