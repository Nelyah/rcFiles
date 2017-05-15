#! /bin/bash

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
#   sudo make install

#sudo update-alternatives --install /usr/bin/editor editor /usr/bin/vim 1
#sudo update-alternatives --set editor /usr/bin/vim
#sudo update-alternatives --install /usr/bin/vi vi /usr/bin/vim 1
#sudo update-alternatives --set vi /usr/bin/vim
cd $OLDPWD