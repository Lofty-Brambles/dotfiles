source scripts/loggers.sh

symlink () {
	src=$1
	dst=$2

	if [[ -L $dst ]]; then
		if [[ -e $dst ]]; then
			log "Removing broken symlink at $dst"
			rm "$dst"
		else
			return 0
		fi
	else
		backup="$dst.old.1"
		while [[ -e $backup ]]; do
			backup=$(printf "%s%s\n" ${backup:0:-1} $((${backup: -1}+1)))
		done

		read -p "$(re "$dst already exists. Do you want to: [1] overwrite it, [2] back it up @ $backup or [3] leave it? [1|2|3]")" reply
		case $reply in
			1) ;;
			2) mv $dst $backup; log "Backed up $dst <- $src";;
			3) return 0;;
		esac
	fi

	ln -sf "$src" "$dst"
	log "Symlinked $dst <- $src"
}
