#!/bin/bash
#Owner: Christopher
#Date: 10/04/2022
#SortDescription: FTP Login
#Description: Trying to login to a FTP server
#How to Use: Insert the target IP

read -p "Targets IP or Domain: " tIp
ftp $tIp
