# Based on https://www.zufallsheld.de/2014/01/25/python-backup-script-revisited/
# http://amoffat.github.io/sh/
# Example
# /usr/bin/python /home/mathieu/scripts/python/backup.py --logfile=/home/mathieu/logs/backup.log --trash /media/Media/ /media/Media-Backup

#!/usr/bin/env python

import os
from shutil import rmtree
import argparse
import logging
from sh import rsync
from sh import date

#Parse arguments
parser = argparse.ArgumentParser(
    description=__doc__)

parser.add_argument("src", help="Specify the directory to backup.")
parser.add_argument("dest", help="Specify the directory where the backup is stored.")
parser.add_argument("-t", "--trash", help="Delete files from destination that don't exist in source.", action="store_true")
parser.add_argument("-l", "--logfile", help="Specify the logfile to log to.")
parser.add_argument("-p", "--echo", help="Print actual rsync command ran without any actions", action="store_true")
parser.add_argument("-n", "--dryrun", help="Run rsync as dry run to see what would be changed", action="store_true")

args = parser.parse_args()

# Define variables
backupdir = args.src
destinationdir = args.dest
logfile = args.logfile

#Directory checks
def check_dir_exist(os_dir):
    if not os.path.exists(os_dir):
        logging.error("{} does not exist.".format(os_dir))
        exit(1)

check_dir_exist(backupdir)
check_dir_exist(destinationdir)

#Core rsync arguments				
rsync_args = "-ahv"

#Add rsync arguments based on user input	
if args.dryrun:
	rsync_args += "n"
if logfile:
	log_args = args.logfile
else:
	log_args = ""
	
#Do the actual backup
logging.info("Starting rsync.")
if args.echo:
	if args.trash:
		del_args = "--del"
	else:
		del_args = ""
	print("The command is rsync %s %s %s %s %s %s" % (rsync_args, del_args, backupdir, destinationdir, ">>", log_args))
else:
	if args.trash:
		rsync(rsync_args,"--del",backupdir,destinationdir,_out=log_args)
	else:
		rsync(rsync_args,backupdir,destinationdir,_out=log_args)
