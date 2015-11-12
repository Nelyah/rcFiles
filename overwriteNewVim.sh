#! /bin/bash

rm -rf ~/.vim/ ~/.vimrc
cp -r vim/ ~/.vim/ 
ln -s ~/.vim/vimrc ~/.vimrc

echo "Vim is set up and ready to use !"
