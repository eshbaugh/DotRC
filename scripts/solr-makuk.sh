#!/usr/bin/env bash

############################################################
source /home/cloud-user/.private_bashrc
############################################################
# You need to create a similar file that contains the folowing
# 
#export MY_CERT='/home/your-user/.ssh/your-private-key'
#export MY_USER='your-user'
#export NET_NAME='your-docker-overlay-network-already-created-net'
#
#export WEB1_IP=''
#export WEB2_IP=''
#export WEB3_IP=''
############################################################

############### Setup vars ####################
# the IP address for the container
ZK1_IP=192.168.22.10
ZK2_IP=192.168.22.11
ZK3_IP=192.168.22.12

ZKSOLR1_IP=192.168.22.20 
ZKSOLR2_IP=192.168.22.21 
ZKSOLR2_IP=192.168.22.22 

NET_NAME=solrnet

#docker network create --driver=overlay --subnet 192.168.22.0/24 --ip-range=192.168.22.128/25 $NET_NAME

# the Docker image
ZK_IMAGE=jplock/zookeeper

############### Create the zoo containers Setup vars ####################
#ssh -n -i $MY_CERT $MY_USER@$WEB1_IP "sudo docker pull jplock/zookeeper && sudo docker create --ip=$ZK1_IP --net $NET_NAME --name zk1 --hostname=zk1 --add-host zk2:$ZK2_IP --add-host zk3:$ZK3_IP -it $ZK_IMAGE"
#ssh -n -i $MY_CERT $MY_USER@$WEB2_IP "sudo docker pull jplock/zookeeper && sudo docker create --ip=$ZK2_IP --net $NET_NAME --name zk2 --hostname=zk2 --add-host zk1:$ZK1_IP --add-host zk3:$ZK3_IP -it $ZK_IMAGE"
#ssh -n -i $MY_CERT $MY_USER@$WEB3_IP "sudo docker pull jplock/zookeeper && sudo docker create --ip=$ZK3_IP --net $NET_NAME --name zk3 --hostname=zk3 --add-host zk1:$ZK1_IP --add-host zk2:$ZK2_IP -it $ZK_IMAGE"


####################  Copy the zoo config witi the container ######################
#cat ./conf/zoo.cfg | ssh  -i $MY_CERT $MY_USER@$WEB1_IP 'dd of=zoo.cfg.tmp && sudo docker cp zoo.cfg.tmp zk1:/opt/zookeeper/conf/zoo.cfg && rm zoo.cfg.tmp'
#cat ./conf/zoo.cfg | ssh  -i $MY_CERT $MY_USER@$WEB2_IP 'dd of=zoo.cfg.tmp && sudo docker cp zoo.cfg.tmp zk2:/opt/zookeeper/conf/zoo.cfg && rm zoo.cfg.tmp'
#cat ./conf/zoo.cfg | ssh  -i $MY_CERT $MY_USER@$WEB3_IP 'dd of=zoo.cfg.tmp && sudo docker cp zoo.cfg.tmp zk3:/opt/zookeeper/conf/zoo.cfg && rm zoo.cfg.tmp'

#echo 1 | ssh -i $MY_CERT $MY_USER@$WEB1_IP  'dd of=myid && sudo docker cp myid zk1:/tmp/zookeeper/myid && rm myid'
#echo 2 | ssh -i $MY_CERT $MY_USER@$WEB2_IP 'dd of=myid && sudo docker cp myid zk2:/tmp/zookeeper/myid && rm myid'
#echo 3 | ssh -i $MY_CERT $MY_USER@$WEB3_IP 'dd of=myid && sudo docker cp myid zk3:/tmp/zookeeper/myid && rm myid'


######################## Start the containers ##############################
#ssh -n -i $MY_CERT $MY_USER@$WEB1_IP 'sudo docker start zk1'
#ssh -n -i $MY_CERT $MY_USER@$WEB2_IP 'sudo docker start zk2'
#ssh -n -i $MY_CERT $MY_USER@$WEB3_IP 'sudo docker start zk3'

# Optional: verify containers are running
#ssh -n -i $MY_CERT $MY_USER@$WEB1_IP 'sudo docker ps'
#ssh -n -i $MY_CERT $MY_USER@$WEB2_IP 'sudo docker ps'
#ssh -n -i $MY_CERT $MY_USER@$WEB3_IP 'sudo docker ps'

# Optional: inspect IP addresses of the containers BROKE
#ssh -n -i $MY_CERT $MY_USER@$WEB1_IP "sudo docker inspect --format '{{ .NetworkSettings.Networks.solrnet.IPAddress }}' zk1"
#ssh -n -i $MY_CERT $MY_USER@$WEB2_IP "sudo docker inspect --format '{{ .NetworkSettings.Networks.solrnet.IPAddress }}' zk2"
#ssh -n -i $MY_CERT $MY_USER@$WEB3_IP "sudo docker inspect --format '{{ .NetworkSettings.Networks.solrnet.IPAddress }}' zk3"

# Optional: verify connectivity and hostnames  BROKE
#ssh -n -i $MY_CERT $MY_USER@$WEB1_IP 'sudo docker run --rm --net $NET_NAME -i ubuntu bash -c "echo -n zk1,zk2,zk3 | xargs -n 1 --delimiter=, /bin/ping -c 1"'
#ssh -n -i $MY_CERT $MY_USER@$WEB2_IP 'sudo docker run --rm --net $NET_NAME -i ubuntu bash -c "echo -n zk1,zk2,zk3 | xargs -n 1 --delimiter=, /bin/ping -c 1"'
#ssh -n -i $MY_CERT $MY_USER@$WEB3_IP 'sudo docker run --rm --net $NET_NAME -i ubuntu bash -c "echo -n zk1,zk2,zk3 | xargs -n 1 --delimiter=, /bin/ping -c 1"'

