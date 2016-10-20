#! /bin/bash

#git submodule foreach git pull origin master
rm -rf ~/.vim/ 
mkdir ~/.vim/
cp -r vimPlug/* ~/.vim/
cd ~/.vim/dein/repos/github.com/Valloric/YouCompleteMe/
./install.py --clang-completer
cd $OLDPWD
