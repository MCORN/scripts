#!/bin/bash
usage="$(basename "$0") [help] -- check public external IP against the external IP of the machine

where:
    help  show this help text

    * If the IPs are the same, then the machine isn't on the VPN and an email notification is sent
    * first argument (if not help) is ignored, other parameters are pulled from config file
    * config file 'check_external_ip.config' located in same directory as this script
    * Parameters defined in config file are:
    EMAIL - prefix to @gmail.com
    PASSWD - router user password
    USERSERVER - server user name
    USERROUTER - router user name
    IPROUTER - IP router
    IPSERVER - IP server
    "

. check_external_ip.config

if [ "$1" == "help" ]; then
  echo "$usage"
  exit 0
else
    #On VPN
    public_ip=$(wget -qO- http://ipecho.net/plain)
    #Off VPN
    external_ip=$(ssh $USERSERVER@$IPSERVER "wget -qO- http://ipecho.net/plain")
    #If the same, Houston we have a problem! Restart OpenVPN
    if [ $public_ip == $external_ip ]; then
        sshpass -p $PASSWD ssh -o StrictHostKeyChecking=no $USERROUTER@$IPROUTER '/usr/bin/killall openvpn;/usr/sbin/openvpn --config /tmp/openvpncl/openvpn.conf --route-up /tmp/openvpncl/route-up.sh --down-pre /tmp/openvpncl/route-down.sh --daemon;'
        ssh $USERSERVER@$IPSERVER "touch test.txt;echo 'Body for email' > test.txt;/usr/bin/mail -s 'Popcorn is not on the VPN' $EMAIL@gmail.com < test.txt;rm test.txt;"
        exit 0
    fi
    exit 0
fi
