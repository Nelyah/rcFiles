# Environnement variable

if [[ -z $OLDPATH ]];
then
    export OLDPATH=$PATH
fi

export PATH="$HOME/bin:$HOME/dev/go/bin:/usr/local/bin:/usr/local/opt/coreutils/libexec/gnubin:$PATH"
export PYTHONPATH=$PYTHONPATH:/usr/share/pdb2pqr
export EDITOR=vim

# If the software is installed
if [[ $(type fzf) ]]; then
    source /usr/share/fzf/completion.bash
    source /usr/share/fzf/key-bindings.bash
fi

gnome-keyring-daemon --start --components=gpg,pkcs11,secrets,ssh > /dev/null
export GNOME_KEYRING_CONTROL GNOME_KEYRING_PID GPG_AGENT_INFO SSH_AUTH_SOCK

if [ "$TERM" != "dumb" ]; then
    export LS_OPTIONS='--color=auto'
    eval `dircolors ~/.dircolors`
fi

# Prefix colours for terminal
NONE="\[\033[0;33m\]" 
NM="\[\033[0;38m\]" 
HI="\[\033[00;38;5;212m\]" 
HII="\[\033[0;36m\]" 
SI="\[\033[00;38;5;214m\]"
IN="\[\033[0m\]"

# Those are the PC names and user names I use 
# most of the time
LIST_PC=@LIST_PC@
LIST_USER=@LIST_USER@

# Testing if this user is a common one
KNOWN_USER=1 
for e in ${LIST_USER[@]}; 
do 
    [[ $e == $(whoami) ]] && KNOWN_USER=0 && break
done

if [[ $KNOWN_USER == 0 ]]
then
    PS1_USER="@USER_FIRSTNAME2@"
else
    PS1_USER=$(whoami)
fi

# Testing if this hostname is a known one
KNOWN_HOST=1 
for e in ${LIST_PC[@]}; 
do 
    [[ $e == $(hostname --short) ]] && KNOWN_HOST=0 && break
done

if [[ $KNOWN_HOST == 0 ]]
then
    PS1_HOST=""
else
    PS1_HOST="@$(hostname --short)"
fi
export PS1="$SI\w$HI ${PS1_USER}${PS1_HOST} $ $IN"

# ls with colour
alias ls="ls --color=always" 
alias grep="grep --color=always"
alias egrep="egrep --color=always"

# Aliases
alias ll='ls -lh'
alias lla='ls -lha'
alias llt='ls -lht'
alias llta='ls -lhta'
alias llth='ls -lht | head'
alias rm='rm -i'
alias rebash='source ~/.bashrc'
alias irssi@freenode=@ALIAS_IRSSI_FREENODE@
alias irc='weechat-curses'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# Useful function
function pac(){
    CMD_PACMAN=/usr/bin/pacaur
    case $1 in
        update|up)
            sudo $CMD_PACMAN -Syu
        ;;
        install) 
            shift
            sudo $CMD_PACMAN -S $@
        ;;
        remove)
            shift
            sudo $CMD_PACMAN -Rns $@
        ;;
        *)
            sudo $CMD_PACMAN $@
        ;;
    esac
}
