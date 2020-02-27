# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

export PS1="\[\033[0;36m\]\[\033[0m\033[0;36m\]\u \[\033[0;37m\]@ \[\033[0;34m\]\h \[\033[00;33m\][\w] \[\033[0;91m\]\$(git_branch) \[\033[00m\]\$ "

export PATH=~/.local/bin:$PATH
#-----------------------------------------------------------------------------#
### Personalized Aliases
#-----------------------------------------------------------------------------#
alias drop1="142.93.125.36"

alias rp-drop1="ssh rpetrie@142.93.125.36"

alias sleep="electricsheep -root"

alias ecs-jump="ssh -i gobiiECS-test.pem ec2-user@18.216.118.186"

alias texliveonfly="python ~/workspace/petrie.main/texliveonfly/texliveonfly.py"

alias aws-api2="ssh gadm@3.135.183.235"

alias bert-rebuild="rm -rfv ~/.m2/repository/ernie/ && cd ~/workspace/gobii.bert && git pull && mvn clean install && cd ~/workspace/gobii.bert-scenarios/ && git pull && mvn clean install"

alias source-all="source ~/.bashrc && source ~/.bash_aliases"

#alias dps='docker ps -a'
alias drm='docker stop $(docker ps -qa) && docker rm $(docker ps -qa) && docker image rm $(docker images) && docker volume rm $(docker volume ls)' # && docker ps -a && docker images && docker volume ls'
alias dps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Image}}\t{{.Ports}}"'
alias dpsa='docker ps -a'
alias dstart='docker start $(docker ps -qa)'
alias dstop='docker stop $(docker ps -qa)'
alias dockx='docker rm $(docker ps -qa)'

alias db-node='docker exec -e COLUMNS="`tput cols`" -e LINES="`tput lines`" -ti gobii-db-node bash'
alias compute-node='docker exec -e COLUMNS="`tput cols`" -e LINES="`tput lines`" -ti gobii-compute-node bash'
alias web-node='docker exec -e COLUMNS="`tput cols`" -e LINES="`tput lines`" -ti gobii-web-node bash'
alias kdc-node='docker exec -e COLUMNS="`tput cols`" -e LINES="`tput lines`" -ti gobii-kdc-node bash'
alias ldap-node='docker exec -e COLUMNS="`tput cols`" -e LINES="`tput lines`" -ti gobii-ldap-node bash'
alias oc-node='docker exec -e COLUMNS="`tput cols`" -e LINES="`tput lines`" -ti gobii-oc-node bash'
alias jenkins-node='docker exec -e COLUMNS="`tput cols`" -e LINES="`tput lines`" -ti jenkins-node bash'

#-----------------------------------------------------------------------------#
### Docker status & stat commands
#-----------------------------------------------------------------------------#

# This will show the current settings for the container at run time
alias dps-status='while true; do clear && echo "#-----------------------------------------------------------------------------#" && echo "### Docker container status" && echo "#-----------------------------------------------------------------------------#" && echo "" && docker ps -a --format "table {{.Names}}\t{{.Status}}\t{{.Image}}\t{{.Ports}}" && sleep 2; done'

# This shows the stats of each container and the resources consumed
alias dps-stats='docker stats --all --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}"'


# File used for personalized Aliases

# Common Commands
alias vi='vim'
#alias mkdir='sudo mkdir'
alias rm='sudo rm'
alias chmod='sudo chmod'
alias chown='sudo chown'
#alias touch='sudo touch'
alias rmdir='sudo rmdir'
#alias cp='sudo cp'
#alias mv='sudo mv'
#alias echo='sudo echo'
alias cl='clear'
alias reboot='sudo reboot'
alias webserv='cd /var/www'
alias x='exit'

# Update/Upgrade/Remove
alias install='sudo apt-get install'
alias remove='sudo apt-get --purge remove'
alias update='sudo apt-get update'
alias upgrade='sudo apt-get upgrade'
alias search='apt-cache search'
alias uu='sudo apt-get update -y && sudo apt-get upgrade -y'
alias uur='sudo apt-get update -y && sudo apt-get upgrade -y && sudo reboot'
alias uucr='sudo apt-get update -y && sudo apt-get upgrade -y && sudo apt-get autoclean && sudo reboot'
alias uucs='sudo apt-get update -y && sudo apt-get upgrade -y && sudo apt-get autoclean && sudo shutdown -P now'
alias deb='sudo dpkg -i'
alias clean='sudo apt-get autoclean'
alias xterminator='exec terminator -e tmux&'

alias vjump='rdesktop -u rpetrie -p go0r@ng3 -g 1280x1024 -a 16 -z -P 10.238.128.156&'

