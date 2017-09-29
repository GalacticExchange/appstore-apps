
# config properties
=begin
text = %Q(
{
    "master":{
    "host": "quickstart.cloudera",
    "ip": "51.1.0.221",
    "ssh": {
        "user": "cloudera",
        "password": "cloudera"
    }
},
    "zookeeper": {
    "url": "quickstart.cloudera:2181",
    "host": "quickstart.cloudera",
    "port": "2181"
},
    "hdfs": {
    "url": "quickstart.cloudera:8020",
    "host": "quickstart.cloudera",
    "port": "8020"
},
    "kafka": {
    "host": "quickstart.cloudera",
    "broker": "quickstart.cloudera:9092"
},
    "solr": {
    "events_repo": "quickstart.cloudera:2181/solr"
},
    "network":{
    "network_with_mask": "51.0.0.1/8"
},
    "postgresql": {


    },
        "hive": {
        "host": "quickstart.cloudera",
        "port": "9083"

    },
    "impala": {
        "host": "quickstart.cloudera",
        "port": 21050
    },
    "rocana":{
        "user": {
        "name": "rocana",
        "password": "rocana"
    },
        "events_topic_name": "events",
        "kafka_topic_name": "events",
        "impala_metrics_table": "metrics",
        "impala_anomalies_table": "anomalies",
        "postgresql":{
        "user": "rocana",
        "password": "rocana",
        "db": "rocana"
    }
}

}
)
=end

#data = JSON.parse(text)


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

    # kafka
    "kafka.host" => { description: "Kafka host", default_value: "{{kafka.host}}", mandatory: 1, editable: 1,},
    "kafka.broker" => { description: "Kafka broker host", default_value: "{{kafka.broker}}", mandatory: 1, editable: 1,},

    # solr
    "solr.events_repo" => { description: "Solr repo", default_value: "{{solr.events_repo}}", mandatory: 1, editable: 1,},


    #
    #postgresql: { }

    # hive
    "hive.host" => { description: "Hive host", default_value: "{{hive.host}}", mandatory: 1, editable: 0,},
    "hive.port" => { description: "Hive port", default_value: "{{hive.port}}", mandatory: 1, editable: 0,},


    # impala
    "impala.host" => { description: "impala host", default_value: "{{impala.host}}", mandatory: 1, editable: 0,},
    "impala.port" => { description: "impala port", default_value: "{{impala.port}}", mandatory: 1, editable: 0,},


    # rocana
    "rocana.user.name" => { description: "Rocana username", default_value: "rocana", mandatory: 1, editable: 1,},
    "rocana.user.password" => { description: "Rocana user password", default_value: "rocana", mandatory: 1, editable: 1,},


    # rocana basic
    "rocana.user.name" => { description: "Rocana username", default_value: "rocana", mandatory: 1, editable: 1,},
    "rocana.user.password" => { description: "Rocana user password", default_value: "rocana", mandatory: 1, editable: 1,},


    "rocana.events_topic_name" => { description: "Rocana events topic name", default_value: "events", mandatory: 1, editable: 1,},
    "rocana.kafka_topic_name" => { description: "Rocana Kafka topic name", default_value: "events", mandatory: 1, editable: 1,},
    "rocana.impala_metrics_table" => { description: "Rocana Impala metrics table name", default_value: "metrics", mandatory: 1, editable: 1,},
    "rocana.impala_anomalies_table" => { description: "Rocana Impala anomalies table name", default_value: "anomalies", mandatory: 1, editable: 1,},

    "rocana.postgresql.db" => { description: "Rocana database name in Postgresql", default_value: "rocana", mandatory: 1, editable: 1,},
    "rocana.postgresql.user" => { description: "Rocana user in Postgresql", default_value: "rocana", mandatory: 1, editable: 1,},
    "rocana.postgresql.password" => { description: "Rocana user password in Postgresql", default_value: "rocana", mandatory: 1, editable: 1,},
}


config_params(data)


### services
services({
             'webui' => {name: 'webui', protocol: 'http', port: 8081},
         })



### app_info
app_info = {
    metrics: {
        rocana: {
            memory: 1.3,
            hdd: 3.0
        }
    },
    dependencies: {
        components: [],
        containers: [:hadoop]
    }
}

app_info(app_info)