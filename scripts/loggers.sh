esc="\x1b["
reset=$esc"39;49;00m"
red=$esc"31;01m"
green=$esc"32;01m"
yellow=$esc"33;01m"
blue=$esc"34;01m"
magenta=$esc"35;01m"
cyan=$esc"36;01m"

newline () {
	echo ""
}

re () {
	printf "$yellow ⇒ $reset $1: "
}

log () {
	echo -e "$green[log]$reset $1"
}

warn () {
	echo -e "$yellow[warning]$reset "$1
}

error () {
	echo -e "$red[error]$reset "$1
}

result () {
	echo -e "$green [✔] $reset $1"
}