# Optional: verify cluster got a leader
#ssh -n -i $MY_CERT $MY_USER@$WEB1_IP "sudo docker exec -i zk1 bash -c 'echo stat | nc localhost 2181'"
#ssh -n -i $MY_CERT $MY_USER@$WEB2_IP "sudo docker exec -i zk2 bash -c 'echo stat | nc localhost 2181'"
#ssh -n -i $MY_CERT $MY_USER@$WEB3_IP "sudo docker exec -i zk3 bash -c 'echo stat | nc localhost 2181'"

# Optional: verify we can connect a zookeeper client. This should show the `[zookeeper]` znode.
#printf "ls /\nquit\n" | ssh -i $MY_CERT $MY_USER@$WEB1_IP sudo docker exec -i zk1 /opt/zookeeper/bin/zkCli.sh


################## SOLR #########################

SOLR_IMAGE=solr

#HOST_OPTIONS="--add-host zk1:$ZK1_IP --add-host zk2:$ZK2_IP --add-host zk3:$ZK3_IP"
#ssh -n -i $MY_CERT $MY_USER@$WEB1_IP "sudo docker pull $SOLR_IMAGE && sudo docker create --ip=$ZKSOLR1_IP --net $NET_NAME --name zksolr1 --hostname=zksolr1 -it $HOST_OPTIONS $SOLR_IMAGE"
#ssh -n -i $MY_CERT $MY_USER@$WEB2_IP "sudo docker pull $SOLR_IMAGE && sudo docker create --ip=$ZKSOLR2_IP --net $NET_NAME --name zksolr2 --hostname=zksolr2 -it $HOST_OPTIONS $SOLR_IMAGE"
#ssh -n -i $MY_CERT $MY_USER@$WEB3_IP "sudo docker pull $SOLR_IMAGE && sudo docker create --ip=$ZKSOLR3_IP --net $NET_NAME --name zksolr3 --hostname=zksolr3 -it $HOST_OPTIONS $SOLR_IMAGE"

#for h in zksolr1 zksolr2 zksolr3; do
#  cp -f ./conf/solr.in.sh /tmp/solr.in.sh-$h
#  sed -i -e 's/#ZK_HOST=""/ZK_HOST="zk1:2181,zk2:2181,zk3:2181"/' /tmp/solr.in.sh-$h
#  sed -i -e 's/#*SOLR_HOST=.*/SOLR_HOST="'$h'"/' /tmp/solr.in.sh-$h
#done

# ISSUE Geting an ERROR  for zksolr1...  dd: failed to open ‘solr.in.sh’: Permission denied
# I had to sneaker net the changes maually
#cat /tmp/solr.in.sh-zksolr1 | ssh -i $MY_CERT $MY_USER@$WEB1_IP "dd of=solr.in.sh && sudo docker cp solr.in.sh zksolr1:/opt/solr/bin/solr.in.sh && rm solr.in.sh"
#cat /tmp/solr.in.sh-zksolr2 | ssh -i $MY_CERT $MY_USER@$WEB2_IP "dd of=solr.in.sh && sudo docker cp solr.in.sh zksolr2:/opt/solr/bin/solr.in.sh && rm solr.in.sh"
#cat /tmp/solr.in.sh-zksolr3 | ssh -i $MY_CERT $MY_USER@$WEB3_IP "dd of=solr.in.sh && sudo docker cp solr.in.sh zksolr3:/opt/solr/bin/solr.in.sh && rm solr.in.sh"

#ssh -n -i $MY_CERT $MY_USER@$WEB1_IP sudo docker start zksolr1
#ssh -n -i $MY_CERT $MY_USER@$WEB2_IP sudo docker start zksolr2
#ssh -n -i $MY_CERT $MY_USER@$WEB3_IP sudo docker start zksolr3

# Optional: print IP addresses to verify
#ssh -n -i $MY_CERT $MY_USER@$WEB1_IP 'sudo docker inspect --format "{{ .NetworkSettings.Networks.$NET_NAME.IPAddress }}" zksolr1'
#ssh -n -i $MY_CERT $MY_USER@$WEB2_IP 'sudo docker inspect --format "{{ .NetworkSettings.Networks.$NET_NAME.IPAddress }}" zksolr2'
#ssh -n -i $MY_CERT $MY_USER@$WEB3_IP 'sudo docker inspect --format "{{ .NetworkSettings.Networks.$NET_NAME.IPAddress }}" zksolr3'

# Optional: check logs
ssh -n -i $MY_CERT $MY_USER@$WEB1_IP sudo docker logs zksolr1
ssh -n -i $MY_CERT $MY_USER@$WEB2_IP sudo docker logs zksolr2
ssh -n -i $MY_CERT $MY_USER@$WEB3_IP sudo docker logs zksolr3

# Optional: check the webserver
ssh -n -i $MY_CERT $MY_USER@$WEB1_IP "sudo docker exec -i zksolr1 /bin/bash -c 'wget -O -  http://zksolr1:8983/'"
#ssh -n -i $MY_CERT $MY_USER@$WEB2_IP "sudo docker exec -i zksolr2 /bin/bash -c 'wget -O -  http://zksolr2:8983/'"
#ssh -n -i $MY_CERT $MY_USER@$WEB3_IP "sudo docker exec -i zksolr3 /bin/bash -c 'wget -O -  http://zksolr3:8983/'"

