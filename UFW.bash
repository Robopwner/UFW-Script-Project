#!/bin/bash
clear
# Author: Troy Osborne
# Date: 04-16-2014
clear

#root check 
function isroot {
if [ "$(id -u)" != "0" ]; then
   echo "You must be ROOT to use this script" 1>&2
   else
   fwstatus 
   menu_main
fi
}

#Set $STATUS2 to the opposite state of the firewall status
function fwstatus {
STATUS=`ufw status | cut -d" " -f2`
echo "The Firewall is: "$STATUS""
if [ $STATUS = "active" ];
then STATUS2="disable"
fi
if [ $STATUS = "inactive" ];
then STATUS2="enable"
fi
}

#Main Menu
function menu_main {
clear
echo " "
echo " "
echo " "
echo "     UFW Firewall Script "
echo " "
echo " " 
echo "  1. Firewall Status      "
echo "  2. "$STATUS2" the Firewall  "
echo "  3. Add or Remove a Rule/Port "
echo "  4. Allow or Deny a Service "
echo "  5. Reset the Firewall   "
echo "  6. Exit                 "
echo " "
echo " "
echo -n " Please make a choice: "
read mainmenu

if [ $mainmenu -eq 1 ] #See the current status
then
    ufw status
    sleep 2
    menu_main
elif [ $mainmenu -eq 2 ] #enable/disable firewall
then
    ufw "$STATUS2"
    fwstatus
    sleep 2 
    menu_main
elif [ $mainmenu -eq 3 ] #add/remove rules/ports
then
    echo "  1. Deny "
    echo "  2. Allow "
    echo -n " Deny or Allow? Any other choice takes you back to the main menu. "
    read portmenu
    if [ $portmenu -eq 1 ] #Deny a port 
    then
        echo -n "Port? "
        read DPORT
	echo -n "To block it on a certain protocol, type /tcp for TCP or /udp for UDP. "
	read DPROTO
        echo "Blocking port "$DPORT" on $DPROTO"
        sleep 1
        ufw deny $DPORT$DPROTO
        menu_main
    elif [ $portmenu -eq 2 ] #Allow a port
    then
        echo -n "PORT? "
        read APORT
	echo -n "To allow it on a certain protocol, type /tcp for TCP or /udp for UDP. "
	read APROTO
        echo "Allowing port "$APORT" on $APROTO"
        sleep 1
        ufw allow $APORT$APROTO
        menu_main
    elif [ $portmenu -ge 3 ] #any choice past two puts you back at the main menu
    then
    menu_main
    fi
elif [ $mainmenu -eq 4 ] #allow/deny services
then
    echo "  1. Deny "
    echo "  2. Allow "
    echo -n " Deny or Allow? Any other choice takes you back to the main menu. "
    read servmenu
    if [ $servmenu -eq 1 ] #Deny a service 
    then
        echo -n "Service? "
        read DSERVICE
        echo "Blocking "$DSERVICE""
        sleep 1
        ufw deny $SERVICE
        menu_main
    elif [ $servmenu -eq 2 ] #Allow a service
    then
        echo -n "Service? "
        read ASERVICE
        echo "Allowing "$ASERVICE""
        sleep 1
        ufw allow $ASERVICE
        menu_main
    elif [ $servmenu -ge 3 ] #any choice past two puts you back at the main menu
    then
    menu_main
    fi
elif [ $mainmenu -eq 5 ]
then
    ufw reset
    ufw disable
    fwstatus
    menu_main
elif [ $mainmenu -ge 6 ]
then
exit
fi
}

isroot
