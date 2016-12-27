#!/bin/sh

##
##  User-configurable Variables
##

# Where "mail" is installed on your system.
# We need this to actually send the mail, so make sure it's installed using "sudo apt-get install mailutils"
# I used ssmtp for the actual sending, see https://techknight.eu/2014/12/09/send-mail-witg-google-smtp-ubuntu-14-04/
MAIL=/usr/bin/mail

# REQUIRED CHANGE #1: you must set your email address.
# Change "yourname@yourmail.com" here and remove the leading '#' to
# use a real email address
# TO_ADDR=yourname@yourmail.com
#

###
###  Send the mail...
###

SUBJECT="Torrent Done!"
FROM_ADDR="transmission@localhost.localdomain"
TMPFILE=`mktemp -t transmission.XXXXXXXXXX`
echo "Transmission finished downloading \"$TR_TORRENT_NAME\" on $TR_TIME_LOCALTIME" >$TMPFILE
$MAIL -s "$SUBJECT" $TO_ADDR < $TMPFILE
rm $TMPFILE
