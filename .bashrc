# .bashrc
# User specific aliases and functions

alias rm='rm -i' 
alias cp='cp -i' 
alias mv='mv -i' 
alias ll='ls -alrut' 
alias lt='ls -alrut' 
alias h='history' 
alias cdp='cd /srv/pillar' 
alias cds='cd /srv/salt' 
alias cdt='cd /app/test'
alias cdv='cd /mnt/cloud-backup'
alias tl='cat /var/log/rsync*'
alias vib='vi ~/.bashrc ; source ~/.bashrc'
alias viv='vi ~/.vimrc'

alias ds1='docker exec -ti solr1 bash'
alias ds2='docker exec -ti solr2 bash'
alias dz1='docker exec -ti zookeeper bash'
alias dpa='docker ps -a'

alias ga='git add .'
alias gd='git diff'
alias gs='git status'
alias gv='git remote -v'

alias cfi=CountFiles
function CountFiles() {
  find "$@" -type f | wc -l  
}

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

alias dcomp=DockerCompose 
function DockerCompose { 
  docker-compose "$@" 
} 

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi
