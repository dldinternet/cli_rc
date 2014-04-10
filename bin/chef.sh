#!/bin/bash

# [2014-04-07 Christo] Support account settings overrides with nicknames under $RC_DIR/accounts
if test ! -z "$1" ; then
	ACCT=$1
	shift
	# if test -z "$1" ; then
	# 	export RC_ZONE=use-1
	# else
	# 	export RC_ZONE=$1
	# 	shift
	# fi
	. $RC_DIR/accounts/$ACCT.rc
fi

source $RC_DIR/initfunc.rc

#set -x
if ! echo $PATH | `which egrep` -q "(^|:)/opt/chef/bin($|:)" ; then
	#set +x
	. $RC_DIR/pathmunge.rc

	check_dir RC_DIR
	ret=$?
	if [ 0 -eq $ret ] ; then

		check_vars RC_CMMS RC_CMSV RC_CMSA

		if [ 0 -eq $ret ] ; then

			rc="${RC_DIR}/${RC_CMMS}/${RC_CMSV}/${RC_CMSA}.rc"

			source_rc $rc
		fi		

		echo "${bold}${fg_green}checks done.${reset}"
	fi

	. ${RC_DIR}/rc.peek.sh

	echo "${fg_green}Use 'exit' to switch context.${reset}"

	bg_chef="$(tput setaf 15)$(tput setab 25)"
	export PSOC="${bg_chef} ${RC_CMSA} ${reset}"
	RC_PROFILE=$RC_DIR/chef.profile.rc
	. ${RC_DIR}/subshell.rc

else
	echo "${fg_red}Already loaded.${reset}"
fi	