#-----------------------------------------------------------------------------#
### General Aliased Commands
#-----------------------------------------------------------------------------#

alias ll='ls -larth'
alias vialias='vim ~/.bashrc'
alias deb='sudo dpkg -i'
alias vi='vim'
alias yum='sudo yum'

#-----------------------------------------------------------------------------#
### Process Management
###  |-> The following command will create a cross hair to select an open 
###  window. The terminal will display the process ID so it can be killed or 
###  managed otherwise
#-----------------------------------------------------------------------------#
# alias win-process=”xprop _NET_WM_PID | sed 's/_NET_WM_PID(CARDINAL) = //' | ps `cat`”

#-----------------------------------------------------------------------------#
### Remote Access Aliases #
#-----------------------------------------------------------------------------#

alias scgdm='ssh rpetrie@scgdm.bti.cornell.edu' #132.236.81.62

alias gobiis1='ssh gadm@gobiis1.bti.cornell.edu' #132.236.81.50
alias gobiis2='ssh gadm@gobiis2.bti.cornell.edu' #132.236.81.51
alias gobiis3='ssh gadm@gobiis3.bti.cornell.edu' #132.236.81.52
alias gobiis4='ssh gadm@gobiis4.bti.cornell.edu' #132.236.81.53
alias gobiis5='ssh gadm@gobiis5.bti.cornell.edu' #132.236.81.54
alias gobiis6='ssh gadm@gobiis6.bti.cornell.edu' #132.236.81.55
alias gobiis7='ssh gadm@gobiis7.bti.cornell.edu' #132.236.81.56
alias gobiis8='ssh gadm@gobiis8.bti.cornell.edu' #132.236.81.57
alias gobiis9='ssh gadm@gobiis9.bti.cornell.edu' #132.236.81.58
alias gobiis10='ssh gadm@gobiis10.bti.cornell.edu' #132.236.81.59
alias gobiis11='ssh gadm@gobiis11.bti.cornell.edu' #132.236.81.60
# netmask | gateway | DNS
# 255.255.255.0 | 132.236.81.1 | 132.236.56.250

alias lab1='ssh gadm@132.236.81.199' #gobiilab01
alias lab2='ssh gadm@gobiilab02.bti.cornell.edu' #132.236.81.200
alias lab3='ssh rpetrie@gobiilab03.bti.cornell.edu' #132.236.81.210
alias lab4='ssh gadm@gobiilab04.bti.cornell.edu'

alias gobiin1='ssh gadm@gobiin1.bti.cornell.edu' #132.236.81.205
alias gobiin2='ssh gadm@gobiin2.bti.cornell.edu' #132.236.81.206
alias gobiin3='ssh gadm@gobiin3.bti.cornell.edu' #132.236.81.207
alias gobiin4='ssh gadm@gobiin4.bti.cornell.edu' #132.236.81.208

alias cbsufs='ssh root@cbsugobiifs1.biohpc.cornell.edu' #128.84.3.99

alias cbsu1='ssh gadm@cbsugobii01.biohpc.cornell.edu' #128.84.180.101 
alias cbsu2='ssh gadm@cbsugobii02.biohpc.cornell.edu' #128.84.180.102 
alias cbsu3='ssh gadm@cbsugobii03.biohpc.cornell.edu' #128.84.180.103 
alias cbsu4='ssh gadm@cbsugobii04.biohpc.cornell.edu' #128.84.180.104 
alias cbsu5='ssh gadm@cbsugobii05.biohpc.cornell.edu' #128.84.180.105 
alias cbsu6='ssh root@cbsugobii06.biohpc.cornell.edu' #128.84.180.106 
alias cbsu7='ssh root@cbsugobii07.biohpc.cornell.edu' #128.84.180.107 
alias cbsu8='ssh root@cbsugobii08.biohpc.cornell.edu' #128.84.180.108 
alias cbsu9='ssh gadm@cbsugobii09.biohpc.cornell.edu' #128.84.180.109 
alias cbsu10='ssh gadm@cbsugobii10.biohpc.cornell.edu' #128.84.180.117 
alias cbsu11='ssh gadm@cbsugobii11.biohpc.cornell.edu' #128.84.180.118 
alias cbsu12='ssh gadm@cbsugobii12.biohpc.cornell.edu' #128.84.180.119 
alias cbsu13='ssh gadm@cbsugobii13.biohpc.cornell.edu' #128.84.180.41 
alias cbsu14='ssh gadm@cbsugobii14.biohpc.cornell.edu' #128.84.180.42 
alias cbsu15='ssh gadm@cbsugobii15.biohpc.cornell.edu' #128.84.180.43 
alias cbsu16='ssh gadm@cbsugobii16.biohpc.cornell.edu' #128.84.180.44 
# netmask | gateway
# 255.255.254.0 | 128.84.180.1


