
# config properties

data = {

    # network
    #"network.network_with_mask" => { description: "Network mask", default_value: "51.0.0.1/8", mandatory: 1, basic: 0, editable: 1},

    #
    "master.host" => { description: "Host of hadoop master node", default_value: "{{master.host}}", mandatory: 1, basic: 1, editable: 0,},
    "master.ip" => { description: "IP of Hadoop master node", default_value: "{{master.ip}}", mandatory: 1, basic: 1, editable: 0,},
    "master.ssh.user" => { description: "ssh user", default_value: "{{master.ssh.user}}", mandatory: 1, basic: 1, editable: 0, visible: 0},
    "master.ssh.password" => { description: "ssh password", default_value: "{{master.ssh.password}}", mandatory: 1, editable: 0, visible: 0},

}


config_params(data)


### services
services({
             'ssh' => {title: 'SSH', name: 'ssh', protocol: 'ssh', port: 22},
         })
