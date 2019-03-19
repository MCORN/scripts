#!/bin/bash
usage="$(basename "$0") [help] [movies] [kids]-- program to rename movie files

where:
    help  show this help text
    movies sets a specific source and destination for adult content
    kids sets a specific source and destination for kids content

    The last 2 options then continue processing through the following steps:
    - files in source folder are moved from subfolders if any to the root source folder
    - empty directories and non-media files are removed using hardcoded rules
    - remaining files are renamed using Filebot in a human-friendly format
    - remaining files are moved to the destination"

if [[ $# -eq 0 ]] ; then
    echo 'Please provide either "help", movies" or "kids" argument'
    exit 0
fi

if [ "$1" == "help" ]; then
  echo "$usage"
  exit 0
elif [ $1 = "movies" ]; then
    sourceConfig="configMovies.xml"
    sourceDirectory="/media/Other/Transfer/Movies/"
    targetDirectory="/media/Media/Movies2/"
elif [ $1 = "kids" ]; then
    sourceConfig="configKids.xml"
    sourceDirectory="/media/Other/Transfer/Kids/"
    targetDirectory="/media/Media/Kids2/"
fi

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
find . -type f -name "*.nfo" -exec rm -f {} \;

#Based on names sample|trailer|extras|
find . -type f -name "*sample*" -exec rm -f {} \;
find . -type f -name "*Sample*" -exec rm -f {} \;
find . -type f -name "*trailer*" -exec rm -f {} \;
find . -type f -name "*extras*" -exec rm -f {} \;
find . -type f -name "ETRG.mp4" -exec rm -f {} \;

#Remove subfolders
find . -type d -empty -delete

#Rename
echo "Renaming"

#Switching from filebot to tmm
/media/Other-Local/Apps/tmm/tinyMediaManagerCMD.sh -config $sourceConfig -update -scrapeNew -renameNew

#Now to clean up because TMM creates subfolders and we don't need them
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
find . -type f -name "*.nfo" -exec rm -f {} \;

#Based on names sample|trailer|extras|
find . -type f -name "*sample*" -exec rm -f {} \;
find . -type f -name "*Sample*" -exec rm -f {} \;
find . -type f -name "*trailer*" -exec rm -f {} \;
find . -type f -name "*extras*" -exec rm -f {} \;
find . -type f -name "ETRG.mp4" -exec rm -f {} \;

#Remove subfolders
find . -type d -empty -delete

#Reset TMM DB
rm /media/Other-Local/Apps/tmm/data/movies.db
cp /media/Other-Local/Apps/tmm/data/moviesEmpty.db /media/Other-Local/Apps/tmm/data/movies.db

echo "Rename Complete"

#Move
if [ $1 = "kids" ]; then
        echo "Moving to Kids directory"
        echo `mv $sourceDirectory* $targetDirectory`
elif [ $1 = "movies" ]; then
        echo "Moving to Movies directory"
        echo `mv $sourceDirectory* $targetDirectory`
fi


echo "Move Complete"
