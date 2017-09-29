require 'spec_helper'


class RocanaSettings
  def self.dir_base
    '/opt/rocana/rocana-1.4.2/'
  end

  def self.cmd_source
    'source /opt/gex/rocana-env.sh'
  end

end



describe "rocana" do
  before(:all) do


    #@image = Docker::Image.build_from_dir('docker/redis/')
    #@image = Docker::Image.create('fromImage' => 'elasticsearch:2.3.3')

    #puts "data=#{Docker::Container.inspect}"
    #container = Docker::Container.create('Cmd' => ['ls'], 'Image' => 'base')

    #rows = Docker::Container.all(all: true, filters: { label: [ "rocana"  ]  }.to_json)
    #puts "data=#{rows}"

    @container = Docker::Container.get('rocana')

    #puts "cont = #{@container.id}"
    #exit

    set :os, family: :debian
    set :backend, :docker
    set :docker_container, @container.id
    #set :docker_image, @image.id
    #set :docker_container_create_options, {'Cmd' => ['/usr/local/bin/jenkins.sh']}
  end

  describe command("whoami") do
    it "debug" do
      expect(subject.stdout).to match(/root/)
    end
  end

  #describe command('cat /etc/centos-release') do
  #  it "centos version" do
  #    expect(subject.stdout).to match(/centos/i)
  #    expect(subject.stdout).to match(/6.8/)
  #  end
  #end

  # TODO: check network
  describe command("ifconfig") do
    #it "ip" do
    #  expect(subject.stdout).to match(/123/)
    #end
  end


  describe command("java -version 2>&1") do
    it "java version" do
      expect(subject.stdout).to match(/1.7./)
    end
  end

  describe "rocana installation basic" do
    describe command("ls /opt/rocana") do
      it "dir exists" do
        expect(subject.stdout).to match(/rocana/)
      end
    end

    describe 'rocana env files' do
      describe file('/opt/gex/rocana-env') do
        it { should exist }
      end
      describe file('/opt/gex/rocana-env.sh') do
        it { should exist }
      end
    end

  end

  describe "rocana data tool" do
    describe file("#{RocanaSettings.dir_base}/conf/event-producer.properties") do
      its(:content) { should match /kafka.brokers *= *#{$server_config['kafka']['broker']}/ }
      its(:content) { should match /producer.topic *= *#{$server_config['rocana']['kafka_topic_name']}/ }
    end

  end

  describe "rocana agent" do
    # config
    describe file("#{RocanaSettings.dir_base}conf/rocana-agent/agent.conf") do
      its(:content) { should match /brokers: "*#{$server_config['kafka']['broker']}"/ }
      its(:content) { should match /events-topic: *"#{$server_config['rocana']['kafka_topic_name']}"/ }
    end


    # process
    #sudo ps aux | grep rocana-agent
    #rocana   31143  0.1  0.0 349044  8864 pts/9    Sl   06:03   0:00 /opt/rocana/rocana-1.4.2/lib/rocana-agent/rocana-agent /opt/rocana/rocana-1.4.2/conf/rocana-agent

    describe process("rocana-agent") do
      it "running" do
        expect(subject).to be_running
      end
    end

  end


  describe 'hdfs' do

    # data in hdfs /datasets
    describe command("su - rocana -c '#{RocanaSettings.cmd_source} && #{RocanaSettings.dir_base}bin/rocana-data --list --repo repo:hdfs://#{$server_config['master']['host']}:8020/datasets/rocana '") do
      it "exist" do
        expect(subject.stdout).to match(/#{$server_config['rocana']['kafka_topic_name']}/)
      end
    end


  end



  describe 'hdfs-consumer' do
    # running
    #describe process("rocana-hdfs-consumer") do
    #  it "rocana-hdfs-consumer is running" do
    #    expect(subject).to be_running
    #  end
    #end

    describe 'process rocana-hdfs-consumer' do
      it 'running' do
        res = command(%Q(ps aux | grep rocana-hdfs-consumer)).stdout
        expect(res).to match(/app=rocana-hdfs-consumer/)
      end

    end



    # send message
    describe 'hdfs consumer works' do
      it "send message" do
        dnow = Time.now
        sd = dnow.to_s

        n = Random.rand(100)+1

        res = command(
            %Q(echo "<#{n}>#{sd} hdfstest-thisisatest simlogging[17155]: This is a log.info() message" | nc localhost 17320)
        ).stdout

        # TODO: check data in hdfs
        #hdfs dfs -ls -R /datasets/rocana
        # su - hdfs bashc -c"hdfs dfs -ls -R /datasets/rocana/default/events"

        # | grep year / month /
        #  /datasets/rocana/default/events/year=2016/month=06/day=07/87c78397-0c1e-4680-b9e6-70655dbab6c9.parquet

        #This should return a list of subdirectories and files, including one .parquet file under a date-organized path.

        # check with rocana
        #bin/rocana-data --cat --repo repo:hdfs://quickstart.cloudera:8020/datasets/rocana --name events

        expect(res).to match(//)
      end
    end

  end


  describe 'solr-consumer' do

    describe 'process rocana-solr-consumer' do
      it 'running' do
        res = command(%Q(ps aux | grep rocana-solr-consumer)).stdout
        expect(res).to match(/app=rocana-solr-consumer/)
      end

    end

    describe 'solr data events' do
      it "exists events" do
        raise 'TODO: not implemented'
        # check collection events exists
        #http://localhost:8983/solr/#/~cloud
        res = ''
        expect(res).to match(//)
      end

      it 'send test data' do
        raise 'TODO: not implemented'
        #bin/rocana-data --event-gen --event-size 300 --num-clients 1 --num-events 100 --use-text
        # check collection in solr

      end

      it 'text search in solr' do
        raise 'TODO: not implemented'
        # send message
        #echo "<94>Apr 12 20:07:15 hostname simlogging[17155]: This is a log.info() message"| nc localhost 17320

        # execute query in Solr UI
        #q=thisisatest
        # View activity in the metrics UI at
        #http://quickstart.cloudera:17311/metrics?pretty=true

      end
    end

  end


  describe 'metric-consumer' do

    it 'config' do
      raise 'todo'
    end


  end

  ### postgresql
  describe 'postgresql' do
    it 'db exists' do
      #su - postgres bash -c "psql -c \"\l \" "
      cmd = %Q(su - postgres bash -c "psql -c \\"\l\\"")
      res = command(cmd).stdout
      expect(res).to match(/rocana/)

    end
  end



  ### webapp
  describe 'webapp' do
    it 'process running' do
      res = command(%Q(ps aux | grep rocana-webapp)).stdout
      expect(res).to match(/app=rocana-webapp/)
    end

    it 'access http page' do
      #http://localhost:8081

      output = command(%Q(curl -X GET http://localhost:8081)).stdout
      expect(output).to match(/<html>/)

    end
  end




  describe 'ports' do
    it 'ports listening' do
      ports = [17310, 17320, 8081, 5432, 17315]
      cmd = "netcat -z -v localhost 1-50000"
      output = command(cmd).stdout

      ports.each do |port|
        expect(output).to match /\s+#{port}\s+/
      end



    end


  end

  describe 'remote connections' do

    # hdfs
    describe host($server_config['hdfs']['host']) do
      # ping
      it { should be_reachable }

      # hdfs
      it { should be_reachable.with( :port => 8020, :proto => 'tcp' ) }
    end


    # zookeeper
    describe host($server_config['zookeeper']['host']) do
      it { should be_reachable }
      it { should be_reachable.with( :port => $server_config['zookeeper']['port'], :proto => 'tcp' ) }
    end


    # kafka
    describe host($server_config['kafka']['host']) do
      it { should be_reachable }
      # 9092 - kafka broker
      it { should be_reachable.with( :port => 9092, :proto => 'tcp' ) }
    end


  end




  describe 'global test' do
    it 'send message' do
=begin
# test - send message
echo "<94>May 26 10:07:05 webtest simlogging[17155]: test gex 1 This is a log.info() message" | nc localhost 17320

# check
# hdfs:
su - hdfs
hdfs dfs -ls -R /datasets/rocana/default/events


# test data
bin/rocana-data --cat --repo repo:hdfs://quickstart.cloudera:8020/datasets/rocana --name events

=end
      raise 'TODO'

    end
  end
end


