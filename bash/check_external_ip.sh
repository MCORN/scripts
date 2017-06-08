#!/bin/bash
usage="$(basename "$0") [help] -- check public external IP against the external IP of the machine

where:
    help  show this help text

    If the IPs are the same, then the machine isn't on the VPN and an email notification is sent"

if [ "$1" == "help" ]; then
  echo "$usage"
  exit 0
elif [[ $# -eq 0 ]] ; then
    public_ip=`dig +short mcornille.no-ip.org @resolver1.opendns.com`
    external_ip=`curl -sS ipinfo.io/ip`   
    if [ $public_ip == $external_ip ]; then
        touch test.txt
        /usr/bin/mail -s "$(hostname) is not on the VPN" mcornille@gmail.com < test.txt
        rm test.txt
        exit 0
    fi
    exit 0
fi
