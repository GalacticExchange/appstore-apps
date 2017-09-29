

module Helpers

  def self.load_config(app_name)
    require_relative "configurator"

    config_dir = File.join(Dir.pwd, 'apps', app_name)
    ConfigLoader.load_config(config_dir)
  end

  def self.get_full_app_version(version)
    now = `date +%m_%d_%Y_%s`
    "#{version}.#{now}".strip
  end

end


# without terminal output, returns output
def execute_cmd(cmd)
  puts "cmd: #{cmd}"
  `#{cmd}`
end

# output in terminal, returns true/false
def execute_cmd_system(cmd)
  puts "cmd: #{cmd}"
  system("#{cmd}")
end


def run_chef(script)
  execute_cmd_system("bash -c 'chef-client -z #{script} -j config_build.json'")
end

def chef_destroy(appname, dir)
  execute_cmd_system("APP_NAME='#{appname}' chef-client -z chef_destroy.rb")
end

def chef_build(appname, dir)
  execute_cmd_system("APP_NAME='#{appname}' DIR='#{dir}' chef-client -z chef_build.rb")
end


def run_sh(script)
  execute_cmd_system("sh #{script}")
end

def ruby_run(script)
  execute_cmd_system("ruby #{script}")
end

def ruby_build
  ruby_run("build.rb")
end

def ruby_destroy
  ruby_run("destroy.rb")
end

def sh_build
  run_sh("build.sh")
end

def sh_destroy
  run_sh("destroy.sh")
end


# docker commands
def d_rm(name)
  execute_cmd("docker rm -f #{name}")
end

def d_rmi(name)
  execute_cmd("docker rmi -f #{name}")
end

def d_exec(appname, cmd, mode='-ti')
  execute_cmd_system("docker exec #{mode} #{appname}_test #{cmd}")
end

def d_run(app_name, container_name, cmd, args)
  execute_cmd_system("docker run #{args} --name=#{container_name}  #{app_name} #{cmd}")
end

def d_stop(name)
  execute_cmd("docker stop #{name}")
end

def d_import(tar_name, image_name)
  execute_cmd("docker import #{tar_name} #{image_name}")
end

def d_export(name, tar)
  execute_cmd_system("docker export #{name} > #{tar}")
end

def d_build(appname)
  execute_cmd_system("docker build -t gex-#{appname} .")
end


# other
def chdir(dir)
  Dir.chdir(dir)
end


def sshpass(srv, command)
  execute_cmd("sshpass -p '#{srv['password']}' #{command}")
end

def puts_ln(str)
  puts "----------------------- #{str} -----------------------"
end

def puts_err(str)
  red = ' " $(tput setaf 1) !!! '+str+' !!! " '
  system("echo #{red}")
  system("tput sgr0")
end
