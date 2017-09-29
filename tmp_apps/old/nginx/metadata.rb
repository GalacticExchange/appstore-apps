
data = {

    # network
    "network.network_with_mask" => { description: "Network mask", default_value: "51.0.0.1/8", mandatory: 1, basic: 0, editable: 1},

    #
    "master.host" => { description: "Host of hadoop master node", default_value: "{{master.host}}", mandatory: 1, basic: 1, editable: 0,},
    "master.ip" => { description: "IP of Hadoop master node", default_value: "{{master.ip}}", mandatory: 1, basic: 1, editable: 0,},
    "master.ssh.user" => { description: "ssh user", default_value: "{{master.ssh.user}}", mandatory: 1, basic: 1, editable: 0, visible: 0},
    "master.ssh.password" => { description: "ssh password", default_value: "{{master.ssh.password}}", mandatory: 1, editable: 0, visible: 0},

    # zookeeper
    "zookeeper.url" => { description: "Zookeeper URL", default_value: "{{zookeeper.url}}", mandatory: 1, editable: 0,},
    "zookeeper.host" => { description: "Zookeeper host", default_value: "{{zookeeper.host}}", mandatory: 1, editable: 0,},
    "zookeeper.port" => { description: "Zookeeper port", default_value: "{{zookeeper.port}}", mandatory: 1, editable: 0,},

    # hdfs
    "hdfs.url" => { description: "HDFS URL", default_value: "{{hdfs.url}}", mandatory: 1, editable: 0,},
    "hdfs.host" => { description: "HDFS host", default_value: "{{hdfs.host}}", mandatory: 1, editable: 0,},
    "hdfs.port" => { description: "HDFS port", default_value: "{{hdfs.port}}", mandatory: 1, editable: 0,},
}

config_params(data)


### services
services({
             'webui' => {name: 'webui', protocol: 'http', port: 8080},
         })
