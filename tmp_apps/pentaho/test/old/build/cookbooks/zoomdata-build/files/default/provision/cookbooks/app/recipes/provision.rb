
file '/tmp/app.txt' do
  content 'RESULT of provisioning from inside'
end

file '/tmp/app-data.txt' do
  content "node: #{node.normal.inspect}"
end




#cmds = [
#    "apt-get install iputils-ping",
#    "apt-get install netcat",#
#
#




### systemd for nginx
template "/etc/systemd/system/nginx.service" do
  source 'nginx.service.erb'

  variables({node: node})
  owner 'root'
  group 'root'
  mode '0775'
end

### index.html
template "/var/www/html/index.html" do
  source 'index.html.erb'

  variables({node: node})
  owner 'root'
  group 'root'
  mode '0775'
end


### start nginx
#execute "start nginx" do
#  command "service nginx start"
#end


