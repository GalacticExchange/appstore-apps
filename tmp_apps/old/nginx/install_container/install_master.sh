# RUN on API sever.
# provision cluster

echo "---------- Provisioning Master"

#
#knife zero bootstrap 51.1.0.221 --ssh-user cloudera --node-name master


# provision
#knife zero converge "name:master" --ssh-user cloudera  --json-attributes ../config/config.json --override-runlist rocana::master

#
#knife ssh "name:master" --ssh-user vagrant touch /tmp/5.txt




