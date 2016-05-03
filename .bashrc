# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Source private definitions
if [ -f ~/.private_bashrc ]; then
  . ~/.private_bashrc
fi

# User specific aliases and functions

#linux
alias rm='rm -i' 
alias cp='cp -i' 
alias mv='mv -i' 
alias ll='ls -alrut' 
alias lt='ls -alrut' 
alias h='history' 
alias vib='vi ~/.bashrc ; source ~/.bashrc'
alias viv='vi ~/.vimrc'
alias gri='cat /etc/*release'
alias vig=ViGrep
function ViGrep(){ 
  vi `grep -rl "$@"`
}

#RedHat/Centos
alias vids='vi /etc/systemd/system/docker.service'
alias cdes='cd /etc/systemd/system'
alias syc=SysCtl
function SysCtl() {
  sudo systemctl "$@" 
}


alias cfi=CountFiles
function CountFiles() {
  find "$@" -type f | wc -l  
}



#docker
alias dk=Docker
function Docker {
  docker "$@"
}
alias dkp='docker ps -a'
alias dkrma='docker rm -fv `docker ps -qa`'
alias dkn=DockerNetwork
function DockerNetwork() {
  docker network "$@"
}
alias dkr=DockerRun
function DockerRun {
  docker run -d "$@"
}
alias dke=DockerExec
function DockerExec {
  docker exec -ti "$@" /bin/bash
}
alias dcomp=DockerCompose 
function DockerCompose { 
  docker-compose "$@" 
} 

# Docker Machine
alias dkm=DockerMachine
function DockerMachine() {
  /usr/local/bin/docker-machine "$@" 
}
alias sdm1='sdm easjerrysolr-1'
alias sdm2='sdm easjerrysolr2'
alias sdm=SwitchDockerMachine
function SwitchDockerMachine() {
  eval "$(docker-machine env "$@")"
}


alias rbb='docker run -ti --rm --net=farmtoschoolcensus-fns-usda-net busybox'

#consul
alias coni='consul info -rpc-addr=192.168.25.32:8400'
alias conm='consul members -rpc-addr=192.168.25.32:8400'

#git
alias gta='git add .'
alias gtd='git diff'
alias gts='git status'
alias gtv='git remote -v'
alias gtph='git push'
alias gtpha=' cd ~/DotRC; git push; cd /srv/pillar; git push; cd /srv/salt; git push'
alias gtpl='git pull'
alias gtpla=' cd ~/DotRC; git pull; cd /srv/pillar; git pull; cd /srv/salt; git pull; cd /srv/gov-zookeeper; git pull'


alias gtct=GitCommit
function GitCommit {
  git commit -m "$@"
}
alias gtco=GitCheckout
function GitCheckout {
  git checkout "$@"
}



#WebDav
alias cad='cadaver https://www.cloudvault.usda.gov/remote.php/webdav/'

#salt
alias cdp='cd /srv/pillar' 
alias cds='cd /srv/salt' 
alias cdz='cd /srv/gov-zookeeper'
alias cdt='cd /app/test'
alias cdv='cd /mnt/cloud-backup'
alias tl='cat /var/log/rsync*'
# cluster management with salt
alias stp='salt "*" test.ping' 
function ClearLogs() {
  echo "###############################################################################"
  > /var/log/salt/minion
  > /var/log/salt/master 
  echo "Minion and Master Salt Logs Cleared"
}
function CatLogs() {
  echo "Minion Log----------" 
  cat /var/log/salt/minion 
  echo "Master Log----------" 
  cat /var/log/salt/master 
}
alias shs=HighState 
function HighState() { 
  ClearLogs
  echo "HighState * ..." 
  salt '*' --state-output=mixed state.highstate 
  CatLogs
} 
alias shss=HighStateSysOp
function HighStateSysOp() {
  ClearLogs
  echo "High state SysOp..."
  salt 'stage-sysop.novalocal' --state-output=mixed state.highstate
  CatLogs
}
alias shs1=HighState1 
function HighState1() {
  ClearLogs
  echo "High state web 1..." 
# --state-output=mixed # --state-verbose=false
  salt 'stage-web1.novalocal' --state-output=mixed state.highstate 
  CatLogs
}
alias shs2=HighState2
function HighState2() {
  ClearLogs
  echo "High state web 2..."
  salt 'stage-web2.novalocal' --state-output=mixed state.highstate
  CatLogs
}
alias sas1=ApplyState1
function ApplyState1() {
  ClearLogs
  echo "Apply solr state web 1..."
  salt 'stage-web1.novalocal' state.apply solr
  CatLogs
}
alias sas2=ApplyState2
function ApplyState2() {
  ClearLogs
  echo "Apply zoo state web 2..."
  salt 'stage-web2.novalocal' state.apply zoo
  CatLogs
}
alias sas3=ApplyState3
function ApplyState3() {
  ClearLogs
  echo "Apply zoo state web 3..."
  salt 'stage-web3.novalocal' state.apply zoo
  CatLogs
}
alias s1=RemoteStateWeb1
function RemoteStateWeb1 {
  salt 'stage-web1.novalocal' $@
}

