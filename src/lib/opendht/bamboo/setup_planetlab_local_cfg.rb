require 'erb'
require '../../ruby_useful_here'
name = "openhash_planetlab_local.cfg"
node_number = 1
port1 = 3630 + 1

require 'known_gateways' # $opendht_gateways
gateways = $opendht_gateways

am_gateway = false
if gateways[Socket.get_host_ip] 
 # you are a gateway!
 port1 = gateways[Socket.get_host_ip]
 am_gateway = true
end

gateways.each_key{|k|
 gateways[k] += 0
}
require 'pp'
pp 'gateways are', gateways
a = File.open name, 'w'
a.write ERB.new(File.read('openhash_generic.erb')).result(binding)
a.close
print 'wrote to ', name, "\n"

