#!/bin/bash
usage="$(basename "$0") [help] -- check public external IP against the external IP of the machine

where:
    help  show this help text

    * If the IPs are the same, then the machine isn't on the VPN and an email notification is sent
    * first argument (if not help) is ignored, other parameters are pulled from config file
    * config file 'check_external_ip.config' located in same directory as this script
    * Parameters defined in config file are:
    EMAIL - prefix to @gmail.com
    "

if [ "$1" == "help" ]; then
  echo "$usage"
  exit 0
else
    #On VPN
    machine_ip=$(wget -qO- http://ipecho.net/plain)
    #Off VPN
    public_ip=$(</media/ubuserver/ip.txt)
    #If the same, Houston we have a problem! Restart OpenVPN
    if [ $public_ip == $machine_ip ]; then
        #Stop all torrents
        /usr/bin/transmission-remote -t all -S
        #Restart open-vpn
	systemctl stop openvpnauto.service
	sleep 5
	systemctl start openvpnauto.service
	#Send an email
	/home/mathieu/Git/scripts/bash/send_email.sh 'Ubu-serv-04 is not on the VPN'
    else
        # find out number of torrent
        TORRENTLIST=`/usr/bin/transmission-remote localhost:80 --list | sed -e '1d;$d;s/^ *//' | cut --only-delimited --delimiter=' ' --fields=1`
        for TORRENTID in $TORRENTLIST
        do
            # find out if torrent complete or not
            DL_COMPLETED=`/usr/bin/transmission-remote localhost:80 --torrent $TORRENTID --info | grep "Percent Done: 100%"`
            # pause completed torrents & and start uncomplete torrents
            if [ "$DL_COMPLETED" != "" ]; then
              # if already moved, then remove from transmission
              if [[ $(/usr/bin/transmission-remote localhost:80 -l -t $TORRENTID --info | grep Location| grep "Transfer-macmini") != "" ]]; then
                /usr/bin/transmission-remote localhost:80 --torrent $TORRENTID --remove > /dev/null 2>&1
              fi
              # if completed, move to relevant folder
              if [[ $(/usr/bin/transmission-remote localhost:80 -l -t $TORRENTID --info | grep Location| grep "Downloads/Movies") != "" ]]; then
                /usr/bin/transmission-remote localhost:80 --torrent $TORRENTID --move /media/ubuserver/Transfer-macmini/Movies/ > /dev/null 2>&1
	      fi
              if [[ $(/usr/bin/transmission-remote localhost:80 -l -t $TORRENTID --info | grep Location| grep "Downloads/Kids") != "" ]]; then
                /usr/bin/transmission-remote localhost:80 --torrent $TORRENTID --move /media/ubuserver/Transfer-macmini/Kids/ > /dev/null 2>&1
              fi
              if [[ $(/usr/bin/transmission-remote localhost:80 -l -t $TORRENTID --info | grep Location| grep "Downloads/Music") != "" ]]; then
                /usr/bin/transmission-remote localhost:80 --torrent $TORRENTID --move /media/ubuserver/Transfer-macmini/Music/ > /dev/null 2>&1
              fi
              if [[ $(/usr/bin/transmission-remote localhost:80 -l -t $TORRENTID --info | grep Location| grep "Downloads/Other") != "" ]]; then
                /usr/bin/transmission-remote localhost:80 --torrent $TORRENTID --move /media/ubuserver/Transfer-macmini/Other/ > /dev/null 2>&1
              fi
            else
                /usr/bin/transmission-remote localhost:80 --torrent $TORRENTID --start > /dev/null 2>&1
	    fi
	done
    fi
    exit 0
fi
