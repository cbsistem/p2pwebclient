# installs it on clients that are found to not currently have a copy
python vxargs-0.3.3.py -y --timeout=1600 -a planetlab_hosts.txt -o output/superstall1 ssh byu_p2p@{} "if [ ! -f "~/p2pwebclient/src/listener.rb" ]; then rm i386.tar.*; wget http://wilkboardonline.com/p2p/i386.tar.gz; tar -xzf i386.tar.gz; rm i386.tar.gz;  rm p2pwebclient.tar.gz*; wget http://wilkboardonline.com/p2p/p2pwebclient.tar.gz; tar -xzf p2pwebclient.tar.gz; rm p2pwebclient.tar.gz; fi;"

