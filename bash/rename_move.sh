#!/bin/bash
sourceDirectory="/media/popcorn/Transfer/ubuserver/Movies/"
movieDirectory="/media/Media/Movies2/"
kidsDirectory="/media/Media/Kids2/"

#First go into our source directory
cd $sourceDirectory

#Move all files from subfolders into root folder
find . -type f -mindepth 2 -exec mv -i -f -- {} . \;

#Remove stuff we don't care about 
#Based on extensions txt|nfo|png|jpg|url|sfv|srt
find . -type f -name "*.txt" -exec rm -f {} \;
find . -type f -name "*.nfo" -exec rm -f {} \;
find . -type f -name "*.png" -exec rm -f {} \;
find . -type f -name "*.jpg" -exec rm -f {} \;
find . -type f -name "*.url" -exec rm -f {} \;
find . -type f -name "*.sfv" -exec rm -f {} \;
find . -type f -name "*.srt" -exec rm -f {} \;

#Based on names sample|trailer|extras|
find . -type f -name "*sample*" -exec rm -f {} \;
find . -type f -name "*trailer*" -exec rm -f {} \;
find . -type f -name "*extras*" -exec rm -f {} \;
find . -type f -name "ETRG.mp4" -exec rm -f {} \;

#Remove subfolders
find . -type d -empty -delete

#Rename
echo "Renaming"

#Using filebot to rename files consistently - see http://www.filebot.net/cli.html
echo `filebot -rename $sourceDirectory* --format '{n} ({y})' -non-strict`

echo "Rename Complete"

#Move
if [ $1 = "kids" ]; then
	echo "Moving to Kids directory"
	echo `mv $sourceDirectory* $kidsDirectory`
else
	echo "Moving to Movies directory"
	echo `mv $sourceDirectory* $movieDirectory`
fi

echo "Move Complete"
