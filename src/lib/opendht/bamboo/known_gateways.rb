$opendht_gateways = {
 # allow for special cases
 # don't have any currently
 # '155.98.35.2' => 3640, # planetlab1.flux.utah.edu
 # 3640 -> put in 3641 in your browser to get the right number
 # '155.98.35.3' => 3642,
 # '155.98.35.4' => 3640,
 # '155.98.35.5' => 3632,
}

normal_port = ['155.98.35.5', '155.98.35.6', '155.98.35.7']
for name in normal_port
 $opendht_gateways[name] = 3630
end
