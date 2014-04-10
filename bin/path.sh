#!/bin/bash

export PATH

source $RC_DIR/colors.rc
source $RC_DIR/pathmunge.rc

if ! [ -z "$1" ] ; then
	if [ ! type pathmunge &>/dev/null ] ; then
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
else
	echo $PATH
fi	

