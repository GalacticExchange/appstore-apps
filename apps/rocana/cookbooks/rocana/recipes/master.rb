
# debug
file '/tmp/master.txt' do
  #content "it is cluster"
  content "node: #{node.normal.inspect}"
end

data = node.normal

### create user rocana

#execute "user rocana" do
#  command 'adduser rocana'
#end

user 'rocana' do
  comment 'Rocana user'
  home '/home/rocana'
  shell '/bin/bash'
  password "#{data['rocana']['user']['password']}"
end


execute "user rocana 2" do
  command 'usermod -a -G rocana hive'
end

execute "user rocana 3" do
  command 'usermod -a -G rocana impala'
end




### kafka

# restart zookeeper and kafka

#execute "zookeeper restart" do
#  command "service zookeeper-server start"
#end

#execute "kafka restart" do
#  command "pkill -f '.*kafka.*'"

#  ignore_failure true
#end
#execute "kafka start" do
#  command "service kafka-server start"
#end





# kafka - create topic
=begin
if ! kafka-topics --list --zookeeper localhost:2181  | grep "^events$"  > dev/null
then    echo "topic not exists"
else echo "topic exists"
fi
=end
execute "kafka - create topic" do
  command lazy {
    %Q(
if ! kafka-topics --list --zookeeper  #{data['zookeeper']['url']}  | grep "^#{data['rocana']['kafka_topic_name']}$"  > dev/null
then    kafka-topics --create --zookeeper #{data['zookeeper']['url']} --replication-factor 1 --partitions 2 --topic #{data['rocana']['kafka_topic_name']}
else echo "topic exists"
fi
    )

  }
end
#"kafka-topics --create --zookeeper #{data['zookeeper']['url']} --replication-factor 1 --partitions 2 --topic #{data['rocana']['kafka_topic_name']}"



### hdfs


execute "hdfs prepare" do
  command [
    'hdfs dfs -mkdir -p /user/rocana',
    'hdfs dfs -chown rocana:rocana /user/rocana',
    'hdfs dfs -mkdir -p /datasets/rocana',
  'hdfs dfs -chown hdfs:hdfs /datasets',
  'hdfs dfs -chmod 1777 /datasets',
  'hdfs dfs -chown rocana:rocana /datasets/rocana',
  'hdfs dfs -chmod 750 /datasets/rocana'

  ].join(" && ")

  user 'hdfs'
end




### anomalies
execute "hdfs - anomalies" do
  command [
              'hdfs dfs -mkdir -p /user/impala/udfs',
          ].join(" && ")

  user 'hdfs'
end


# udf for impala
directory '/opt/rocana/lib/rocana-tools/' do
  owner 'root'
  group 'root'
  mode '0775'

  recursive true
  action :create
end

cookbook_file '/opt/rocana/lib/rocana-tools/com.rocana-rocana-impala-udfs-1.0.0-linux-x86_64-rhel.so' do
  source 'master/rocana/com.rocana-rocana-impala-udfs-1.0.0-linux-x86_64-rhel.so'

  owner 'root'
  group 'root'
  mode '0775'
  action :create
end


execute 'copy udf file to hdfs' do
  command [
              'hdfs dfs -put /opt/rocana/lib/rocana-tools/com.rocana-rocana-impala-udfs-1.0.0-linux-x86_64-rhel.so /user/impala/udfs/librocana-udfs.so',
              "hdfs dfs -chown -R impala:impala /user/impala/udfs"
  ].join(' && ')

  user 'hdfs'

  # TODO: remove here. it is just debug
  ignore_failure true
end




