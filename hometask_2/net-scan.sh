#!/bin/bash
for host in "$@"
do
	for port in {80,443}
	do
		2>/dev/null echo > /dev/tcp/$host/$port
		if [[ $? -eq 0 ]]
		then	       	
			echo "// $host:$port is open."
		fi
	done
done
