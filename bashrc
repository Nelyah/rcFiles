

# Environnement variable
#export PATH="/home/chloe/blast-2.2.26:/home/chloe/ncbi-blast-2.2.30+/bin:/usr/local/bin:/usr/local/opt/coreutils/libexec/gnubin:/home/chloe/eclipse/:/home/chloe/Document/sblm2/:$PATH"
export PATH="/home/chloe/bin/:/usr/local/bin:/usr/local/opt/coreutils/libexec/gnubin:$PATH"
export JET2_HOME=/home/chloe/jet
export EDITOR=vim

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
alias irssi@freenode='irssi -c chat.freenode.net -p 6667 -n Nelyah'
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
