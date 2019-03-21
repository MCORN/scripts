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
    machine_ip=$(wget -qO- http://ipecho.net/plain)
    #Off VPN
    public_ip=$(</home/mathieu/Downloads/ip.txt)
    #If the same, Houston we have a problem! Restart OpenVPN
    if [ $public_ip == $machine_ip ]; then
        #Stop all torrents
        /usr/bin/transmission-remote -t all -S
        #Restart open-vpn
        service openvpn stop
        sleep 5
        service openvpn start
        #Send an email
        /home/mathieu/Git/scripts/bash/send_email.sh 'MacMini is not on the VPN'
    else
        # find out number of torrent
        TORRENTLIST=`/usr/bin/transmission-remote --list | sed -e '1d;$d;s/^ *//' | cut --only-delimited --delimiter=' ' --fields=1`
        for TORRENTID in $TORRENTLIST
        do
            # find out if torrent complete or not
            DL_COMPLETED=`/usr/bin/transmission-remote --torrent $TORRENTID --info | grep "Percent Done: 100%"`
            # pause completed torrents & and start uncomplete torrents
            if [ "$DL_COMPLETED" != "" ]; then
                TORRENTLOCATION=`/usr/bin/transmission-remote -l -t $TORRENTID --info | grep Location| sed -e "s/^ *Location: \/home\/mathieu\/D$
                /usr/bin/transmission-remote --torrent $TORRENTID --move /media/ubuserver/Transfer-macmini/$TORRENTLOCATION/ > /dev/null 2>&1
                /usr/bin/transmission-remote --torrent $TORRENTID --remove > /dev/null 2>&1
            else
                /usr/bin/transmission-remote --torrent $TORRENTID --start > /dev/null 2>&1
            fi
        done
    fi
    exit 0
fi

