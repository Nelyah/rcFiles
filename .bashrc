

# Environnement variable
#export PATH="/home/chloe/blast-2.2.26:/home/chloe/ncbi-blast-2.2.30+/bin:/usr/local/bin:/usr/local/opt/coreutils/libexec/gnubin:/home/chloe/eclipse/:/home/chloe/Document/sblm2/:$PATH"
export PATH="/usr/local/bin:/usr/local/opt/coreutils/libexec/gnubin:$PATH:/home/chloe/bin"
export JET2_HOME=/home/chloe/JET2/
export EDITOR=vim
export LD_LIBRARY_PATH=/home/chloe/lib/qhull-2012.1/lib:$LD_LIBRARY_PATH
#export `gnome-keyring-daemon`

/usr/bin/gnome-keyring-daemon --start --components=gpg,pkcs11,secrets,ssh > /dev/null
export GNOME_KEYRING_CONTROL GNOME_KEYRING_PID GPG_AGENT_INFO SSH_AUTH_SOCK

if [ "$TERM" != "dumb" ]; then
    export LS_OPTIONS='--color=auto'
    eval `dircolors ~/.dircolors`
fi

# Couleurs du préfix du terminal
NONE="\[\033[0;33m\]" 
NM="\[\033[0;38m\]" 
HI="\[\033[0;35m\]" 
HII="\[\033[0;36m\]" 
SI="\[\033[0;33m\]"
IN="\[\033[0m\]"
  
export PS1="$SI\w$HI Chloé $ $IN"


# ls with color
alias ls="ls --color=always" 
alias grep="grep --color=always"
alias egrep="egrep --color=always"



# Aliases
alias ll='ls -lh'
alias lla='ls -lha'
alias ..='cd ..'
alias rm='rm -i'
alias rebash='source ~/.bashrc'
alias ssh@nivose='ssh dequeker@nivose.informatique.univ-paris-diderot.fr'
alias ssh@jussieu='ssh 3403263@ssh.ufr-info-p6.jussieu.fr'
alias ssh@ppti='ssh dequeker@ssh.ufr-info-p6.jussieu.fr'
alias irssi@freenode='irssi -c chat.freenode.net -p 6667 -n Nelyah'
alias irc='weechat-curses'
alias ssh@cluster='ssh dequeker@cluster'
alias ssh@nas='ssh dequeker@rackstation'
alias rsync@res='rsync -avz /home/chloe/lib/resultsChloe/ dequeker@RackStation:/volume1/Dequeker/backup/resultsChloe'

# Useful function
function up( ) {
    LIMIT=$1
    P=$PWD
    for ((i=1; i <= LIMIT; i++))
    do
        P=$P/..
    done
    cd $P
    export MPWD=$P
}

function back( ) {
    if [ -z $1 ]
    then 
        cd $P
        return
    fi
    LIMIT=$1
    P=$MPWD
    for ((i=1; i <= LIMIT; i++))
    do
        P=${P%/..}
    done
    cd $P
    export MPWD=$P
}

# Ctrl-z switch back to term. Now it allows to come back
#fancy-ctrl-z () {
#    if [[ $#BUFFER -eq 0 ]]; then
#        BUFFER="fg"
#        zle accept-line
#    else
#        zle push-input
#        zle clear-screen
#    fi
#}
#zle -N fancy-ctrl-z
#bindkey '^Z' fancy-ctrl-z
