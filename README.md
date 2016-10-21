#My environment files :

These files are mainly meant to be used by me, and as such you might want to modify them after downloading them.

The setup script is meant to be as clear and readible as possible, however installing everything may replace files that you didn't expect to (installing bashrc will replace any existing bashrc already existing !)
I therefore highly suggest you to at least take a look at the script and look at what it does before running it.

##The setup.sh script works as follow :
It takes any number of arguments, each argument having a different effect :
- vim : This will install vim, replace your .vimrc, use dein as a plugin manager, install and/or update the plugins specified in the .vimrc. If YCM is installed, it will be compiled as well
- bashrc : Copy the bashrc file to your HOME directory
- screenrc : Copy the screenrc file to your HOME directory
- dircolors : Copy the dircolors file to your HOME directory
- gitconfig : Copy the gitconfig file to your HOME directory
- rcFiles : Copy the following files to your HOME directory : bashrc, screenrc, dircolors, gitconfig

For a complete setup, you might want to run the command `./setup.sh vim rcFiles`
