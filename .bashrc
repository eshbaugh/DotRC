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

#
# General helper aliases
#
alias cdes='cd /etc/systemd/system'
alias vids='vi /etc/systemd/system/docker.service'

#
# Linux
#
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

alias sshnb=SshNoBanner
function SshNoBanner(){
  # Display only error messages and ingnoring any banners that may be displayed
  # For a more comprehensive solution checkout https://github.com/Russell91/sshrc
  ssh -o LogLevel=error "$@"
}

alias sshap=SshAskPass
function SshAskPass() {
  # Troubleshooting
  #  Open KDEWallet App in GUI and look for Access controll entry
  #  If this fails to bring up the password dialog try disabling
  #     and renabling the KDE wallet
  export SSH_ASKPASS=/usr/bin/ksshaskpass
  #setsid export DISPLAY=/usr/bin/ssh
  # Issue  does not use remote display, stays local
  setsid ssh -J jeshbaugh@localhost -f localhost xterm 
}

alias crh='curl -k https://www.redhat.com/en'

#
# RedHat/Centos
#
alias cdcu='cd /home/cloud-user'
alias syc=SysCtl
function SysCtl() {
  sudo systemctl "$@" 
}

alias cfi=CountFiles
function CountFiles() {
  find "$@" -type f | wc -l  
}

alias rhsm=SubscriptionManager
function SubscriptionManager() {
  subscription-manager "$@"
}


#
# Network 
#

# Host Spoofing  
# Usage: curlhost ip_address hostname 
# Example: curlhost http://127.0.0.1 example.com
alias curlhost=CurlHost
function CurlHost() {
  echo "Param 1:$1   Param 2:$2"
  curl -k "$1 -H host:$2"
}

#
# Docker
#
alias dk=Docker
function Docker {
  sudo docker "$@"
}

alias dkp='sudo docker ps -a'

# Remove all containers
alias dkrma='sudo docker rm -fv `sudo docker ps -qa`'

# Remove all images
alias dkrmi='sudo docker rmi `sudo docker images -q`'


# This is a prototype it does work if you call with the network ID, but the messages reported are misleading
alias dkrmnetend=RemoveAllNetworkEndpoints
function RemoveAllNetworkEndpoints {
  sudo docker network inspect "$@" -f '{{range $element :=  .Containers}} {{printf "%s\n" $element.Name}} {{end}}' >> /tmp/netlist_junk

  while read line; do
    echo $line
    sudo docker network disconnect -f "$@" $line
  done < /tmp/netlist_junk
}

alias dkn=DockerNetwork
function DockerNetwork() {
  sudo docker network "$@"
}

alias dkr=DockerRun
function DockerRun {
  sudo docker run -d "$@"
}

alias dke=DockerExec
function DockerExec {
  sudo docker exec -ti "$@" /bin/bash
}

alias dkes=DockerExecSh
function DockerExecSh {
  sudo docker exec -ti "$@" /bin/sh
}

alias dcomp=DockerCompose 
function DockerCompose { 
  sudo docker-compose "$@" 
} 

# Docker Machine
alias dkm=DockerMachine
function DockerMachine() {
  sudo /usr/local/bin/docker-machine "$@" 
}
alias sdm=SwitchDockerMachine
function SwitchDockerMachine() {
  eval "$(sudo docker-machine env "$@")"
}

alias rbb='sudo docker run -ti --rm busybox'

#
# Salty Docker
#
alias dkpa=DockerPsAll
function DockerPsAll () {
  salt '*' cmd.run 'docker ps -a'
}

alias dknlsa=DockerNetStat
function DockerNetStat() {
  salt '*' cmd.run 'docker network ls'
}

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


#
# Git
#
alias gta='git add .'
alias gtd='git diff'
alias gtds='git diff --staged'
alias gts='git status'
alias gtv='git status; git remote -v'
alias gtph='git push'
alias gtpl='git pull'
alias gtch='git config --global credential.helper cache'

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


#
# SaltStack
#
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


#
# Rancher
#
alias rssh=RancherSsh
function RancherSsh() {
  arg="$@" 
  rancherssh %$arg%
}

#
# OpenShift
#

# Analysis 
alias ocsv='oc get services'
alias ocpd='oc get pods'
alias ocpdw='oc get pods -w'
alias ocpr='oc projects'
alias ocgtr='oc get is'
alias occv='oc config view'
alias ocar=AddUserClusterRoll
function AddUserClusterRoll() {
  user="$@" 
  oc adm policy add-cluster-role-to-user cluster-admin $user
}


#  Commands
alias oceuninstall=OpenShiftUninstall
function OpenShiftUninstall() {
  ansible-playbook "$@" /usr/share/ansible/openshift-ansible/playbooks/adhoc/uninstall.yml 
}


#
# Ansible
#
alias anp=AnsiblePlaybook
function AnsiblePlaybook {
  ansible-playbook "$@"
}


#
#  Postgres 
#

alias ocpgm='oc rsh $(oc get pods -l role=masterdb -o jsonpath='\''{.items[0].metadata.name}'\'')'
