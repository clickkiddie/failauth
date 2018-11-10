#!/bin/bash

case "$1" in
	"attempts")
		cat /var/log/auth.log | awk -F ":" '{print $4}' | grep "Failed password" | awk '{for(i=3; i < NF-2;i++){printf $i " "}print ""}' | awk -F " " '{print $(NF-2) " " $1 " " $NF}'
	;;
	"scanner")
		cat /var/log/auth.log | grep "[preauth]"       | grep -Po "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+" | sort | uniq
	;;
	"script"
		./$0 attepts | awk '{print "sshpass -p \""$2"\" ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no "$1"@"$3}'
	;;
	*)
		echo "shows list of failed sshd login attempts"
		echo "	usage: $0 {attempts|scanner}"
		echo "		attempts (requires drunkenSSH as sshd): show list of <user> <password> <ip> with failed login attempt"
		echo "		scanner: show list of IP4 with disconnect before login"
		echo "		script: generates a callback script using ssh and sshpass"
	;;
esac
