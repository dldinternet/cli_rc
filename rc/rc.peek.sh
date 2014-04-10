#!/bin/bash
source $RC_DIR/colors.rc

OPTS=`getopt -o i:d -l inifile: -l debug -- "$@"`
if [ $? != 0 ]
then
    exit 1
fi

eval set -- "$OPTS"

while true ; do
    case "$1" in
        -i) 
			# echo "Got i, arg: $2"; 
			INIFILE=$2
			shift 2;;
        --inifile) 
			# echo "Got inifile, arg: $2"; 
			INIFILE=$2
			shift 2;;
        -d) 
			# echo "Got v"; 
			set -x
			shift;;
        --debug) 
			# echo "Got debug"; 
			set -x
			shift;;
        --) shift; break;;
    esac
done
# echo "Args:"
# for arg
# do
#     echo $arg
# done
# set +x

if [ -z "$EC2_HOME" ] ; then

	if [ -z "$RC_HEADER_VS" ] ; then
		echo "${fg_br_yellow}${fg_bold}Valid settings:${reset}"
		RC_HEADER_VS='done'
	fi

	echo -n "${fg_br_magenta}${fg_bold}RC_ACCT${reset}"
	cd ${RC_DIR}/aws
	find . -maxdepth 1 -type d | sed -e 's/\.\/*//'
	cd $OLDPWD

	echo "${fg_br_magenta}${fg_bold}RC_USER${reset}"
	cd ${RC_DIR}/aws
	#find . -maxdepth 1 -type d | sed -e 's/\.\/*//'
	for f in `ls */*.rc 2>/dev/null | sed 's/^.*\///' | sed 's/\.rc$//' | egrep -v -e '[uae][usn][we]-[12]' | sort | uniq` ; do
		echo $f
	done
	cd $OLDPWD

	echo "${fg_br_magenta}${fg_bold}RC_ZONE${reset}"
	cd ${RC_DIR}/aws
	#find . -maxdepth 1 -type d | sed -e 's/\.\/*//'
	for f in `ls {a,u}{se,sw,ne,nw}-{1,2}.rc 2>/dev/null | sed 's/\.rc$//'` ; do
		echo $f
	done
	cd $OLDPWD

fi 

if ! echo $PATH | `which egrep` -q "(^|:)/opt/chef/bin($|:)" ; then

	if [ -z "$RC_HEADER_VS" ] ; then
		echo "${fg_br_yellow}${fg_bold}Valid settings:${reset}"
		RC_HEADER_VS='done'
	fi

	echo "${fg_br_magenta}${fg_bold}RC_CMMS${reset}"
	cd ${RC_DIR}
	#find . -maxdepth 1 -type d | sed -e 's/\.\/*//'
	for f in `ls */.cmdb 2>/dev/null | sed 's/\/\.cmdb//' | sort | uniq` ; do
		echo $f
	done
	cd $OLDPWD

	echo -n "${fg_br_magenta}${fg_bold}RC_CMSV${reset}"
	cd ${RC_DIR}/chef
	find . -maxdepth 1 -type d | sed -e 's/\.\/*//'
	cd $OLDPWD

	echo "${fg_br_magenta}${fg_bold}RC_CMSA${reset}"
	cd ${RC_DIR}/aws
	accounts=$(find . -maxdepth 1 -type d | egrep -v -e '^(\.|\.\.)$' | sed -e 's/\.\/*//')
	for a in $accounts ; do echo $a ; done
	# for f in `ls */*.rc 2>/dev/null | sort | uniq` ; do
	# 	echo $f
	# done
	cd $OLDPWD

	echo "${fg_br_magenta}${fg_bold}RC_USER / RC_KEYP${reset}"
	for a in $accounts ; do 
		cd ${RC_DIR}/aws/$a
		users=$(echo $users ; find . -maxdepth 1 -type d | egrep -v -e '^(\.|\.\.)$' | sed -e 's/\.\/*//')
		cd $OLDPWD
	done
	users=$(for u in $users ; do echo $u ; done | sort | uniq)
	for u in $users ; do echo $u ; done

fi 

unset RC_HEADER_VS

echo "${fg_br_green}${fg_bold}Current:${reset}"
set | egrep -e '^(EC2|AWS|KNIFE_|PATH|CDPATH|GEM|VAGRANT|TWC_|RC_)' | egrep -v -e '^(_=|\s)'
if [ ! -z "$INIFILE" ] ; then
	echo "[global]" >$INIFILE
	set | egrep -e '^(EC2|AWS|KNIFE_|PATH|CDPATH|GEM|VAGRANT|TWC_|RC_)' | egrep -v -e '^(_=|\s)' >>$INIFILE
	echo "[bash]" >>$INIFILE
	set | egrep -e '^(PATH|CDPATH)' | egrep -v -e '^(_=|\s)' >>$INIFILE
	echo "[aws]" >>$INIFILE
	set | egrep -e '^(EC2|AWS)' | egrep -v -e '^(_=|\s)' >>$INIFILE
	echo "[chef]" >>$INIFILE
	set | egrep -e '^(KNIFE_)' | egrep -v -e '^(_=|\s)' >>$INIFILE
	echo "[ruby]" >>$INIFILE
	set | egrep -e '^(GEM)' | egrep -v -e '^(_=|\s)' >>$INIFILE
	echo "[vagrant]" >>$INIFILE
	set | egrep -e '^(VAGRANT)' | egrep -v -e '^(_=|\s)' >>$INIFILE
	echo "[twc]" >>$INIFILE
	set | egrep -e '^(TWC_)' | egrep -v -e '^(_=|\s)' >>$INIFILE
	echo "[rc]" >>$INIFILE
	set | egrep -e '^(RC_)' | egrep -v -e '^(_=|\s)' >>$INIFILE
fi
