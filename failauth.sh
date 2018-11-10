#!/bin/bash

case "$1" in
	"attempts")
		cat /var/log/auth.log | awk -F ":" '{print $4}' | grep "Failed password" | awk '{for(i=3; i < NF-2;i++){printf $i " "}print ""}' | awk -F " " '{print $(NF-2) " " $1 " " $NF}'
	;;
	"scanner")
		cat /var/log/auth.log | grep "[preauth]"       | grep -Po "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+" | sort | uniq
	;;
	*)
		echo "shows list of failed sshd login attempts"
		echo "	usage: $0 {usernames|cracker|scanner|all}"
		echo "		attempts (requires drunkenSSH as sshd): show list of <user> <password> <ip> with failed login attempt"
		echo "		scanner: show list of IP4 with disconnect before login"
	;;
esac
