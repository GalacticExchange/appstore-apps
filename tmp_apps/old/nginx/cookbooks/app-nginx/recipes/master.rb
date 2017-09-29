
# debug
file '/tmp/master-nginx.txt' do
  content "node: #{node.normal.inspect}"
end

data = node.normal

