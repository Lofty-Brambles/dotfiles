#!/bin/bash

if [[ -d "$(rbenv root)"/plugins ]]; then
	mkdir --parents "$(rbenv root)"/plugins
	git clone "https://github.com/rbenv/ruby-build.git" "$(rbenv root)"/plugins/ruby-build
else
	read -r -p "$(re "rbenv/plugins/ruby-build exists. Do you want to re-clone it? [y|n]")" reclone
	[[ $reclone =~ (yes|y|Y) ]] && git clone "https://github.com/rbenv/ruby-build.git" "$(rbenv root)"/plugins/ruby-build
fi

# FINALLY installing ruby 
rbenv install 3.1.2 --verbose

rbenv global 3.1.2