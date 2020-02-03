#!/bin/bash
if [[ ! -f $1 ]]
then
	echo "// File \"$1\" doesn't exists. Downloading."
	if [[ `wget http://yoko.ukrtux.com:8899/versions.txt` -eq 0 ]]
	then
		echo "// Downloaded."
		echo "// Counting the most repeated line in \"$1\"."
		sort $1 | uniq -c | sort -bgr | head -1
	else
		echo "// Can't download."
	fi
elif [[ -f $1 ]]
then
	echo "// Counting the most repeated line in \"$1\"." 
	sort $1 | uniq -c | sort -bgr | head -1
else 
	echo "// Source file error."
fi
