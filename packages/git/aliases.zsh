# ----- ----- / Rules ----- -----
# » Forced version: Capitals
# » Pattern accepting version: command!
# » Marking a private function _functun
# ----- ----- Rules / ----- -----

git_main_branch () {
	command git rev-parse --git-dir &>/dev/null || return
	local ref
	for ref in refs/{heads,remotes/{origin,upstream}}/{main,trunk,mainline,default}; do
		if command git show-ref -q --verify $ref; then
			echo ${ref:t}
			return
		fi
	done
	echo master
}

alias g="git"

alias ga="git add"
alias gaa="git add --all"
alias gau="git add --update"
alias gai="git add --interactive"
alias gav="git add --verbose"

alias gb="git branch --all"
alias gbd="git branch --delete"
alias gbD="git branch --delete --force"
gbd! () {
	local name = $(git branch --verbose | awk '"'"'{print $1}'"'"' | grep $1)
	[[ $name ]] && echo $name | xargs git branch --delete
}
gbD! () {
	local name = $(git branch --verbose | awk '"'"'{print $1}'"'"' | grep $1)
	[[ $name ]] && echo $name | xargs git branch --delete --force
}
compdef _git gbd!=git-branch
compdef _git gbD!=git-branch
grename () {
	if [[ -z "$1" || -z "$2" ]]; then
		echo "Usage: $0 old_branch new_branch"
		return 1
	fi

	git branch -m "$1" "$2"
	if git push origin :"$1"; then
		git push --set-upstream origin "$2"
	fi
}

alias gch="git checkout"
alias gcb="git checkout -b"

alias gc="git commit --message"
alias gcv="git commit --verbose"
alias gcam="git commit --verbose --amend"

gcl () {
	command git clone --recurse-submodules "$@"
	[[ -d "$_" ]] && cd "$_" || cd "${${_:t}%.git}"
}
compdef _git gcln=git-clone

alias gf="git fetch"
alias gfa="git fetch --all --prune --jobs=10"
alias gfo="git fetch origin"

gps () {
	if [[ "$#" != 0 ]] && [[ "$#" != 1 ]]; then
		git push origin "${*}"
	else
		[[ "$#" == 0 ]] && local branch=$(git branch --show-current)
		git push origin "${branch:=$1}"
	fi
}
gpS () {
	if [[ "$#" != 0 ]] && [[ "$#" != 1 ]]; then
		git push --force origin "${*}"
	else
		[[ "$#" == 0 ]] && local branch=$(git branch --show-current)
		git push --force origin "${branch:=$1}"
	fi
}
compdef _git gps=git-checkout
compdef _git gpS=git-checkout

gpl () {
	if [[ "$#" != 0 ]] && [[ "$#" != 1 ]]; then
		git pull origin "${*}"
	else
		[[ "$#" == 0 ]] && local branch=$(git branch --show-current)
		git pull origin "${branch:=$1}"
	fi
}
gplu () {
	if [[ "$#" != 0 ]] && [[ "$#" != 1 ]]; then
		git pull upstream "${*}"
	else
		[[ "$#" == 0 ]] && local branch=$(git branch --show-current)
		git pull upstream "${branch:=$1}"
	fi
}
gpL () {
	if [[ "$#" != 0 ]] && [[ "$#" != 1 ]]; then
		git pull --force origin "${*}"
	else
		[[ "$#" == 0 ]] && local branch=$(git branch --show-current)
		git pull --force origin "${branch:=$1}"
	fi
}
compdef _git gpl=git-checkout
compdef _git gplu=git-checkout
compdef _git gpL=git-checkout

gig () {

}

alias gl="log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias glog="git log --oneline --decorate --graph"

alias gm="git merge"
alias gmo="git merge origin/$(git branch --show-current)"
alias gmu="git merge upstream/$(git branch --show-current)"
alias gmx="git merge --abort"

alias gs="git stash push --include-untracked"
alias gsl="git stash list"


# add stuff for cherry-picking, diff, remote, rebase, reset, rm, stash listing w/ show, drop, apply branch