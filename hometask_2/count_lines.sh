#!/bin/bash
FILE="versions.txt"
if [[ ! -f $FILE ]]
then
	echo "// File \"$FILE\" doesn't exist. Downloading."
	if [[ `wget http://yoko.ukrtux.com:8899/versions.txt` -eq 0 ]]
	then
		echo "// Downloaded."
		echo "// Counting the most repeated line in \"$FILE\"."
		sort $FILE | uniq -c | sort -bgr | head -1
	else
		echo "// Can't download."
	fi
elif [[ -f $FILE ]]
then
	echo "// Counting the most repeated line in \"$FILE\"." 
	sort $FILE | uniq -c | sort -bgr | head -1
fi