alias cbsuvm1="ssh gadm@cbsugobiixvm01.biohpc.cornell.edu" #128.84.181.245
alias cbsuvm2="ssh gadm@cbsugobiixvm02.biohpc.cornell.edu" #128.84.181.244
alias cbsuvm3="ssh gadm@cbsugobiixvm03.biohpc.cornell.edu" #128.84.181.243
alias cbsuvm4="ssh gadm@cbsugobiixvm04.biohpc.cornell.edu" #128.84.181.242
alias cbsuvm5="ssh gadm@cbsugobiixvm05.biohpc.cornell.edu" #128.84.181.241
alias cbsuvm6="ssh gadm@cbsugobiixvm06.biohpc.cornell.edu" #128.84.181.240
alias cbsuvm7="ssh gadm@cbsugobiixvm07.biohpc.cornell.edu" #128.84.181.239
alias cbsuvm8="ssh gadm@cbsugobiixvm08.biohpc.cornell.edu" #128.84.181.238
alias cbsuvm9="ssh gadm@cbsugobiixvm09.biohpc.cornell.edu" #128.84.181.237
alias cbsuvm10="ssh gadm@cbsugobiixvm10.biohpc.cornell.edu" #128.84.181.236
alias cbsuvm11="ssh gadm@cbsugobiixvm11.biohpc.cornell.edu" #128.84.181.235
alias cbsuvm12="ssh gadm@cbsugobiixvm12.biohpc.cornell.edu" #128.84.181.234
alias cbsuvm13="ssh gadm@cbsugobiixvm13.biohpc.cornell.edu" #128.84.181.232
alias cbsuvm14="ssh gadm@cbsugobiixvm14.biohpc.cornell.edu" #128.84.181.231
alias cbsuvm15="ssh gadm@cbsugobiixvm15.biohpc.cornell.edu" #128.84.181.230
alias cbsuvm16="ssh gadm@cbsugobiixvm16.biohpc.cornell.edu" #128.84.181.239
alias cbsuvm17="ssh gadm@cbsugobiixvm17.biohpc.cornell.edu" #128.84.181.228
alias cbsuvm18="ssh gadm@cbsugobiixvm18.biohpc.cornell.edu" #128.84.181.227
alias cbsuvm19="ssh gadm@cbsugobiixvm19.biohpc.cornell.edu" #128.84.181.226
alias cbsuvm20="ssh gadm@cbsugobiixvm20.biohpc.cornell.edu" #128.84.181.225
alias cbsuvm21="ssh gadm@cbsugobiixvm21.biohpc.cornell.edu" #128.84.181.224
alias cbsuvm22="ssh gadm@cbsugobiixvm22.biohpc.cornell.edu" #128.84.181.223
alias cbsuvm23="ssh gadm@cbsugobiixvm23.biohpc.cornell.edu" #128.84.181.222
alias cbsuvm24="ssh gadm@cbsugobiixvm24.biohpc.cornell.edu" #128.84.181.221


# netmask | network | broadcast | gateway | dns-nameservers | dns-search
# 255.255.255.0 | 128.84.181.0 | 128.84.181.255 | 128.84.180.1 | 132.236.56.250 128.253.180.2 192.35.82.50 | biohpc.cornell.edu


#-----------------------------------------------------------------------------#
### JHI Alias
#-----------------------------------------------------------------------------#

alias jhi='ssh root@gobii.hutton.ac.uk' #143.234.127.88


#-----------------------------------------------------------------------------#
### AWS Aliases
#-----------------------------------------------------------------------------#

alias aws-gdm01='ssh gadm@3.15.145.17'
# IP/Hostname: ec2-3-15-145-17.us-east-2.compute.amazonaws.com

alias aws-gdm02='ssh gadm@18.224.69.167'
# IP/Hostname: ec2-18-224-69-167.us-east-2.compute.amazonaws.com


alias aws-gdm03='ssh gadm@18.188.171.81'
# IP/Hostname: ec2-18-188-171-81.us-east-2.compute.amazonaws.com

alias aws-gdm04='ssh gadm@13.58.101.156'
# IP/Hostname: ec2-13-58-101-156.us-east-2.compute.amazonaws.com

alias aws-gdm05='ssh gadm@3.17.10.113'
# IP/Hostname: ec2-3-17-10-113.us-east-2.compute.amazonaws.com

