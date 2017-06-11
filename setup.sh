#! /bin/bash

OS=$(uname)
if [[ ! -z $(grep -E "(ARCH|MANJARO)" <<< $(uname -r)) ]]
then
    ARCHL=1
else
    ARCHL=0
fi
echo $ARCHL

setup_bashrc () {
    case $OS in
    Linux)
        cp conf_files/bashrc ${HOME}/.bashrc
        ;;
    Darwin)
        cp conf_files/bashrc ${HOME}/.bash_profile
        ;;
    esac
}

setup_screenrc () {
    cp conf_files/screenrc ${HOME}/.screenrc
}

setup_gitconfig () {
    cp conf_files/gitconfig ${HOME}/.gitconfig
}

setup_dircolors () {
    cp conf_files/dircolors ${HOME}/.dircolors
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
    echo -n "Setting the color theme directory in vim..."
    mkdir -p ${HOME}/.vim/
    cp -r vimPlug/colors/ ${HOME}/.vim/
    echo " Done."

    # Dein
    echo "Setting up dein plugin manager..."
    PLUGIN_DIR=${HOME}/.vim/dein/
    INSTALL_DIR="${PLUGIN_DIR}/repos/github.com/Shougo/dein.vim"

    # pull the plugin manager from github
    if [ -e "$INSTALL_DIR" ]; then
        echo "\"$INSTALL_DIR\" already exists!"
    else
        echo "Begin fetching dein..."
        mkdir -p "$PLUGIN_DIR"
        git clone https://github.com/Shougo/dein.vim "$INSTALL_DIR"
        echo "Done."
        echo ""
    fi

    # copy the vimrc file into our .vim/ directory
    cp vimPlug/vimrc ${HOME}/.vim/

    # replace some values inside the vimrc
    case $OS in
    Linux)
        sed -r -i "s|(set\ runtimepath\+=).*$|\1${INSTALL_DIR}|" $HOME/.vim/vimrc
        sed -r -i "s|@HOME@|${HOME}|" $HOME/.vim/vimrc

        # if we do NOT install YCM
        # comment the corresponding line
        if [[ $YCM == 1 ]]
        then
            sed -r -i 's/(.*dein#add.*YouCompleteMe.*)/\"\1/' $HOME/.vim/vimrc
        fi
        ;;
    Darwin)
        sed -E -i '' "s|(set\ runtimepath\+=).*$|\1${INSTALL_DIR}|" $HOME/.vim/vimrc
        sed -E -i '' "s|@HOME@|${HOME}|" $HOME/.vim/vimrc
        if [[ $YCM == 1 ]]
        then
            sed -E -i 's/(.*dein#add.*YouCompleteMe.*)/\"\1/' $HOME/.vim/vimrc
        fi
        ;;
    esac

    # link the ~/.vim/vimrc to ~/.vimrc
    if [[ ! -L ${HOME}/.vimrc ]];
    then
        ln -s ${HOME}/.vim/vimrc ${HOME}/.vimrc
    fi

    # Begin plugin installation
    vim -c "call dein#install()|q"

    if [[ $YCM == 0 ]];
    then
        if [[ ! -z $(grep "Valloric/YouCompleteMe" vimPlug/vimrc) ]];
        then
            echo "YouCompleteMe is installed"
            echo -n "Copying the YCM config file into ${HOME}/.vim/.ycm_extra_conf.py..."
            cp vimPlug/.ycm_extra_conf.py ${HOME}/.vim/
            echo " Done."
            echo "Compiling YCM ..."
            cd ~/.vim/dein/repos/github.com/Valloric/YouCompleteMe/

            # ARCH and manjaro users have to use system libclang
            if [[ $ARCHL == 0 ]]
            then
                ./install.py --clang-completer --system-libclang
            else
                ./install.py --clang-completer
            fi
            cd $OLDPWD
        fi
    fi

    vim -c "call dein#update()|q"
}

build_vim() {
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
}

setup(){
    # VIM BUILD
    ##################
    read -p "Do you want to build vim from source (ubuntu only) or install/upgrade it with homebrew (OSX)? [yN] " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        VIM_BUILD=0
    else
        VIM_BUILD=1
        echo "Assuming vim installed."
    fi

    # VIM PLUGIN SETUP
    ##################
    read -p "Do you want to setup vim plugins? [yN] " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        VIM_PLUG=0
        read -p "Do you want to also install YCM? [yN] " -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]
        then
            YCM=0
        else
            YCM=1
        fi
    else
        VIM_PLUG=1
    fi

    # RC FILES
    ##################
    read -p "Do you want to setup all rc files? (.bashrc, .dircolors, screenrc, gitconfig)? [yN] " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        SETUP_RCFILES=0
    else
        SETUP_RCFILES=1
        # CHECK INDIVIDUALLY

        # BASH ENVIRONMENT
        ##################
        read -p "Do you want to setup bashrc and dircolors? [yN] " -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]
        then
            SETUP_BASHRC=0
        else
            SETUP_BASHRC=1
        fi

        # SCREEN ENVIRONMENT
        ##################
        read -p "Do you want to setup the screenrc file? [yN] " -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]
        then
            SETUP_SCREENRC=0
        else
            SETUP_SCREENRC=1
        fi

        # SCREEN ENVIRONMENT
        ##################
        read -p "Do you want to setup the gitconfig file? [yN] " -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]
        then
            SETUP_GITCONFIG=0
        else
            SETUP_GITCONFIG=1
        fi
    fi


    # RC FILES
    ############################
    if [[ $SETUP_RCFILES == 0 ]]
    then
        setup_bashrc
        setup_screenrc
        setup_gitconfig
        setup_dircolors
    else
        if [[ $SETUP_BASHRC == 0 ]];
        then
            setup_bashrc
        fi

        if [[ $SETUP_SCREENRC == 0 ]];
        then
            setup_screenrc
        fi

        if [[ $SETUP_DIRCOLORS == 0 ]];
        then
            setup_dircolors
        fi

        if [[ $SETUP_GITCONFIG == 0 ]];
        then
            setup_gitconfig
        fi
    fi

    # VIM
    ###########################
    if [[ $VIM_BUILD == 0 ]]
    then
        build_vim
    fi

    if [[ $VIM_PLUG == 0 ]]
    then
        vim_dein
    fi
}

setup


