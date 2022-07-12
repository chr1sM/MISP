#!/bin/bash
#Owner: Christopher
#Date: 10/04/2022
#SortDescription: Ping
#Description: Pings target to see if target is online or to test icmp requests
#How to Use: Insert the target IP

read -p "Targets IP or Domain: " tIp

ping -c 4 $tIp
