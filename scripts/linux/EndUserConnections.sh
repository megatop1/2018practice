#!/bin/bash

#Closing connection with all users logged into the machine currently

users="$(cut -d : -f 1 /etc/passwd | grep -v root)"
i=1

for user in $users
do
	skill -KILL -u $user
done
