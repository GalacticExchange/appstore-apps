#!/usr/bin/env bash

#tty true
#export PATH=$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin:/opt/ibm/imaserver/bin
#env ['PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin:/opt/ibm/imaserver/bin']

sudo mkdir -p /etc/chef
sudo chown zoomdata:zoomdata -R /etc/chef

sudo chown zoomdata:zoomdata -R /tmp


#change zoomdata password
echo "password" | sudo passwd zoomdata --stdin
#echo "password" | sudo passwd zoomdata
#echo "zoomdata:password" | chpasswd

# change default shell
echo "password" | chsh -s /bin/sh

sudo chsh -s /bin/sh

#sudo chown zoomdata:zoomdata -R /tmp/
echo "Internal script done!"
echo $SHELL


