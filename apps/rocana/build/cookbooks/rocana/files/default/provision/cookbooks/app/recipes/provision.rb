rocana_base_dir = '/opt/rocana/rocana-1.4.2/'

file '/tmp/in1.txt' do
  content 'from inside'
end

template '/tmp/debug.conf' do
  source 'debug.erb'
  variables({node: node})
end




###
ENV['TERM'] = 'xterm'
bash 'env_test1' do
  code <<-EOF
  export TERM='xterm'
  EOF
end

### for debug
cmds = [
    "apt-get install -y iputils-ping",
    "apt-get install -y netcat",
    "apt-get install -y telnet",

]

cmds.each do |cmd|
execute "debug tools" do
  command cmd
end
end


## hosts
=begin
ruby_block "/etc/hosts" do
  block do

    lines = [
        "#{node['master']['ip']} #{node['master']['host']}"
    ]

    file = Chef::Util::FileEdit.new('/etc/hosts')
    lines.each do |line|
      file.insert_line_if_no_match(/#{line}/, line)
      file.write_file
    end

  end
end
=end


### data tool

template "#{rocana_base_dir}conf/event-producer.properties" do
  source 'event-producer.properties.erb'

  variables({node: node})

  owner 'rocana'
  group 'rocana'
  mode '0775'
end


### agent
# agent - setup
template "#{rocana_base_dir}conf/rocana-agent/agent.conf" do
  source 'agent.conf.erb'

  variables({node: node})

  owner 'rocana'
  group 'rocana'
  mode '0775'
end



# agent - start
execute 'start agent' do
  command 'systemctl daemon-reload && systemctl enable rocana-agent && systemctl start rocana-agent'
end



### hdfs

#su - rocana
#cd $ROCANA_HOME
#bin/rocana-data --create --repo repo:hdfs://quickstart.cloudera:8020/datasets/rocana --name events

#execute 'debug 2' do
#  command "exit(1) 2>&1"
#  ignore_failure(true)
#end


execute 'hdfs setup' do
  command "su - rocana -c 'source /opt/gex/rocana-env.sh && #{rocana_base_dir}bin/rocana-data --create --repo repo:hdfs://#{node['master']['host']}:8020/datasets/rocana --name #{node['rocana']['kafka_topic_name']}' 2>&1"
  ignore_failure(true)
end


# check:
#bin/rocana-data --list --repo repo:hdfs://quickstart.cloudera:8020/datasets/rocana





### hdfs consumer


# setup
template "#{rocana_base_dir}conf/rocana-hdfs-consumer/hdfs-consumer.properties" do
  source 'hdfs-consumer.properties.erb'

  variables({node: node, pipelines: ["events"] })

  owner 'rocana'
  group 'rocana'
  mode '0775'
end

# start systemd service
execute 'start hdfs-consumer' do
  command 'systemctl daemon-reload && systemctl enable rocana-hdfs-consumer && systemctl start rocana-hdfs-consumer'
end




### solr consumer


# setup
template "#{rocana_base_dir}conf/rocana-solr/solr-consumer.properties" do
  source 'solr-consumer.properties.erb'

  variables({node: node})

  owner 'rocana'
  group 'rocana'
  mode '0775'
end

# setup data
execute 'setup solr data' do
  command "su - rocana -c 'source /opt/gex/rocana-env.sh && #{rocana_base_dir}bin/rocana-data --create-solr --zk #{node['zookeeper']['url']}/solr --name #{node['rocana']['events_topic_name']} --partitions 10 --replication 1 --partition-scheme time --hours-per-period 3 --partitions-per-period 2' "
  ignore_failure(true)
end


# start systemd service
execute 'start solr-consumer' do
  command 'systemctl daemon-reload && systemctl enable rocana-solr-consumer && systemctl start rocana-solr-consumer'
end



### metric consumer

# TODO: skip if exists
execute 'hive - data - create the metrics repository' do
  command lazy{
    cmd = %Q{#{rocana_base_dir}bin/rocana-data --create-metric --name #{node['rocana']['impala_metrics_table']} --repo "repo:hive://#{node['hive']['host']}:#{node['hive']['port']}/datasets/rocana?hdfs-host=#{node['hdfs']['host']}&hdfs-port=#{node['hdfs']['port']}" }
    "su - rocana -c 'source /opt/gex/rocana-env.sh && #{cmd}' "
  }

  ignore_failure(true)
end




# setup
template "#{rocana_base_dir}conf/rocana-metric-consumer/metric-consumer.properties" do
  source 'metric-consumer.properties.erb'

  variables({node: node})

  owner 'rocana'
  group 'rocana'
  mode '0775'
end


# start systemd service
execute 'start metric-consumer' do
  command 'systemctl daemon-reload && systemctl enable rocana-metric-consumer && systemctl start rocana-metric-consumer'
end








### PostgreSQL


#template "/var/lib/pgsql/data/pg_hba.conf" do
template "/etc/postgresql/9.4/main/pg_hba.conf" do
  source 'pg/pg_hba.conf.erb'

  variables({node: node})

  owner 'postgres'
  group 'postgres'
  mode '0775'
end


template "/etc/postgresql/9.4/main/postgresql.conf" do
  source 'pg/postgresql.conf.erb'

  variables({node: node})

  owner 'postgres'
  group 'postgres'
  mode '0775'
end



# start service
execute 'enable postgresql' do
  command 'systemctl daemon-reload && systemctl enable postgresql'
  ignore_failure(true)
end
execute 'start postgresql' do
  command 'systemctl start postgresql'
end

#/usr/lib/postgresql/9.4/bin/postgres -D /var/lib/postgresql/9.4/main -c config_file=/etc/postgresql/9.4/main/postgresql.conf



# prepare data in pg

# TODO: create if not exists
execute 'postgresql - create user' do
  command %Q(su - postgres bash -c "psql -c \\"CREATE ROLE #{node['rocana']['postgresql']['user']} LOGIN PASSWORD '#{node['rocana']['postgresql']['password']}';\\"" )
  ignore_failure(true)
end
execute 'postgresql - DB' do
  command %Q(su - postgres bash -c "psql -c \\"CREATE DATABASE #{node['rocana']['postgresql']['db']}  WITH TEMPLATE = template0 OWNER rocana ENCODING 'UTF8';\\"")
  ignore_failure(true)
end





### Web App


# setup
template "#{rocana_base_dir}conf/rocana-webapp/rocana-web.properties" do
  source 'rocana-web.properties.erb'

  variables({node: node})

  owner 'rocana'
  group 'rocana'
  mode '0775'
end

execute 'chmod' do
  command "chmod 600 #{rocana_base_dir}conf/rocana-webapp/rocana-web.properties"
end


# start webapp
execute 'start webapp' do
  command 'systemctl daemon-reload && systemctl enable rocana-webapp && systemctl start rocana-webapp'
end

# restart
execute 'restart webapp' do
  command 'systemctl restart rocana-webapp'
end





### metadata consumer

# config
template "#{rocana_base_dir}conf/rocana-metadata-consumer/metadata-consumer.properties" do
  source 'metadata-consumer.properties.erb'

  variables({node: node})

  owner 'rocana'
  group 'rocana'
  mode '0600'
end


# start systemd service
execute 'start metadata-consumer' do
  command 'systemctl daemon-reload && systemctl enable rocana-metadata-consumer && systemctl start rocana-metadata-consumer'
end




### Analytics and Anomaly Detection Setup

execute 'dataset for tracking anomalies' do
  command lazy{
    cmd = %Q{ #{rocana_base_dir}bin/rocana-data --create-anomaly --name #{node['rocana']['impala_anomalies_table']} --repo "repo:hive://#{node['hive']['host']}:#{node['hive']['port']}/datasets/rocana?hdfs-host=#{node['hdfs']['host']}&hdfs-port=#{node['hdfs']['port']}" }
    "su - rocana -c 'source /opt/gex/rocana-env.sh && #{cmd}' "
  }

  ignore_failure(true)
end


# update hdfs-consumer
template "#{rocana_base_dir}conf/rocana-hdfs-consumer/hdfs-consumer.properties" do
  source 'hdfs-consumer.properties.erb'

  variables({node: node, pipelines: ["events", "anomalies"] })


  owner 'rocana'
  group 'rocana'
  mode '0775'
end


# restart hdfs-consumer
execute 'restart hdfs-consumer' do
  command 'systemctl daemon-reload && systemctl enable rocana-hdfs-consumer && systemctl start rocana-hdfs-consumer'
end



# analytics . properties
template "#{rocana_base_dir}conf/rocana-analytics/analytics-consumer.properties" do
  source 'analytics-consumer.properties.erb'

  variables({node: node})

  owner 'rocana'
  group 'rocana'
  mode '0600'
end


# restart web app
execute 'restart webapp' do
  command 'systemctl daemon-reload && systemctl enable rocana-webapp && systemctl start rocana-webapp'
end


# start rocana-analytics
execute 'restart webapp' do
  command 'systemctl daemon-reload && systemctl enable rocana-analytics && systemctl start rocana-analytics'
end
