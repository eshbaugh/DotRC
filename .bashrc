# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
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

#RedHat/Centos
alias vids='vi /etc/systemd/system/docker.service'
alias syc=SysCtl
function SysCtl() {
  sudo systemctl "$@" 
}


alias cfi=CountFiles
function CountFiles() {
  find "$@" -type f | wc -l  
}

#solr
alias jtz='bin/solr start -cloud -s /tmp/solr-node1 -p 8983 -z localhost:2181'

source ~/.jerry

#docker
alias dk=Docker
function Docker {
  docker "$@"
}
alias dkp='docker ps -a'
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

alias rbb='docker run -ti --rm --net=farmtoschoolcensus-fns-usda-net busybox'

#git
alias gta='git add .'
alias gtd='git diff'
alias gts='git status'
alias gtv='git remote -v'
alias gtph='git push'
alias gtpl='git pull'
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
alias cdt='cd /app/test'
alias cdv='cd /mnt/cloud-backup'
alias tl='cat /var/log/rsync*'
alias shs=HighState 
function HighState() { 
  > /var/log/salt/minion 
  > /var/log/salt/master 
  echo "HighState..." 
  salt "$@" '*' state.highstate
  echo "Minion Log----------" 
  cat /var/log/salt/minion 
  echo "Master Log----------" 
  cat /var/log/salt/master 
} 
alias sas=ApplyState 
function ApplyState() { 
  > /var/log/salt/minion 
  > /var/log/salt/master 
  echo "Apply state..." 
  salt -G 'role:web' state.apply "$@" 
  echo "Minion Log----------" 
  cat /var/log/salt/minion 
  echo "Master Log----------" 
  cat /var/log/salt/master 
} 
alias sns=NetworkApplyState 
function NetworkApplyState() { 
  > /var/log/salt/minion 
  > /var/log/salt/master 
  echo "Apply network state..." 
  salt -G 'role:sysop' state.apply docker/network
  echo "Minion Log----------" 
  cat /var/log/salt/minion 
  echo "Master Log----------" 
  cat /var/log/salt/master 
} 
alias scs=ConsulApplyState 
function ConsulApplyState() { 
  > /var/log/salt/minion 
  > /var/log/salt/master 
  echo "ConsulState..." 
  salt -G 'role:sysop' state.apply consul/init
  echo "Minion Log----------" 
  cat /var/log/salt/minion 
  echo "Master Log----------" 
  cat /var/log/salt/master 
} 
alias szs=ZooApplyState 
function ZooApplyState() { 
  > /var/log/salt/minion 
  > /var/log/salt/master 
  echo "ZooState..." 
  salt -G 'role:sysop' state.apply zoo
  salt -G 'role:sysop' state.apply zoo/zk-web
  echo "Minion Log----------" 
  cat /var/log/salt/minion 
  echo "Master Log----------" 
  cat /var/log/salt/master 
} 
alias sbs=BackupApplyState 
function BackupApplyState() { 
  > /var/log/salt/minion 
  > /var/log/salt/master 
  echo "BackupState..." 
  salt -G 'role:web' state.apply cloud-backup/backup
  echo "Minion Log----------" 
  cat /var/log/salt/minion 
  echo "Master Log----------" 
  cat /var/log/salt/master 
} 
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

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi
