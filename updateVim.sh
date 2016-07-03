#! /bin/bash

git submodule foreach git pull origin master
rm -rf ~/.vim/ 
mkdir ~/.vim/
cp -r vimPlug/* ~/.vim/
cp vimPlug/.ycm_extra_conf.py ~/.vim/
cd ~/.vim/bundle/YouCompleteMe/
./install.py --clang-completer
cd $OLDPWD