alias s2=RemoteStateWeb1
function RemoteStateWeb1 {
  salt 'stage-web2.novalocal' $@
}

alias s1c=RemoteStateWeb1
function RemoteStateWeb1 {
  salt 'stage-web1.novalocal' cmd.run $@
}
alias s2c=RemoteStateWeb2
function RemoteStateWeb2 {
  salt 'stage-web2.novalocal' cmd.run $@
}


#Zookeeper

alias zkcpid="salt -G 'role:zookeeper' state.apply zoo/copy-myid"
alias zkweb="salt -G 'role:zookeeper' state.apply zoo/zk-web"

alias zkstat=ZooKeeperStatus 
function ZooKeeperStatus(){
  echo "Zookeeper status"
  salt 'stage-web1.novalocal' cmd.run 'docker exec   snaped.fns.usda.gov_stage-web1_zookeeper  /opt/zookeeper/bin/zkServer.sh status'
  salt 'stage-web2.novalocal' cmd.run 'docker exec   snaped.fns.usda.gov_stage-web2_zookeeper  /opt/zookeeper/bin/zkServer.sh status'
  salt 'stage-web3.novalocal' cmd.run 'docker exec   snaped.fns.usda.gov_stage-web3_zookeeper  /opt/zookeeper/bin/zkServer.sh status'
}
alias zkstart=ZooKeeperStart
function ZooKeeperStart() {
  echo "Zookeeper Start"
  salt 'stage-web1.novalocal' cmd.run 'docker exec   snaped.fns.usda.gov_stage-web1_zookeeper  /opt/zookeeper/bin/zkServer.sh start'
  salt 'stage-web2.novalocal' cmd.run 'docker exec   snaped.fns.usda.gov_stage-web2_zookeeper  /opt/zookeeper/bin/zkServer.sh start'
  salt 'stage-web3.novalocal' cmd.run 'docker exec   snaped.fns.usda.gov_stage-web3_zookeeper  /opt/zookeeper/bin/zkServer.sh start'
}
alias zkstop=ZooKeeperStop 
function ZooKeeperStop() {
  echo "Zookeeper stop"
  salt 'stage-web1.novalocal' cmd.run 'docker exec   snaped.fns.usda.gov_stage-web1_zookeeper  /opt/zookeeper/bin/zkServer.sh stop'
  salt 'stage-web2.novalocal' cmd.run 'docker exec   snaped.fns.usda.gov_stage-web2_zookeeper  /opt/zookeeper/bin/zkServer.sh stop'
  salt 'stage-web3.novalocal' cmd.run 'docker exec   snaped.fns.usda.gov_stage-web3_zookeeper  /opt/zookeeper/bin/zkServer.sh stop'
}
alias zkrun=ZooKeeperRun 
function ZooKeeperRun() {
  echo "Zookeeper total startup"

  echo "removing all containers  total startup"
  salt -G 'role:zookeeper' cmd.run 'docker rm -fv `docker ps -qa`'

  echo "creating all zoo containers"
  salt -G 'role:zookeeper' state.apply zoo

  echo "stop all zoo processes"
  ZooKeeperStop

  echo "Install zk web"
  salt -G 'role:zookeeper' state.apply zoo/zk-web

  echo "copy my id"
  salt -G 'role:zookeeper' state.apply zoo/copy-myid

  echo "start zookeper processes"
  ZooKeeperStart

  ZooKeeperStatus

}

#solr
alias jtz='bin/solr start -cloud -s /tmp/solr-node1 -p 8983 -z localhost:2181'

alias solrrun=SolrRun
function SolrRun() {
  echo "Running solr on web1"

  echo "create solr container"
  salt 'stage-web1.novalocal' state.apply solr 
  
}

