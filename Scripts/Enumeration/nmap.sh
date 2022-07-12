#!/bin/bash
#Owner: Christopher
#Date: 12/04/2022
#SortDescription: NMAP
#Description: Lists all services from devices connected to a network or a single device
#How to Use: Insert the target IP or Network, #sS = Stealth Scan, T = Time (Slower)1-5(Faster),
#p = Ports, A = Agressive Scan(OS scan, Default Nmap Script, Service Version Scan), oN = Export

read -p "Targets IP or Network: " tIp
read -p 'Do you want to export to a file? ' ansN
if [ "$ansN" == "y" ] || [ "$ansN" == "yes" ];
then
    read -p 'File Name: ' nFile
    nmap -sS -A -T4 -p- $tIp -oN $nFile.txt
else
    nmap -sS -A -T4 -p- $tIp
fi
