#!/usr/bin/env bash

############### Setup vars ####################
# Host names
ZK1_HOST=trinity10.lan
ZK2_HOST=trinity20.lan
ZK3_HOST=trinity30.lan

# the IP address for the container
ZK1_IP=192.168.22.10
ZK2_IP=192.168.22.11
ZK3_IP=192.168.22.12

# the Docker image
ZK_IMAGE=jplock/zookeeper

############### Create the zoo containers Setup vars ####################
ssh -n $ZK1_HOST "docker pull jplock/zookeeper && docker create --ip=$ZK1_IP --net netzksolr --name zk1 --hostname=zk1 --add-host zk2:$ZK2_IP --add-host zk3:$ZK3_IP -it $ZK_IMAGE"
ssh -n $ZK2_HOST "docker pull jplock/zookeeper && docker create --ip=$ZK2_IP --net netzksolr --name zk2 --hostname=zk2 --add-host zk1:$ZK1_IP --add-host zk3:$ZK3_IP -it $ZK_IMAGE"
ssh -n $ZK3_HOST "docker pull jplock/zookeeper && docker create --ip=$ZK3_IP --net netzksolr --name zk3 --hostname=zk3 --add-host zk1:$ZK1_IP --add-host zk2:$ZK2_IP -it $ZK_IMAGE"


################## Add ZooKeeper nodes to the ZooKeeper config. ################
# If you use hostnames here, ZK will complain with UnknownHostException about the other nodes.
# In ZooKeeper 3.4.6 that stays broken forever; in 3.4.7 that does recover.
# If you use IP addresses you avoid the UnknownHostException and get a quorum more quickly,
# but IP address changes can impact you.
docker cp zk1:/opt/zookeeper/conf/zoo.cfg .
cat >>/tmp/zoo.cfg <<EOM
server.1=zk1:2888:3888
server.2=zk2:2888:3888
server.3=zk3:2888:3888
EOM

cat /tmp/zoo.cfg | ssh $ZK1_HOST 'dd of=zoo.cfg.tmp && docker cp zoo.cfg.tmp zk1:/opt/zookeeper/conf/zoo.cfg && rm zoo.cfg.tmp'
cat /tmp/zoo.cfg | ssh $ZK2_HOST 'dd of=zoo.cfg.tmp && docker cp zoo.cfg.tmp zk2:/opt/zookeeper/conf/zoo.cfg && rm zoo.cfg.tmp'
cat /tmp/zoo.cfg | ssh $ZK3_HOST 'dd of=zoo.cfg.tmp && docker cp zoo.cfg.tmp zk3:/opt/zookeeper/conf/zoo.cfg && rm zoo.cfg.tmp'
rm zoo.cfg

echo 1 | ssh $ZK1_HOST  'dd of=myid && docker cp myid zk1:/tmp/zookeeper/myid && rm myid'
echo 2 | ssh $ZK2_HOST 'dd of=myid && docker cp myid zk2:/tmp/zookeeper/myid && rm myid'
echo 3 | ssh $ZK3_HOST 'dd of=myid && docker cp myid zk3:/tmp/zookeeper/myid && rm myid'

################################ Start the zoo containers ######################################
# Add ZooKeeper nodes to the ZooKeeper config.
# If you use hostnames here, ZK will complain with UnknownHostException about the other nodes.
# In ZooKeeper 3.4.6 that stays broken forever; in 3.4.7 that does recover.
# If you use IP addresses you avoid the UnknownHostException and get a quorum more quickly,
# but IP address changes can impact you.
docker cp zk1:/opt/zookeeper/conf/zoo.cfg .
cat >>zoo.cfg <<EOM
server.1=zk1:2888:3888
server.2=zk2:2888:3888
server.3=zk3:2888:3888
EOM

cat zoo.cfg | ssh $ZK1_HOST 'dd of=zoo.cfg.tmp && docker cp zoo.cfg.tmp zk1:/opt/zookeeper/conf/zoo.cfg && rm zoo.cfg.tmp'
cat zoo.cfg | ssh $ZK2_HOST 'dd of=zoo.cfg.tmp && docker cp zoo.cfg.tmp zk2:/opt/zookeeper/conf/zoo.cfg && rm zoo.cfg.tmp'
cat zoo.cfg | ssh $ZK3_HOST 'dd of=zoo.cfg.tmp && docker cp zoo.cfg.tmp zk3:/opt/zookeeper/conf/zoo.cfg && rm zoo.cfg.tmp'
rm zoo.cfg

echo 1 | ssh $ZK1_HOST  'dd of=myid && docker cp myid zk1:/tmp/zookeeper/myid && rm myid'
echo 2 | ssh $ZK2_HOST 'dd of=myid && docker cp myid zk2:/tmp/zookeeper/myid && rm myid'
echo 3 | ssh $ZK3_HOST 'dd of=myid && docker cp myid zk3:/tmp/zookeeper/myid && rm myid'
