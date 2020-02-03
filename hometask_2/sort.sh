#!/bin/bash
FILE="versions.txt"
if [[ ! -f $FILE ]]
then
	echo "// File \"$FILE\" doesn't exist. Downloading."
	if [[ `wget http://yoko.ukrtux.com:8899/versions.txt` -eq 0 ]]
	then
		echo "// Downloaded."
		echo "// Sorting lines in \"$FILE\"."
		sort -V $FILE
	else
		echo "// Download error."
	fi
else
	echo "// Sorting lines in \"$FILE\"." 
	sort -V $FILE
fi
