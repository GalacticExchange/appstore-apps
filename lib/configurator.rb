class Configurator

  attr_accessor :build_type, :appname, :app_version, :build_options, :params, :configs, :deploy_type, :deploy_options

  def initialize
    @configs = []
  end

  def get_binding
    return binding()
  end


  def build(type, options)
    @build_type = type
    @build_options = options
  end

  def deploy(type, options)
    @deploy_type = type
    @deploy_options = options
  end


  def application_name(appname)
    @appname = appname
    @entry_recipe = "#{@appname}_build::default"
  end

  def chef_params(params)
    @params = params
  end


  def config_for name,params
    @configs.push([name,params])
  end

  def version(v)
    @app_version = v
  end





end


class ConfigLoader

  def self.load_config(config_dir)
    configurator = Configurator.new
    f = File.read("#{config_dir}/build_config.rb")
    eval(f, configurator.get_binding)
    configurator
  end

end