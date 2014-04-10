#!/bin/bash

# [2014-04-07 Christo] Support account settings overrides with nicknames under $RC_DIR/accounts
if test ! -z "$1" ; then
	ACCT=$1
	shift
	if test -z "$1" ; then
		export RC_ZONE=use-1
	else
		export RC_ZONE=$1
		shift
	fi
	. $RC_DIR/accounts/$ACCT.rc
fi

source $RC_DIR/initfunc.rc

#set -x
if [ -z "$AWS_ACCESS_KEY_ID" ] ; then
	#set +x
	. $RC_DIR/pathmunge.rc

	check_dir RC_DIR
	ret=$?
	if [ 0 -eq $ret ] ; then

		# rc="${RC_DIR}/${RC_CLOUD}/${RC_ACCT}/${RC_USER}/${RC_ZONE}.rc"
		rc="${RC_DIR}/${RC_CLOUD}/${RC_ACCT}/${RC_USER}/aws.rc"

		source_rc $rc

		check_key AWS_KEY_PATH

		check_URL EC2_URL

		echo "${bold}${fg_green}checks done.${reset}"

	fi

	#export -p

	. ${RC_DIR}/rc.peek.sh

	echo "${fg_green}Use 'exit' to switch context.${reset}"
	#set -x 
	bg_aws="$(tput setaf 236)$(tput setab 178)"
	export PSRC="${bg_aws} ${RC_ACCT}@${RC_ZONE} ${reset}"
	RC_PROFILE=$RC_DIR/rvm.profile.rc
	. ${RC_DIR}/subshell.rc

else
	echo "${fg_red}Already loaded.${reset}"
fi	