# irb -r ./builder.rb
# ruby builder.rb method_name

class Builder

  def initialize app_name
    @checker = Checker.new [:destroy, :build]
    @script_dir = Dir.pwd
    @app_build_dir = File.join(Dir.pwd, 'apps', app_name, 'build')
    @app_name = app_name

    self.load_config
  end

  def load_config
    config_dir = File.join(Dir.pwd, 'apps', @app_name)
    @app_config = ConfigLoader.load_config(config_dir)
  end

  def build

    puts_ln 'Building'

    case @app_config.build_type
      when 'packer'
        packer_build = PackerBuilder.new(@app_config)
        @checker.res[:build] = packer_build.build
      when 'chef'
        @checker.res[:build] = chef_build @app_name, @script_dir
      when 'bash'
        chdir @app_build_dir
        @checker.res[:build] = sh_build
      when 'dockerfile'
        chdir @app_build_dir
        @checker.res[:build] = d_build @app_config.appname
      when 'ruby'
        chdir @app_build_dir
        @checker.res[:build] = ruby_build
      else
        puts_err "config.rb file doesn't contain build_type option. You should provide it."
    end

    chdir @script_dir

  end


  def destroy
    puts_ln 'Destruction'

    d_rm @app_name
    d_rm "chef-converge.#{@app_name}"
    d_rmi @app_name

    case @app_config.build_type
      when 'packer'
        chdir @script_dir
        #todo:
        # remove containers/images: gex-appname, appname, temp-appname
        #@checker.res[:destroy] = packer_destroy @app_name, @script_dir
      when 'chef'
        chdir @script_dir
        @checker.res[:destroy] = chef_destroy @app_name, @script_dir
      when 'bash'
        chdir @app_build_dir
        @checker.res[:destroy] = sh_destroy
      when 'dockerfile'

      when 'ruby'
        chdir @app_build_dir
        @checker.res[:destroy] = ruby_destroy
      else
        puts_err "config.rb file doesn't contain build_type option. You should provide it."
    end

    chdir @script_dir

    @checker.res[:destroy]
  end

  def rebuild

    if @app_config
      self.destroy
      self.build
    end

    puts_ln "Rebuild done!" if @checker.check
  end

end
