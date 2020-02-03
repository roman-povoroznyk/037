#!/bin/bash
if [[ -n $1 && -d $1 ]]
then
	if [[ $(find $1 -ctime -1) ]]
	then
		echo "// New or modificated file(s) found."
		if [[ -n $2 && ! -d $2 ]]
		then
			echo "// Creating backup folder \"$2\"."
			if [[ $(mkdir -p $2/$(date +%Y%m%d)) -eq 0 ]]
			then
				echo "// Copying file(s)."
				if [[ $(find $1 -ctime -1 -exec rsync -R {} $2/$(date +%Y%m%d) \;) ]]
				then
					echo "// Copied file(s) to \"$2/$(date +%Y%m%d)/\"."
				else
					echo "// Can't copy file(s)."
					exit
				fi
			else 
				echo "// Can't create backup folder."
				exit
			fi
		elif [[ -d $2 ]]
		then
			mkdir -p $2/$(date +%Y%m%d)
			if [[ $(find $1 -ctime -1 -exec rsync -R {} $2/$(date +%Y%m%d) \;) ]]
                	then
                        	echo "// Copied file(s) to \"$2/$(date +%Y%m%d)/\"."
                	else
                                echo "// Can't copy file(s)."
				exit
                        fi
		else
			echo "// Backup directory error."
			exit
		fi
	else
		echo "// No file(s) found."
		exit
	fi
else
	echo "// Source directory error."
	exit	
fi	
