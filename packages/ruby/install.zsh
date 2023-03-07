#!/bin/bash

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

newline
read -r -p "$(re "Do you want to execute the ruby installation script? [y|n]")" execute
if [[ $execute =~ (yes|y|Y) ]]; then
	newline
	log "Preparing installations for your ruby environment!"

	exists () {
		dpkg -s "$1" &> /dev/null
	}

	for pack in "gcc" "make" "libssl-dev" "libreadline-dev" "zlib1g-dev" "libsqlite3-dev"; do
		if exists "$pack"; then
			log "$pack is already installed. Updating it."
			sudo apt upgrade "$pack"
		else
			sudo apt install "$pack"
		fi
	done

	if [[ -f "$HOME/.rbenv" || -d "$HOME/.rbenv" ]]; then
		git clone "https://github.com/rbenv/rbenv.git" "$HOME/.rbenv"
	else
		read -r -p "$(re "rbenv exists. Do you want to re-clone it? [y|n]")" reclone
		[[ $reclone =~ (yes|y|Y) ]] && git clone "https://github.com/rbenv/rbenv.git" "$HOME/.rbenv"
	fi

	# Adds more ruby install scripts as this needs to wait for rbenv init and rbenv binaries
	read -r -p "$(re "Do you want install the rest of ruby's necessities? [y|n]")" set_rb
	[[ $set_rb =~ (yes|y|Y) ]] && source "packages/ruby/install2.sh"
fi
