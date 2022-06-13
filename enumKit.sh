#!/bin/bash
#insert targets info if we have targets ip or domain name
target_info() {
  clear
  answer=False

  while [ $answer != True ];
  do 
    read -p 'Do you have target IP?' ans
    if [ "$ans" == "y" ] || [ "$ans" == "yes" ];
    then
      answer=True
      read -p 'Target IP: ' tIp
    while [ -z "$tIp" ]
    do
      echo "You need to set a Target IP:"
      read -p 'Target IP: ' tIp
    done
    else
    if [ "$ans" == "n" ] || [ "$ans" == "no" ];
    then
      answer=True
      read -p 'Do you have target Domain?' ansD
      if [ "$ansD" == "y" ] || [ "$ansD" == "yes" ];
      then
        read -p 'Target Domain: ' tDom
        while [ -z "$tDom" ]
        do
          echo "You need to set a Target Domain"
          read -p 'Target Domain: ' tDom
        done
      else
        echo -e "\n Exiting \n"
        exit
      fi
    fi
  fi
  done
}

#pings target to see if target is online or to test icmp requests
ping_target() {
  clear
  if [ -z $tIp ];
  then
    ping $tDom
  else
    ping $tIp
  fi
  #show_menu
}

#sS = Stealth Scan, T = Time (Slower)1-5(Faster),
#p = Ports, A = Agressive Scan(OS scan, Default Nmap Script, Service Version Scan), oN = Export
nmap_target(){
  clear
  read -p 'Do you want to export to a file? ' ansN
  if [ "$ansN" == "y" ] || [ "$ansN" == "yes" ];
  then
    read -p 'File Name ' nFile
    nmap -sS -A -T4 -p- $tIp $tDom -oN $nFile.txt
  else
    nmap -sS -A -T4 -p- $tIp $tDom
  fi
}

#ssh login
ssh_target(){
 clear
 answer2=False
 while [ answer2 != True ];
 do
  read -p 'Username: ' user
  read -p 'Port: ' port
  if [ -z $user ] || [ -z $port ];
  then
    echo -e "You need to set a Username and Port"
  else
    answer2=True
    if [ -z $tIp ];
    then   
      ssh $user@$tDom -p $port
    else
      ssh $user@$tIp -p $port
    fi
  fi
 done
}

#ftp login
ftp_target(){
  clear
  if [ -z $tIp ];
  then
    ftp $tDom
  else
    ftp $tIp
  fi
}

#enumeration on SNMP only until version 2c supported
snmp_enum(){
  clear
  answer6=False
  while [ answer6 != True ];
  do
    read -p 'What SNMP Version you want to use (Version: 1,2c)? ' ansV
    if [ "$ansV" == "1" ];
    then
      answer6=True
      snmpwalk -v1 -c public $tIp
    else
      if [ "$ansV" == "2c" ]
      then
        answer6=True
        snmpwalk -v2c -c public $tIp
      fi
    fi
  done
}

dns_lookup(){
  answer1=False
  dig=`dig $tIp $tDom +short`
  if [ -z "$dig" ];
  then
    echo -e "\n "
    echo "No IPs found"
    sleep 3
  else
    echo -e "IPs found: \n $dig"
    while [ $answer1 != True ];
    do
      echo -e '\n Do you want to do NMAP after enumeration? ' 
      read ansDns
      if [ "$ansDns" == "y" ] || [ "$ansDns" == "yes" ];
      then
        answer1=True
        for ips in $dig;
        do
          nmap $ips
        done
      else
        if [ "$ansDns" == "n" ] || [ "$ansDns" == "no" ];
        then
          answer1=True
          dig $tIp $tDom +short
        fi
      fi
    done
  fi
}

#opens dirbuster
dirbuster_gui(){
  echo -e "\n "
  dirbuster
  show_menu
}

#checks for the python version and depending 
#on that it will create a local http server
http_server(){
  clear
  read -p 'Port you like to create the server: ' sPort
  echo 'CTRL + C to close the server'
  ver=`python --version`
  if [[ "$ver" == "Python 2"* ]];
  then
    python2 -m SimpleHTTPServer $sPort
  else
    python3 -m server.server $sPort
  fi
  show_menu
}

#brute-force functions
#^User^ and ^PASS^ = what we used in L and P
web_logins(){
  clear
  answer5=False
  while [ answer5 != True ];
  do
    read -p "Do you have Username? " ansW
    read -p "Path to Web Login: " pathWeb
    if [ "$ansW" == "y" ] || [ "$ansW" == "yes" ];
    then
      answer5=True
      read -p "Username: " userWeb
      read -p "Path to List of Passwords: " pathPass
      hydra -l $userWeb -P $pathPass -v $tIp http-post-form "/$pathWeb/:username=^USER^&password=^PASS^&Login=Login:F=Incorrect username"
      
    else
      if [ "$ansW" == "n" ] || [ "$ansW" == "no" ];
      then
        answer5=True
        read -p "Path to List of Users: " pathUsers
        read -p "Password: " passWeb
        hydra -L $pathUsers -p $passWeb -v $tIp http-post-form "/$pathWeb/:username=^USER^&password=^PASS^&Login=Login:F=Incorrect username"
      fi
    fi
  done
}

