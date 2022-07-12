#!/bin/bash
#Owner: Christopher
#Date: 20/04/2022
#SortDescription: SNMP Enumeration
#Description: Enumerates the SNMP from a target, only until version 2c supported
#How to Use: Insert the target IP

read -p "Targets IP: " tIp
answer=False
while [ answer != True ];
do
    read -p 'What SNMP Version you want to use (Version: 1,2c)? ' ansV
    if [ "$ansV" == "1" ];
    then
      answer=True
      snmpwalk -v1 -c public $tIp
    else
      if [ "$ansV" == "2c" ]
      then
        answer=True
        snmpwalk -v2c -c public $tIp
      fi
    fi
done