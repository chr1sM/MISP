#!/bin/bash
#Owner: Christopher
#Date: 10/04/2022
#SortDescription: SSH Login
#Description: Trying to login to a SSH server
#How to Use: Insert the target IP

read -p "Targets IP: " tIp
answer=False
 while [ answer != True ];
 do
  read -p 'Username: ' user
  read -p 'Port: ' port
  if [ -z $user ] || [ -z $port ];
  then
    echo -e "You need to set a Username and Port"
  else
    answer=True
      ssh $user@$tIp -p $port
  fi
 done

