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
        setup_all
    fi
fi


setup_bashrc () {
    case $OS in
    Linux)
        cp confFiles/bashrc ${HOME}/.bashrc
        ;;
    Darwin)
        cp confFiles/bashrc ${HOME}/.bash_profile
        ;;
    esac
}

setup_screenrc () {
    cp confFiles/screenrc ${HOME}/.screenrc
}

setup_gitconfig () {
    cp confFiles/gitconfig ${HOME}/.gitconfig
}

setup_dircolors () {
    cp confFiles/dircolors ${HOME}/.dircolors
}

setup_rcFiles () {
    echo -n "Setting up rc files..."
    setup_bashrc
    setup_screenrc
    setup_gitconfig
    setup_dircolors
    echo " Done."
}

vim_dein () {
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
        sed -r -i '' "s|(set\ runtimepath\+=).*$|\1${INSTALL_DIR}|" vimPlug/vimrc
        ;;
    Darwin)
        sed -E -i '' "s|(set\ runtimepath\+=).*$|\1${INSTALL_DIR}|" vimPlug/vimrc
        ;;
    esac

    echo $(pwd)
    cp vimPlug/vimrc ${HOME}/.vim/

    if [[ ! -L ${HOME}/.vimrc ]];
    then
        ln -s ${HOME}/.vim/vimrc ${HOME}/.vimrc
    fi

    vim -c "call dein#install()|q"
    vim -c "call dein#update()|q"

    if [[ ! -z $(grep "Valloric/YouCompleteMe" vimPlug/vimrc) ]];
    then
        echo "YouCompleteMe is installed"
        echo -n "Copying the YCM config file into ${HOME}/.vim/.ycm_extra_conf.py..."
        cp vimPlug/.ycm_extra_conf.py ${HOME}/.vim/
        echo " Done."
        echo "Compiling YCM ..."
        cd ~/.vim/dein/repos/github.com/Valloric/YouCompleteMe/
        ./install.py --clang-completer
        cd $OLDPWD
    fi

}

setup_vim () {

    echo "Setting up vim..."

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
        if [[ $(whoami) == "root" ]];
        then
            sudo apt-get install libncurses5-dev libgnome2-dev libgnomeui-dev \
                    libgtk2.0-dev libatk1.0-dev libbonoboui2-dev \
                    libcairo2-dev libx11-dev libxpm-dev libxt-dev python-dev \
                    ruby-dev lua5.3 liblua5.3-dev liblua5.3-0 git

            sudo apt-get remove vim vim-runtime gvim
        fi

        if [[ -d vim/ ]];
        then
            cd vim/
            git pull
        else
            git clone https://github.com/vim/vim.git
            cd vim
        fi

        # If we aren't root, then let's hope that we have the right libraries
        # Else you may need to tweak these features
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

        if [[ $(whoami) == "root" ]];
        then
           sudo make install

            sudo update-alternatives --install /usr/bin/editor editor /usr/bin/vim 1
            sudo update-alternatives --set editor /usr/bin/vim
            sudo update-alternatives --install /usr/bin/vi vi /usr/bin/vim 1
            sudo update-alternatives --set vi /usr/bin/vim
            cd $SETUP_DIR
        else
            echo "Please run the vim setup as root if you want to install it."
            echo ""
        fi
        cd $OLDPWD
    ;;
    Darwin)
        if type vim ;
        then
            echo -n "Vim already installed. Upgrading via homebrew..."
            brew upgrade vim
            echo " Done."
        else
            echo -n "Vim is not installed yet, installing via homebrew..."
            brew install vim
            echo " Done."
        fi
    ;;
    esac

    echo -n "Setting the color theme directory in vim..."
    mkdir -p ${HOME}/.vim/
    cp -r vimPlug/colors/ ${HOME}/.vim/
    echo " Done."

    echo "Setting up dein plugin manager..."
    vim_dein
    echo "Done."

}

setup_all () {
    setup_vim
    setup_rcFiles
}


echo $#
while [[ $# -ge 1 ]];
do
    arg=$1
    case $arg in
        vim)
            setup_vim
            shift
        ;;
        bashrc)
            setup_bashrc
            shift
        ;;
        screenrc)
            setup_screenrc
            shift
        ;;
        dircolors)
            setup_dircolors
            shift
        ;;
        gitconfig)
            setup_gitconfig
            shift
        ;;
        rcFiles)
            setup_rcFiles
            shift
        ;;
        i3)
            echo "do i3"
            shift
        ;;
    esac
done
