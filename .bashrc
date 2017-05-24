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

alias s='sudo su -'

#linux
alias rm='rm -i' 
alias cp='cp -i' 
alias mv='mv -i' 
alias ll='ls -alhrt' 
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
alias cdcu='cd /home/cloud-user'
alias syc=SysCtl
function SysCtl() {
  sudo systemctl "$@" 
}

alias cfi=CountFiles
function CountFiles() {
  find "$@" -type f | wc -l  
}

#Web Site Tests
# Usage: curlhost snap2skills.usda.gov
# If the IP needs to changed ping prod.wcmaas.usda.gov
alias curlhost=CurlHost
function CurlHost() {
  curl -k  https://199.134.75.34 -H "host:$@"
}

#docker

alias dk=Docker
function Docker {
  docker "$@"
}

alias dkp='docker ps -a'

alias dkpa=DockerPsAll
function DockerPsAll () {
  salt '*' cmd.run 'docker ps -a'
}

alias dknlsa=DockerNetStat
function DockerNetStat() {
  salt '*' cmd.run 'docker network ls'
}

alias dkrma='docker rm -fv `docker ps -qa`'
alias dkrmi='docker rmi `docker images -q`'

alias dkrmac=RemoveAllContainers 
function RemoveAllContainers() {
  echo "Removing all containers "
  salt '*' cmd.run 'docker rm -fv `docker ps -qa`'
  salt '*' cmd.run 'docker ps -a'
}

alias dkrmnet=RemoveAllNetworks 
function RemoveAllNetworks() {
  echo "Removing all Networks "
  salt '*' cmd.run 'docker network rm `docker network ls -q`'
  salt '*' cmd.run 'docker network ls'
}

# This is a prototype it does work if you call with the network ID, but the messages reported are misleading
alias dkrmnetend=RemoveAllNetworkEndpoints
function RemoveAllNetworkEndpoints {
  docker network inspect "$@" -f '{{range $element :=  .Containers}} {{printf "%s\n" $element.Name}} {{end}}' >> /tmp/netlist_junk

  while read line; do
    echo $line
    docker network disconnect -f "$@" $line
  done < /tmp/netlist_junk
}



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
alias sdm=SwitchDockerMachine
function SwitchDockerMachine() {
  eval "$(docker-machine env "$@")"
}

alias rbb='docker run -ti --rm busybox'

#git
alias gta='git add .'
alias gtd='git diff'
alias gtds='git diff --staged'
alias gts='git status'
alias gtv='git status; git remote -v'
alias gtph='git push'
alias gtpha=' cd ~/DotRC; git push; cd /srv/pillar; git push; cd /srv/salt; git push'
alias gtpl='git pull'
alias gtpla=' cd ~/DotRC; git pull; cd /srv/pillar; git pull; cd /srv/salt; git pull; cd /srv/gov-zookeeper; git pull; cd ~/private; git pull; cd ~/DevOps; git pull'
alias gtsa=' cd ~/DotRC; git status; cd /srv/pillar; git status; cd /srv/salt; git status; cd /srv/gov-zookeeper; git status; cd ~/private; git status; cd ~/DevOps; git status'


alias gtct=GitCommit
function GitCommit {
  git commit -m "$@"
}
alias gtco=GitCheckout
function GitCheckout {
  git checkout "$@"
}
alias gtrv=GitRevert
function GitRevert {
  rm -i "$@"
  git checkout "$@"
}

#WebDav
alias cad='cadaver https://www.cloudvault.usda.gov/remote.php/webdav/'

#Ansible
alias anp=AnsiblePlaybook
function AnsiblePlaybook {
  ansible-playbook "$@"
}

#SaltStack
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
#  salt '*' --state-output=mixed state.highstate 
  salt '*' state.highstate 
  CatLogs
} 

alias ssd=SiteDeploy 
function SiteDeploy() { 
  ClearLogs
  echo "SiteDeploy * ..." 
  salt '*' state.apply site-deploy 
  CatLogs
} 

alias all=AllState 
function AllState() { 
  /srv/salt/clean.sh
  HighState
  SiteDeploy
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
  salt $WEB1 --state-output=mixed state.highstate 
  CatLogs
}
alias shs2=HighState2
function HighState2() {
  ClearLogs
  echo "High state web 2..."
  salt $WEB2 --state-output=mixed state.highstate
  CatLogs
}
alias shs3=HighState3
function HighState3() {
  ClearLogs
  echo "High state web 3..."
  salt $WEB3 --state-output=mixed state.highstate
  CatLogs
}
alias sas1=ApplyState1
function ApplyState1() {
  ClearLogs
  echo "Apply zoo state web 1..."
  salt $WEB1 state.apply zoo
  CatLogs
}
alias sas2=ApplyState2
function ApplyState2() {
  ClearLogs
  echo "Apply zoo state web 2..."
  salt $WEB2 state.apply zoo
  CatLogs
}
alias sas3=ApplyState3
function ApplyState3() {
  ClearLogs
  echo "Apply zoo state web 3..."
  salt $WEB3 state.apply zoo
  CatLogs
}
alias s1=RemoteStateWeb1
function RemoteStateWeb1 {
  salt $WEB1 $@
}

alias s2=RemoteStateWeb1
function RemoteStateWeb1 {
  salt $WEB2 $@
}

alias s1c=RemoteStateWeb1
function RemoteStateWeb1 {
  salt $WEB1 cmd.run $@
}
alias s2c=RemoteStateWeb2
function RemoteStateWeb2 {
  salt $WEB2 cmd.run $@
}



#Zookeeper

alias zk=ZK
function ZK(){
  arg="$@"
  echo "ZooKeeper wildcard:" $arg

  salt $WEB1 cmd.run "docker exec   snaped.fns.usda.gov_"$WEB1H"_zookeeper /opt/zookeeper/bin/zkServer.sh $arg"
  salt $WEB2 cmd.run "docker exec   snaped.fns.usda.gov_"$WEB2H"_zookeeper /opt/zookeeper/bin/zkServer.sh $arg"
  salt $WEB3 cmd.run "docker exec   snaped.fns.usda.gov_"$WEB3H"_zookeeper /opt/zookeeper/bin/zkServer.sh $arg"
}


#solr
alias jtz='bin/solr start -cloud -s /tmp/solr-node1 -p 8983 -z localhost:2181'

alias solrrun=SolrRun
function SolrRun() {
  echo "Running solr on web1"

  echo "create solr container"
#  salt -G 'role:zookeeper' state.apply solr
  salt $WEB1 state.apply solr
}

alias solr=Solr 
function Solr(){
  arg="$@" 
  echo "Solr wildcard:" $arg 

  salt $WEB1 cmd.run "docker exec $SOLR1 /opt/solr/bin/solr $arg"
  salt $WEB2 cmd.run "docker exec $SOLR2 /opt/solr/bin/solr $arg"
  salt $WEB3 cmd.run "docker exec $SOLR3 /opt/solr/bin/solr $arg"

}

alias solrcol=SolrCollection
function SolrCollection() {
  echo "Solr wildcard:" $arg 
  salt $WEB1 cmd.run "docker exec  snaped.fns.usda.gov_"$WEB1H"_solr bin/solr create_collection -c test -p 8983 -d /opt/solr/server" 
}

alias rsab='cp -rf ~/.ssh/id_rsa-bitbucket ~/.ssh/id_rsa'
alias rsag='cp -rf ~/.ssh/id_rsa-git ~/.ssh/id_rsa'


# Rancher

alias rssh=RancherSsh
function RancherSsh() {
  arg="$@" 
  rancherssh %$arg%
}
