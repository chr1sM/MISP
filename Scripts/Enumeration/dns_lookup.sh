#!/bin/bash
#Owner: Christopher
#Date: 11/04/2022
#SortDescription: DNS Lookup
#Description: Lists DNS from a domain or target and if we want we can scan there network with NMAP
#How to Use: Insert the target IP or Domain

read -p "Targets IP or Domain: " tIp
answer=False
  dig=`dig $tIp +short`
  if [ -z "$dig" ];
  then
    echo -e "\n "
    echo "No IPs found"
    sleep 3
  else
    echo -e "IPs found: \n $dig"
    while [ $answer != True ];
    do
      echo -e '\n Do you want to do NMAP after enumeration? ' 
      read ansDns
      if [ "$ansDns" == "y" ] || [ "$ansDns" == "yes" ];
      then
        answer=True
        for ips in $dig;
        do
          nmap $ips
        done
      else
        if [ "$ansDns" == "n" ] || [ "$ansDns" == "no" ];
        then
          answer=True
          dig $tIp $tDom +short
        fi
      fi
    done
  fi