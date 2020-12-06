#!/usr/bin/env bash

function usage() {
	echo "usage: epitech command"
	echo `grey "epitech help"`" to show the list of commands"
}

function exec_epitech_cmd() {
	local cmd=$1
	echo `grey "$cmd"`
	$cmd
}

#--------#
# COLORS #
#--------#
function red() {
	echo -e "\e[31m$1\e[0m"
}

function green() {
	echo -e "\e[32m$1\e[0m"
}

function grey() {
	echo -e "\e[90m$1\e[0m"
}


#----------#
# COMMANDS #
#----------#
function cmd_help() {
	echo "\
help: show the help
setuser: set the current epitech user account
showuser: show the current epitech user account
new: create a new repository
delete: delete a repository
list: list your repositories
clone <git-flags>: clone a repository
cloneall <git-flags>: clone all your repositories
clean: clean temporary files from emacs
acl: set the acl on a repository
ignore: edit your .gitignore file of your current repository

norm: check your norm
csfml: install the full CSFML library (be careful, contains prohibited functions)"
}

function cmd_setuser() {
	echo -n "Enter your epitech email adress: "
	read epitech_user
	echo $epitech_user > $config_file
}

function cmd_showuser() {
	echo -n "The current configured epitech user account is: "
	green `cat $config_file`
}

function cmd_new() {
	echo -n "Enter a name for your new repository: "
	read repository_name
	cd $repository_name
	pwd
	blih -u $user repository create $repository_name
	echo ""
	grey "Let's add read ACL to ramassage-tek"
	blih -u $user repository setacl $repository_name ramassage-tek r
	echo ""
	grey "Let's clone your new repository"
	git clone git@git.epitech.eu:/$user/$repository_name
	green "Your repository is ready, good luck for your project !"
}

function cmd_delete() {
	echo -n "Enter the name of the repository you want to "`red "delete"`" (be careful, this action is "`red "irreversible"`"): "
	read repository_name
	blih -u $user repository delete $repository_name
}

function cmd_list() {
	blih -u $user repository list
}

function cmd_clone() {
	echo -n "Enter the name of the repository you want to clone: "
	read repository_name
	echo -n "Enter the user (firstname.lastname) you want to clone from (empty to clone a personal repository)"
	read src_user
	if [ -z $src_user ]
		then
		src_user=$user
	fi
	git clone git@git.epitech.eu:/$src_user/$repository_name $@
}

function cmd_cloneall() {
	for repository in $( cmd_list )
		do
		if git clone git@git.epitech.eu:/$user/$repository $@
			then
			green "$repository successfully cloned!\n"
		else
			red "an error occured cloning $repository\n"
		fi
	done
}

function cmd_clean() {
	find -name "*~" -delete
	find -name "#*#" -delete
	find -name "*.gch" -delete
	echo "Clean done !"
}

function cmd_acl() {
	echo -n "Enter the name of the repository you want to set the ACLs: "
	read repository_name
	echo -n "Enter the rights you wants (r/w): "
	read rights
	echo -n "Enter the user who will receive the permission (empty for ramassage-tek): "
	read dest_user
	if [ -z $dest_user ]
		then
		dest_user=ramassage-tek
	fi
	blih -u $user repository setacl $repository_name $dest_user $rights
}

function cmd_ignore() {
	confirmation="y"
	if [ ! -d ".git" ]
		then
		read -n1 -p "There isn't any .git folder here, do you want to continue ? (y/n)" confirmation
	fi

	if [ $confirmation = "y" ]
		then
		if [ ! -f ".gitignore" ]
			then
			touch .gitignore
		fi
		nano .gitignore
	fi
}

function cmd_norm() {
	if which epitech-norm > /dev/null; then
		epitech-norm
		exit
	fi
	red 'epitech-norm seems to not be installed, please download an norm-checker, put it in /usr/local/bin and rename it epitech-norm, or make a symbolic link.' >&2
	echo 'example: https://github.com/ronanboiteau/NormEZ'
}

function cmd_csfml() {
	echo "Please refer to https://gist.github.com/paullaffitte/c3f028dc64a55e920fa8afabff70673e for SFML or https://gist.github.com/paullaffitte/85f0d24d93408ab90b9e0600df8db4ac for CSFML."
}

#------#
# MAIN #
#------#
config_file="$HOME/.epitechrc"
if [ -f $config_file ]
	then
	touch $config_file
	user=`cat $config_file`
else
	cmd_setuser
fi

if [ $# == 0 ]
	then
	usage
else
	cmd_$1 ${@:2}
fi
