#!/usr/bin/env python
 
# Import modules
import os
 
# Define variables
# 1073741824 bytes = 1 GB
xsize = 1073741824
path  = r'/media/Movies-Backup/Movies'
 
# List all files bigger than 1073741824 bytes
print "\nList files bigger than " + str(xsize) + " bytes"
print "=======================" + "=" * len(str(xsize)) + "====="
for root, dirs, files in os.walk(path):
  for name in files:
    filename = os.path.join(root, name)
    if os.stat(filename).st_size > xsize:
      # print(filename)
	  os.remove(filename)