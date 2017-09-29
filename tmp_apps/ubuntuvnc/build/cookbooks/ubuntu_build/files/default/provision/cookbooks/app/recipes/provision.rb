
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
