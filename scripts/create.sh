#!/usr/bin/env bash

# ----- ----- / user variables ----- -----

install_zsh="apt install zsh"

# ----- ----- user variables / ----- -----

source scripts/loggers.sh
source scripts/functions.sh

newline
log "Bootstraping your dotfiles!"

read -p "$(re "Do you want to set info in git? (ignore if already set) [y|n]")" set_git
if [[ $set_git =~ (yes|y|Y) ]]; then
	read -p "$(re "What is your GIT author name?")" git_author
	read -p "$(re "What is your GIT author email?")" git_email

	sed -e "s/GIT_AUTHOR/$git_author/g" -e "s/GIT_EMAIL/$git_email/g" "git/.gitconfig.symlink" 
	result "GIT credentials were set successfully"
fi

if ! [[ -z $(zsh --version) ]]; then 
	newline
	log "Installing zsh!"
	eval $install_zsh
fi

read -p "$(re "Do you want reset zsh as default shell? [y|n]")" set_zsh
if [[ $set_zsh =~ (yes|y|Y) ]]; then
	newline
	log "Changing zsh to be the default shell!"
	chsh -s $(which zsh)
fi

if [[ -z $ZSH ]]; then
	newline
	log "Installing oh-my-zsh!"
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

newline
log "Loading the binaries in bin!"
for file in $(find -H "packages/bin"); do
	if [[ -f $file ]]; then
		symlink $file "/bin/$file"
	fi
done

newline
read -p "$(re "Do you want run the installers? [y|n]")" set_git
if [[ $set_git =~ (yes|y|Y) ]]; then
	for file in $(find -H "packages" -name "*install.zsh"); do
		if [[ -f $file ]]; then source file; fi
	done
fi

newline
log "Symlinking the .symlink files!"
for file in $(find -H "packages" -name "*.symlink"); do
	if [[ -f $file ]]; then
		filename=$(basename $file)
		symlink $file "$HOME/${filename:0:-8}"
	fi
done

newline
result "Finished successfully setting up your dotfiles!"