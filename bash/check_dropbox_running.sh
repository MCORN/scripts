if ! pgrep -x "dropbox" > /dev/null
then
    /usr/bin/python /home/mathieu/dropbox.py start
    /bin/sleep 1m
fi

if ! pgrep -x "dropbox" > /dev/null
then
    touch test2.txt
    /usr/bin/mail -s "Dropbox is not running on $(hostname)" dropbox-ubuserv02@localhost.localdomain < test2.txt > /dev/null 2>&1
    rm test2.txt
    exit 0
fi
