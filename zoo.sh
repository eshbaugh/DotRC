#!/usr/bin/env bash

# Solr1: publicIP: 162.79.27.42    PrivateIP: 192.168.25.90
# Solr1: publicIP: 162.79.27.44    PrivateIP: 192.168.25.91

if [ $HOSTNAME = "easjerrysolr.novalocal" ]; then
  # This is the host IP for the other server
  SOLR1=solr11
  SOLR2=solr12

elif [ $HOSTNAME = "easjerrysolr2.novalocal" ]; then
  # This is the host IP for the other server
  # TEST BOTH WITH THE SAME NAME
  SOLR1=solr11
  SOLR2=solr22

else
  echo "Unsupported host:" $HOSTNAME
  exit
fi

# Use the same Zookeeper server for both
IP1=192.168.25.90
IP2=192.168.25.91
ZK_PORT=2181

# we need zookeeper running on both hosts or --link zookeeper:ZK failes
echo "running ZK"
if [ $HOSTNAME = "easjerrysolr.novalocal" ]; then
  docker run --name zookeeper -d -p 2181:2181 -p 2888:2888 -p 3888:3888 jplock/zookeeper
fi

IPP1=$IP1':'$ZK_PORT
IPP2=$IP2':'$ZK_PORT

# H1 & H2 '$IPP1','$IPP2' -noprompt'
# Running this on both hosts... 
# zoopop on H2 ERROR: Cannot connect to cluster at 192.168.25.90:2181,192.168.25.91:2181: cluster not found/not ready 

# H1 -z $ZK_PORT_2181_TCP_ADDR:$ZK_PORT_2181_TCP_PORT H2 $IPP1
# populate creates a sol21 shard core on host 1 nothing on H2 
# ERROR: Failed to create collection 'solr21col' due to: org.apache.solr.client.solrj.SolrServerException:Server refused connection at: http://172.17.0.4:8983/solr

# No Prompt H1 -z $ZK_PORT_2181_TCP_ADDR:$ZK_PORT_2181_TCP_PORT H2 $IPP1
# Seems to have no effect

# H1 & H2 -z $ZK_PORT_2181_TCP_ADDR:$ZK_PORT_2181_TCP_PORT 
# No connection as expected, only H2 sees the cores and data
#docker run --name $SOLR1 --link zookeeper:ZK -d -p 8983:8983 solr bash -c '/opt/solr/bin/solr start -f -z $ZK_PORT_2181_TCP_ADDR:$ZK_PORT_2181_TCP_PORT'

# H1 & H2 '$IPP1','$IPP2' -cloud'
#docker run --name $SOLR1 --link zookeeper:ZK -d -p 8983:8983 solr bash -c '/opt/solr/bin/solr start -cloud -f -z '$IPP1','$IPP2

# H1 & H2 '$IPP1','$IPP2' no link zookeeper'
#docker run --name $SOLR1 -d -p 8983:8983 solr bash -c '/opt/solr/bin/solr start -cloud -f -z '$IPP1','$IPP2

# one zookeeper on H1 no link
docker run --name $SOLR1 -d -p 8983:8983 solr bash -c '/opt/solr/bin/solr start -cloud -f -z 192.168.25.90:2181'

docker ps -a

echo "done"
