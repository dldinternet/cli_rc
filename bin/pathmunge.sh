#!/bin/bash

#set -x
source $RC_DIR/colors.rc

source $RC_DIR/pathmunge.rc

type=`/usr/bin/type -t pathmunge 2>/dev/null`
if [ "$type" == "function" ] ; then
	pathmunge $*
	rc=$?
	case $rc in
		0 )
			echo "${fg_green}'exit' when done.${reset}"
			bash -i
			;;
		1 )
          echo "${fg_yellow}$1${reset}"
          ;;
    esac
else
	echo "${fg_red}'pathmunge' not defined.${reset}"
fi
