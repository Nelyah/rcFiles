#! /bin/bash

OS=$(uname)

if [[ $# -eq 0 ]];
then
    echo "No argument."
    echo "vim will be set up."
    echo "The following config files will be set up :"
    echo "bashrc, dircolors, gitconfig, screenrc"
    if [[ $OS == "Linux" ]];
    then
        echo "i3 will be setup."
    fi
    read -p "Do you want to continue ? [Yy] " -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        echo "coucou !"
    fi
fi

echo $#
while [[ $# -ge 1 ]];
do
    arg=$1
    case $arg in 
        vim) 
            echo "do vim"
            shift
        ;;
        bashrc) 
            echo "do bashrc"
            shift
        ;;
        screenrc) 
            echo "do screenrc"
            shift
        ;;
        dircolors) 
            echo "do dircolors"
            shift
        ;;
        gitconfig) 
            echo "do gitconfig"
            shift
        ;;
        rcFiles) 
            echo "do rcFiles"
            shift
        ;;
        i3)
            echo "do i3"
            shift
        ;;
    esac
done


setup_vim () {

    # check git command. Mandatory for the plugin manager
    if type git ; 
    then
      : # You have git command. No Problem.
    else
      echo 'Please install git or update your path to include the git executable!'
      exit 1
    fi
    case $OS in
    Linux)
        sudo apt-get install libncurses5-dev libgnome2-dev libgnomeui-dev \
                libgtk2.0-dev libatk1.0-dev libbonoboui2-dev \
                libcairo2-dev libx11-dev libxpm-dev libxt-dev python-dev \
                ruby-dev git

        sudo apt-get remove vim vim-runtime gvim

        if [[ -d vim/ ]];
        then 
            cd vim/
            git pull
        else
            git clone https://github.com/vim/vim.git
            cd vim
        fi
        ./configure --with-features=huge \
           --enable-multibyte \
           --enable-rubyinterp \
           --enable-pythoninterp \
           --with-python-config-dir=/usr/lib/python2.7/config \
           --enable-perlinterp \
           --enable-luainterp \
           --with-lua-prefix=/usr/include/lua5.3 \
           --enable-gui=gtk2 --enable-cscope --prefix=/usr
           make VIMRUNTIMEDIR=/usr/share/vim/vim80
           sudo make install

        sudo update-alternatives --install /usr/bin/editor editor /usr/bin/vim 1
        sudo update-alternatives --set editor /usr/bin/vim
        sudo update-alternatives --install /usr/bin/vi vi /usr/bin/vim 1
        sudo update-alternatives --set vi /usr/bin/vim
    ;;
    Darwin)
        if type vim ;
        then
            brew install vim
        else
            brew upgrade vim
        fi
    ;;
    esac
    PLUGIN_DIR=${HOME}/.vim/dein/
    INSTALL_DIR="${PLUGIN_DIR}/repos/github.com/Shougo/dein.vim"
    if [ -e "$INSTALL_DIR" ]; then
        echo "\"$INSTALL_DIR\" already exists!"
    else
        echo "Begin fetching dein..."
        mkdir -p "$PLUGIN_DIR"
        git clone https://github.com/Shougo/dein.vim "$INSTALL_DIR"
        echo "Done."
        echo ""
    fi

    case $OS in
    Linux)
        sed -ri "s|(set\ runtimepath\+=).*$|\1${INSTALL_DIR}|" vimPlug/vimrc
        ;;
    Darwin)
        sed -Ei "s|(set\ runtimepath\+=).*$|\1${INSTALL_DIR}|" vimPlug/vimrc
        ;;
    esac
    cp vimPlug/vimrc ${HOME}/.vim/
    ln -s ${HOME}/.vim/vimrc ${HOME}/.vimrc

    if [[ ! -z $(grep "Valloric/YouCompleteMe" vimPlug/vimrc) ]];
    then 
    #    echo "YouCompleteMe is installed"
    #    echo "Compiling YCM ..."
    #    cd ~/.vim/dein/repos/github.com/Valloric/YouCompleteMe/
    #    ./install.py --clang-completer
    #    cd $OLDPWD
        :
    else
        : #echo paspouet
    fi
}
