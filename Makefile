SHELL := /bin/bash

vim:
	sudo apt-get install libncurses5-dev libgnome2-dev libgnomeui-dev \
			libgtk2.0-dev libatk1.0-dev libbonoboui2-dev \
			libcairo2-dev libx11-dev libxpm-dev libxt-dev python-dev \
			ruby-dev git

	sudo apt-get remove vim vim-runtime gvim

	mkdir -p makeVim/ && cd makeVim
	if [[ -d vim ]];\
	then\
		cd vim/; \
		git pull;\
	else\
		git clone https://github.com/vim/vim.git;\
		cd vim;\
	fi 
	cd vim && ./configure --with-features=huge \
	   --enable-multibyte \
	   --enable-rubyinterp \
	   --enable-pythoninterp \
	   --with-python-config-dir=/usr/lib/python2.7/config \
	   --enable-perlinterp \
	   --enable-luainterp \
	   --enable-gui=gtk2 --enable-cscope --prefix=/usr
	   make VIMRUNTIMEDIR=/usr/share/vim/vim80
	   sudo make install

	sudo update-alternatives --install /usr/bin/editor editor /usr/bin/vim 1
	sudo update-alternatives --set editor /usr/bin/vim
	sudo update-alternatives --install /usr/bin/vi vi /usr/bin/vim 1
	sudo update-alternatives --set vi /usr/bin/vim

setup:
	cp bashrc ${HOME}/.bashrc
	cp dircolors ${HOME}/.dircolors
	cp gitconfig ${HOME}/.gitconfig
	cp -r i3/ ${HOME}/.i3
	cp i3status.conf ${HOME}/i3status.conf
	cp screenrc ${HOME}/screenrc


update:
	git submodule foreach git pull origin master
	rm -rf ~/.vim/ 
	mkdir ~/.vim/
	cp -r vimPlug/* ~/.vim/
	cp vimPlug/.ycm_extra_conf.py ~/.vim/
	cd ~/.vim/bundle/YouCompleteMe/
	./install.py --clang-completer
	cd $OLDPWD
