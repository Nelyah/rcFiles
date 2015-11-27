#! /bin/bash

git submodule init
git submodule sync
git submodule update --init --recursive

cd vim/bundle/YouCompleteMe/
./install.py --clang-completer
cd $OLDPWD

