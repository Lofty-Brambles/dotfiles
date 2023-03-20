#!/bin/bash

# ----- ----- / user variables ----- -----

install_zsh="apt install zsh"

# ----- ----- user variables / ----- -----

# ----- ----- / loggers ----- -----

# result variables
reset=$'\x1b[39;49;00m'
red=$'\x1b[31;01m'
green=$'\x1b[32;01m'
yellow=$'\x1b[33;01m'

newline () {
	echo ""
}

re () {
	printf "%s ⇒ %s %s: " "$yellow" "$reset" "$1"
}

log () {
	printf "%s[log]%s %s\n" "$green" "$reset" "$1"
}

warn () {
	printf "%s[warning]%s %s\n" "$yellow" "$reset" "$1"
}

error () {
	printf "%s[error]%s %s\n" "$red" "$reset" "$1"
}

result () {
	printf "%s [✔] %s %s\n" "$green" "$reset" "$1"
}

# ----- ----- loggers / ----- -----

# ----- ----- / functions ----- -----

# worker to symlink the files
symlink () {
	src=$1
	dst=$2

	if [[ -L $dst ]]; then
		if ! [[ -e $dst ]]; then
			log "Removing broken symlink at $dst"
			rm "$dst"
		else
			return 0
		fi
	else
		backup="$dst.old.1"
		while [[ -e $backup ]]; do
			backup=$(printf "%s%s\n" "${backup:0:-1}" $(( ${backup: -1} + 1 )))
		done

		read -r -p "$(re "$dst already exists. Do you want to: [1] overwrite it, [2] back it up @ $backup or [3] leave it? [1|2|3]")" reply
		case $reply in
			1) ;;
			2) mv "$dst" "$backup"; log "Backed up $dst <- $src";;
			3) return 0;;
		esac
	fi

	ln -sf "$src" "$dst"
	log "Symlinked $dst <- $src"
}


# ----- ----- functions / ----- -----

newline
log "Bootstraping your dotfiles!"

read -r -p "$(re "Do you want to set info in git? (ignore if alread -ry set) [y|n]")" set_git
if [[ $set_git =~ (yes|y|Y) ]]; then
	read -r -p "$(re "What is your GIT author name?")" git_author
	read -r -p "$(re "What is your GIT author email?")" git_email

	sed -e "s/GIT_AUTHOR/$git_author/g" -e "s/GIT_EMAIL/$git_email/g" "packages/git/.gitconfig.symlink"
	result "GIT credentials were set successfully"
fi

if ! [[ $(zsh --version) ]]; then 
	newline
	log "Installing zsh!"
	eval "$install_zsh"
fi

read -r -p "$(re "Do you want reset zsh as default shell? [y|n]")" set_zsh
if [[ $set_zsh =~ (yes|y|Y) ]]; then
	newline
	log "Changing zsh to be the default shell!"
	chsh -s "$(which zsh)"
fi

if [[ -z $ZSH ]]; then
	newline
	log "Installing oh-my-zsh!"
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

newline
log "Loading the binaries in bin!"
find "$(pwd -P)/bin" -print0 | while IFS= read -r -d "" file; do
	if [[ -f $file ]]; then
		filename=$(basename "$file")
		symlink "$file" "/bin/$filename"
	fi
done

newline
log "Symlinking the .symlink files!"
find "$(pwd -P)/packages" -name "*.symlink" -print0 | while IFS= read -r -d "" file; do
	if [[ -f $file ]]; then
		filename=$(basename "$file")
		symlink "$file" "$HOME/${filename:0:-8}"
	fi
done

newline
result "Finished successfully setting up your dotfiles!"
