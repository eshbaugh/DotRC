# .bashrc
# User specific aliases and functions

#general
alias rm='rm -i' 
alias cp='cp -i' 
alias mv='mv -i' 
alias ll='ls -alrut' 
alias lt='ls -alrut' 
alias h='history' 
alias vib='vi ~/.bashrc ; source ~/.bashrc'
alias viv='vi ~/.vimrc'
alias gri='cat /etc/*release'

alias cfi=CountFiles
function CountFiles() {
  find "$@" -type f | wc -l  
}

#solr
alias jtz='bin/solr start -cloud -s /tmp/solr-node1 -p 8983 -z localhost:2181'

alias s1='ssh -i /Users/jerrydev/.ssh/jerry jeshbaugh@162.79.27.42'
alias s2='ssh -i /Users/jerrydev/.ssh/jerry jeshbaugh@162.79.27.44'

#docker
alias ds11='docker exec -ti solr11 bash'
alias ds12='docker exec -ti solr12 bash'
alias ds21='docker exec -ti solr21 bash'
alias ds22='docker exec -ti solr22 bash'
alias dz='docker exec -ti zookeeper bash'
alias dpa='docker ps -a'
alias di11='docker inspect solr11|more'
alias di12='docker inspect solr12|more'
alias di21='docker inspect solr21|more'
alias di22='docker inspect solr22|more'
alias dfs='docker exec -ti farmtoschoolcensus.fns.usda.gov bash'
alias dcomp=DockerCompose 
function DockerCompose { 
  docker-compose "$@" 
} 

#git
alias ga='git add .'
alias gd='git diff'
alias gs='git status'
alias gv='git remote -v'


#WebDav
alias cad='cadaver https://www.cloudvault.usda.gov/remote.php/webdav/'

#salt
alias cdp='cd /srv/pillar' 
alias cds='cd /srv/salt' 
alias cdt='cd /app/test'
alias cdv='cd /mnt/cloud-backup'
alias tl='cat /var/log/rsync*'
alias sas=HighApplyState 
function HighApplyState() { 
  > /var/log/salt/minion 
  > /var/log/salt/master 
  echo "Apply state cloud-backup..." 
  salt "$@" '*' state.apply cloud-backup 
  echo "Minion Log----------" 
  cat /var/log/salt/minion 
  echo "Master Log----------" 
  cat /var/log/salt/master 
} 
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
alias sbs=BackupState 
function BackupState() { 
  > /var/log/salt/minion 
  > /var/log/salt/master 
  echo "BackupState..." 
  salt -G 'role:web' state.apply cloud-backup/backup
#  salt -G 'role:web' state.apply cloud-backup/junk
  echo "Minion Log----------" 
  cat /var/log/salt/minion 
  echo "Master Log----------" 
  cat /var/log/salt/master 
} 
alias dkm=DockerMachine
function DockerMachine() {
  docker-machine "$@" 
}
alias sdm=SwitchDockerMachine
function SwitchDockerMachine() {
  eval "$(docker-machine env "$@")"
}

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi
