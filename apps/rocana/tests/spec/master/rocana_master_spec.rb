require 'spec_helper'

def send_command(cmd)
  Net::SSH.start(ENV['TARGET_HOST'], ENV['SSH_USER'], :password => ENV['SSH_PASSWORD']) do |ssh|
    return ssh.exec! cmd
  end
end

opt = $server_config

##
describe 'server' do

#  before(:all) do

    #set :target_host, host
    #set :os, family: :centos
    #set :backend, :docker
#  end

  describe command("ifconfig") do
    it "debug" do
      expect(subject.stdout).to match(/51.1.0.221/)
    end
  end


  describe command("java -version 2>&1") do
    it "java version" do
      expect(subject.stdout).to match(/1.7./)
    end
  end



  ### kafka
  describe command("sudo kafka-topics --list --zookeeper #{opt['zookeeper']['url']}") do
    it "kafka topic created" do
      expect(subject.stdout).to match(/#{$server_config['rocana']['kafka_topic_name']}/)
    end
  end


  ### hdfs


  ### metric-consumer

  describe 'metric-consumer' do

    it 'tables in hive' do
      raise 'TODO'

      # hive
      # show tables;
      # good response:
      #OK
      #metrics
      #Time taken: 0.145 seconds, Fetched: 3 row(s)

    end

    it 'metric-consumer data in hive' do
      #impala-shell -i <impala host>
      #> use default;
      #> invalidate metadata metrics;
      #> select count(*) from metrics;
=begin
      This should return something like:
                                       Query: select count(*) from metrics
      +----------+
      | count(*) |
          +----------+
      | 71566 |
          +----------+
          Fetched 1 row(s) in 7.76s
      [cdh2.example.com:21000] > exit;
=end


    end
  end


  ### Anomalies

  # data in hive
  #Verify that the repository was created properly by ensuring the anomalies table exists in Hive.
  # hive
  # hive> use default;
  # show tables;
  #This should return something like:
  #OK
  #anomalies - !!!
  #metrics
  #Time taken: 0.151 seconds, Fetched: 4 row(s)

  # data in hdfs
  # check file exist /user/impala/udfs/librocana-udfs.so
  # check permissions
  # impala:impala /user/impala/udfs



end
