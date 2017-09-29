
  application_name "rocana"
  application_description "Ubuntu 16.04 with Rails 5.0 and MySQL installed"

  base_image "ubuntu"
  base_image_version "16.04"


  cookbook :java, {
    :version=>'4.5',
    :main_recipe=>'oracle',

    :config=>{
      :install_flavor=>'oracle',
      :jdk_version=> "7",
      :oracle=>{
          :accept_oracle_download_terms=> true
      }
    }
  }

  cookbook :mysql, {
      :version=>'7.4.1',
      :main_recipe=>'default',

      :config=>{
          :root_password=> "PH_GEX_PASSWD1"
      }
  }

  local_cookbook :my_custom_cookbook, {
      :main_recipe=>'default',

      :config=>{
          :my_config=> "mdgi"
      }
  }

  local_script :my_custom_script, {
      :path=>'scripts/mine.sh',
      :type=>'sh'
  }

  local_script :my_custom_script, {
      :path=>'scripts/one.sh',
      :type=>'sh'
  }

  # default - false
  override_main_cookbook true,{
      :main_cookbook=>"my_custom_cookbook",
      :main_recipe=>"my_custom_recipe",
  }

  # default - false
  override_main_script true,{
      :main_script=>"my_custom_script",
  }

  apt_update
  apt_install "nano"

  ssh_available true

  interfaces :do=>{
    :webui=>{
        :port=>"80",
        :name=>"App UI"
    },
    :db=>{
        :port=>"7000",
        :name=>"MySQL Manage"
    }
  }