#uses hydra to brute-force ssh services
#l = user, L = List of Users, p = password, P = List of Passwords, v = verbose
ssh_creds(){
  clear
  answer3=False
  while [ answer3 != True ];
  do
    read -p "Do you have Username?" ansS
    if [ "$ansS" == "y" ] || [ "$ansS" == "yes" ];
    then
      answer3=True
      read -p "Username: " userSsh
      read -p "Path to List of Passwords: " pathPass
      hydra -l $userSsh -P $pathPass -v $tIp ssh
    else
      if [ "$ansS" == "n" ] || [ "$ansS" == "no" ];
      then
        answer3=True
        read -p "Path to List of Users: " pathUsers
        read -p "Password: " passSsh
        hydra -L $pathUsers -p $passSsh -v $tIp ssh
      fi
    fi
  done
}

#uses hydra to brute-force ftp services
ftp_creds(){
  clear
  answer4=False
  while [ answer4 != True ];
  do
    read -p "Do you have Username?" ansF
    if [ "$ansF" == "y" ] || [ "$ansF" == "yes" ];
    then
      answer4=True
      read -p "Username: " userFtp
      read -p "Path to List of Passwords: " pathPass
      hydra -l $userFtp -P $pathPass -v $tIp ftp
    else
      if [ "$ansF" == "n" ] || [ "$ansF" == "no" ];
      then
        answer4=True
        read -p "Path to List of Users: " pathUsers
        read -p "Password: " passFtp
        hydra -L $pathUsers -p $passFtp -v $tIp ftp
      fi
    fi
  done
}

#find functions
#finds files that user can run as root
file_root(){
  clear
  find / -type f -user root -perm -4000 -exec ls -ldb {} \; 2>>/dev/null
}

#finds file with user provided extension
file_extension(){
  clear
  read -p 'File extension you are looking for ("." isnt needed): ' fExtens

  if [ -z $fExtens ];
  then
    show_menu
  else
    find . -type f -name "*.$fExtens"
  fi
}

#MENUS
#uses hydra to do brute-force attacks
brute_force_menu(){
 clear
  echo -e "\n    Select an option from menu: "
  echo -e "\n Key  Menu Option:               Description:"
  echo -e " ---  ------------                 ------------"
  echo -e "  1 - Web Logins                   (brute-force web logins)"                            
  echo -e "  2 - SSH Credentials              (brute-force ssh logins)"                             
  echo -e "  3 - FTP Credentials              (brute-force ftp logins)"                            
  read -n1 -p "  Press key for menu item selection or press X to go back: " menuinput

  case $menuinput in
        1) web_logins;;
        2) ssh_creds;;
        3) ftp_creds;;
        x|X) show_menu;;
        *) brute_force_menu;;
    esac
}

#finds 
find_menu(){
    clear
    echo -e "\n    Select an option from menu: "
    echo -e "\n Key  Menu Option:               Description:"
    echo -e " ---  ------------                 ------------"
    echo -e "  1 - Files with root permissions  (finds file that useres can run with root permissions)"                            
    echo -e "  2 - File with extensions         (finds files with certain extensions)"                                                     
    read -n1 -p "  Press key for menu item selection or press X to go back: " menuinput

  case $menuinput in
        1) file_root;;
        2) file_extension;;
        x|X) show_menu ;;
        *) find_menu ;;
    esac
}

show_menu() {
    clear
    echo -e "\n    Select an option from menu: "
    echo -e "\n Target: "$tIp" "$tDom" "
    echo -e "\n Key  Menu Option:               Description:"
    echo -e " ---  ------------                 ------------"
    echo -e "  1 - Ping                         (testing ICMP Protocol)"                              
    echo -e "  2 - NMAP                         (network mapper)"                             
    echo -e "  3 - SSH                          (login to ssh server)"                             
    echo -e "  4 - FTP                          (login to ftp server)"  
    echo -e "  5 - SNMP                         ()"
    echo -e "  6 - BruteForce Attacks           (opens brute-force menu list)"                                                            
    echo -e "  7 - DNS Loockup                  (enumeration of dns)"                                    
    echo -e "  8 - DirBuster                    (opens DirBuster GUI to brute-force web directories and files" 
    echo -e " ---  ----------------------       ------------"
    echo -e "  9 - Find                         (opens a find menu list)"
    echo -e "  0 - Create HTTP Server           (creates a local http server)"
    read -n1 -p "  Press key for menu item selection or press X to exit: " menuinput

  case $menuinput in
        1) ping_target;;
        2) nmap_target;;
        3) ssh_target;;
        4) ftp_target;;
        5) snmp_enum;;
        6) brute_force_menu;;
        7) dns_lookup;;
        8) dirbuster_gui;;
        9) find_menu;;
        0) http_server;;
        x|X) echo -e "\n\n Exiting" ;;
        *) show_menu ;;
    esac
}

exit_screen () {
    echo -e "\n All Done! Happy Hacking! \n"
    exit
}

#Run menus
target_info
show_menu
exit_screen