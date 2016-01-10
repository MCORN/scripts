#!/bin/bash
sourceDirectory="/media/popcorn/Transfer/ubuserver/Movies/*"
movieDirectory="/media/Media/Movies2/"
kidsDirectory="/media/Media/Kids2/"

#Rename
echo "Renaming"

#Using filebot to rename files consistently - see http://www.filebot.net/cli.html
echo `filebot -rename $sourceDirectory --format '{n} ({y})' -non-strict`

echo "Rename Complete"

#Move
if [ $1 = "kids" ]; then
	echo "Moving to Kids directory"
	echo `mv $sourceDirectory $kidsDirectory`
else
	echo "Moving to Movies directory"
	echo `mv $sourceDirectory $movieDirectory`
fi

echo "Move Complete"
