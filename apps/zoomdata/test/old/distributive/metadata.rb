
# config properties

p = {
    "nginx.sitename" => {
      "default_value"=> "",
      "description" => "Nginx domain name",
      "mandatory" => 1,
      "basic" => 1,
    },
    "hadoop.master_node.host" => {
        "default_value"=> "",
        "description" => "Hostname of the Hadoop master node",
        "mandatory" => 1,
        "basic" => 1,
    },
    "hadoop.master_node.ip" => {
        "default_value"=> "",
        "description" => "IP of the Hadoop master node",
        "mandatory" => 1,
        "basic" => 1,
    },


}

config_params(p)
