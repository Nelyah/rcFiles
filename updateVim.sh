#! /bin/bash

git submodule foreach git pull origin master
rm -rf ~/.vim/ 
mkdir ~/.vim/
cp -r vim/* ~/.vim/
cd ~/.vim/bundle/YouCompleteMe/
./install.py --clang-completer
cd $OLDPWD
