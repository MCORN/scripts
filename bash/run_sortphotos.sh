#!/bin/bash
/bin/chmod -R 777 /home/mathieu/Dropbox/Camera\ Uploads
/usr/bin/python /home/mathieu/Git/sortphotos/src/sortphotos.py --silent /home/mathieu/Dropbox/Camera\ Uploads /home/mathieu/Dropbox/Photos --sort %Y-%m-%d --rename %Y_%m%d_%H%M > /dev/null 2>&1
