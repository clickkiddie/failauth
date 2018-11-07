#!/bin/bash

case "$1" in
	"usernames")
		cat /var/log/auth.log | grep -o "Failed password for .* from" | rev |awk '{print $2}' | rev | sort -u
		;;
	"cracker")
		cat /var/log/auth.log | grep "Failed password" | grep -Po "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+" | sort | uniq
		;;
	"scanner")
		cat /var/log/auth.log | grep "[preauth]"       | grep -Po "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+" | sort | uniq
	;;
	"all")
		cat /var/log/auth.log |                          grep -Po "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+" | sort | uniq
	;;
	*)
		echo "shows list of failed sshd login attempts"
		echo "	usage: $0 {usernames|cracker|scanner|all}"
		echo "		usernames: show list of usernames with failed login attempt"
		echo "		cracker: show list of IP4 with failed login attempt"
		echo "		scanner: show list of IP4 with disconnect before login"
		echo "		all: show list of all IP4 with failed login attempt"
	;;
esac
