#! /bin/bash

# Standalone installer for Unixs
# Original version is created by shoma2da
# https://github.com/shoma2da/neobundle_installer

rm ~/.vim/ -rf
mkdir -p /home/chloe/.vim/dein
cp -r vimPlug/colors/ ${HOME}/.vim/ 


PLUGIN_DIR=${HOME}/.vim/dein/

INSTALL_DIR="${PLUGIN_DIR}/repos/github.com/Shougo/dein.vim"
echo "Install to \"$INSTALL_DIR\"..."
if [ -e "$INSTALL_DIR" ]; then
  echo "\"$INSTALL_DIR\" already exists!"
fi

echo ""

# check git command
if type git; then
  : # You have git command. No Problem.
else
  echo 'Please install git or update your path to include the git executable!'
  exit 1
fi

echo ""

# make plugin dir and fetch dein
if ! [ -e "$INSTALL_DIR" ]; then
  echo "Begin fetching dein..."
  mkdir -p "$PLUGIN_DIR"
  git clone https://github.com/Shougo/dein.vim "$INSTALL_DIR"
  echo "Done."
  echo ""
fi

sed -ri "s|(set\ runtimepath\+=).*$|\1${INSTALL_DIR}|" vimPlug/vimrc

echo "Done."

echo "Complete setup dein!"

cp vimPlug/vimrc ${HOME}/.vim/
ln -s ${HOME}/.vim/vimrc ${HOME}/.vimrc


#if [[ ! -z $(grep "Valloric/YouCompleteMe" vimPlug/vimrc) ]];
#then 
#    echo YouCompleteMe is installed
#    cd ~/.vim/dein/repos/github.com/Valloric/YouCompleteMe/
#    ./install.py --clang-completer
#else
#    echo paspouet
#fi

#git submodule init
#git submodule sync
#git submodule update
#git submodule foreach git submodule update --init --recursive