alias aws-gdm06='ssh gadm@18.217.120.242'
# IP/Hostname: ec2-18-217-120-242.us-east-2.compute.amazonaws.com

alias aws-gdm07='ssh gadm@3.15.189.111'
# IP/Hostname: ec2-3-15-189-111.us-east-2.compute.amazonaws.com

#-----------------------------------------------------------------------------#
### T3 Wheat [Jean-Luc & Clay] Instance
#-----------------------------------------------------------------------------#

#alias t3-node='ssh rpetrie@128.253.192.87' # tcapg.ag.cornell.edu
alias t3-node='ssh gadm@128.253.192.87' # tcapg.ag.cornell.edu

#-----------------------------------------------------------------------------#
### Cassava Base
#-----------------------------------------------------------------------------#

alias cassava-vm='ssh gadm@cassavabase-gobii.sgn.cornell.edu'

#-----------------------------------------------------------------------------#
### Cornell VPN
#-----------------------------------------------------------------------------#

alias cuvpn='sudo openconnect -v --authgroup CornellVPN -u rlp243 cuvpn.cuvpn.cornell.edu'


#-----------------------------------------------------------------------------#
### Cassava Base
#-----------------------------------------------------------------------------#

alias irri-asti='ssh gadm@202.90.159.55'

#-----------------------------------------------------------------------------#
### Command Prompt coloring and format
#-----------------------------------------------------------------------------#
### INSTRUCTIONS
# Run these commands to configure the command line to show current git with the below export
# ~~~ [Centos7] ~~~
# http://stackoverflow.com/questions/12870928/mac-bash-git-ps1-command-not-found
# curl -o ~/.git-prompt.sh https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
# echo 'source ~/.git-prompt.sh' >> ~/.bash_aliases

#-----------------------------------------------------------------------------#
### COMMAND PROMPT FORMAT
# The below export will configure the commandline to be shown as below and shows current git branch
# COMMAND LINE EXAMPLE
# <username> @ <hostname> <pwd> <(current git branch)> $
# rpetrie @ gobii-notebook-rlp243  ~/workspace/git_main/deploy (master) $ 

#export PS1='\[\033[0;32m\]\[\033[0m\033[0;92m\]\u\[\033[0;36m\] @ \[\033[0;32m\]\h \[\033[0;93m\] \w\[\033[0;91m\] $(__git_ps1) \$ \020\033[0m\]'

#-----------------------------------------------------------------------------#
### Sourced files
#-----------------------------------------------------------------------------#

# Sourced file for displaying current working git branch
source ~/.git-prompt.sh

#-----------------------------------------------------------------------------#
### git
#-----------------------------------------------------------------------------#

# Scripted git push
alias gitp='sh ~/workspace/petrie.main/petrie.scripts/git_push.sh'
alias gitpm='mv template_* ../../git_personal/backup_parameters/ && gitp && cp ../../git_personal/backup_parameters/template_* .'

#-----------------------------------------------------------------------------#
### Terminal Line Scripts
#-----------------------------------------------------------------------------#

alias dboxstatus='while true; do clear && echo "#-----------------------------------------------------------------------------#" && echo "### Dropbox Status" && echo "#-----------------------------------------------------------------------------#" && echo "" && dropbox status && sleep 2; done'

alias insyncstatus='while true; do clear && echo "#-----------------------------------------------------------------------------#" && echo "### Insync Status" && echo "#-----------------------------------------------------------------------------#" && echo "" && insync get_sync_progress && sleep 2; done'

alias pfr-node='ssh gadm@13.238.217.243'

#-----------------------------------------------------------------------------#

alias ebs-node1="ssh devops@192.168.12.102"
alias ebs-node2="ssh devops@192.168.12.103"
alias ebs-node3="ssh devops@192.168.12.104"
alias ebs-node4="ssh devops@192.168.12.105"
alias ebs-node5="ssh devops@192.168.12.106"
alias ebs-node6="ssh devops@192.168.12.107"

#alias ecs-node="cd ~/workspace/ecs && ssh -i gobiiECS-testv2.pem ec2-user@54.159.123.176"

alias pfr-portal="ssh gadm@18.191.126.23"

alias ecs-node1="ssh gadm@18.222.168.199"
alias ecs-node2="ssh gadm@3.133.160.220"
#alias ecs-node3="ssh -i /home/rpetrie/workspace/ecs/gobiiECS-test.pem ec2-user@18.222.168.199"
alias ecs-node3="ssh gadm@3.133.160.220"

alias aws-irri-jump="cd ~/workspace/gobii.aws/ && ssh -i Gobii-Jump.pem ec2-user@54.251.188.0"
