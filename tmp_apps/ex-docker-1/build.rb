require 'chef/provisioning'

# load config
#dir_base = File.dirname(__FILE__)
#file = File.read(File.join(dir_base, 'config1.json'))
#attr_hash = JSON.parse(file)


puts "a=#{node['base'].inspect}"
puts "a=#{node['java'].inspect}"

#raise '1'

# env
chef_env = 'default'

with_driver 'docker'
machine 'my-ex2' do
  #action :destroy
  action :converge

  #recipe 'ex2::default'
  #recipe 'ex2::java'
  recipe 'ex2::pg'

  #chef_environment chef_env

  #
  attribute 'base', node['base']
  #attribute 'java', node['java']
  #attribute 'mysql', node['mysql']



  machine_options docker_options: {
      base_image: {
          name: 'ubuntu-systemd',
          #repository: 'ubuntu',
          repository: 'ubuntu-systemd',
          #tag: '14.04'
          tag: '15.10'
      },
      #base_image: {
      #    name: 'my-ubuntu-supervisor-2',
      #    repository: 'my-ubuntu-supervisor-2',
      #    tag: 'v1'
      #},
      privileged: true,

      #:command => '/usr/bin/supervisord -n',
      #:command => '/usr/bin/supervisord -n -c /etc/supervisor/conf.d/supervisord.conf',
      #:command => '/usr/bin/supervisord',
      #:entrypoint => "/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf",
      #:entrypoint => "/usr/bin/supervisord",

      #ENV (Environment Variables)
      #Set any env var in the container by using one or more -e flags, even overriding those already defined by the developer with a Dockerfile ENV
      :env => {
          "deep" => 'purple',
          "led" => 'zeppelin'
      },

      # Ports can be one of two forms:
      # src_port (string or integer) is a pass-through, i.e 8022 or "9933"
      # src:dst (string) is a map from src to dst, i.e "8022:8023" maps 8022 externally to 8023 in the container

      # Example (multiple):
      #:ports => ["26379:6379"],
      :ports => ["9022:22"],

      # Volumes can be one of three forms:
      # src_volume (string) is volume to add to container, i.e. creates new volume inside container at "/tmp"
      # src:dst (string) mounts host's directory src to container's dst, i.e "/tmp:/tmp1" mounts host's directory /tmp to container's /tmp1
      # src:dst:mode (string) mounts host's directory src to container's dst with the specified mount option, i.e "/:/rootfs:ro" mounts read-only host's root (/) folder to container's /rootfs
      # See more details on Docker volumes at https://github.com/docker/docker/blob/master/docs/sources/userguide/dockervolumes.md .

      # Example (single):
      #:volumes => "/tmp",

      # Example (multiple):
      #:volumes => ["/tmp:/tmp", "/:/rootfs:ro"],

      # if you need to keep stdin open (i.e docker run -i)
      # :keep_stdin_open => true

    },
    docker_connection: {
        # optional, default timeout is 600
        #:read_timeout => 1000,
    }

end
