#!/bin/bash
(( EUID != 0 )) && exec sudo -- "$0" "$@"
WORKDIR=$(pwd)
FILE="$WORKDIR/update.sh"
CRONJOB="0 9 * * 2 bash  $FILE"

if [[ ! $(crontab -l | grep $FILE) ]]
then
	echo "// Adding job to a crontab"
	cat <(fgrep -i -v "$FILE" <(crontab -l)) <(echo "$CRONJOB") | crontab -
else
	echo "// Do you want to remove job from crontab? y/n"
	read RMJOB
	if [[ $RMJOB == "y" ]]
	then
		crontab -l | grep -v $FILE | crontab -
	elif [[ -z $RMJOB || $RMJOB != "n" ]]
	then
		echo "// Input error."
		exit
	fi
	
	echo "// Do you want to remove all file(s)? y/n"
	read RMLOG
	if [[ $RMLOG == "y" ]]
	then
		sudo rm /var/log/update-*.log
 	elif [[ -z $RMLOG || $RMLOG != "n" ]]
        then
		echo "// Input error."
		exit
	fi
fi


