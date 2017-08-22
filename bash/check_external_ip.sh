#!/bin/bash
usage="$(basename "$0") [help] -- check public external IP against the external IP of the machine

where:
    help  show this help text

    If the IPs are the same, then the machine isn't on the VPN and an email notification is sent"

if [ "$1" == "help" ]; then
  echo "$usage"
  exit 0
else
    public_ip=$(dig +short $1.no-ip.org @resolver1.opendns.com)
    { echo "wget -qO- http://ipecho.net/plain > /share/Download/output.txt"; sleep 1; } | telnet 192.168.3.103
    external_ip=$(</media/popcorn/Download/output.txt)
    if [ $public_ip == $external_ip ]; then
        touch test.txt
        echo "Body for email" > test.txt
        /usr/bin/mail -s "$(hostname) is not on the VPN" $1@gmail.com < test.txt
        rm test.txt
        exit 0
    fi
    exit 0
fi

