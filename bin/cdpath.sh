#!/bin/bash

source $RC_DIR/colors.rc
source $RC_DIR/cdpath.rc

if ! [ -z "$1" ] ; then
	echo "${fg_green}Please use '. cdpath.rc' first and then reissue '$0 $*'${reset}"
fi	

cdpath $*
