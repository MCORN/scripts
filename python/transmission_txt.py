#!/usr/bin/env python
# Add the file to pull the magnet links from
diff = 'magnet.txt'

# Transmission RPC details
# Fill in your transmission details below
USER = 'username'		# Username
PASS = 'password'		# Password
HOST = 'localhost'		# The Transmission host (remote or local)
PORT = '9091'			# The same port as used by the server

# ------------------------------------------------------------------------------------------------------------------
# DO NOT MODIFY BELOW THIS LINE UNLESS YOU KNOW WHAT YOU ARE DOING!!
# ------------------------------------------------------------------------------------------------------------------

# Import some needed libraries
import transmissionrpc

# Connect to the transmission RPC server
tc = transmissionrpc.Client(HOST, port=PORT, user=USER, password=PASS)

# Loop through the file and post to transmission
f = open(diff)
for line in iter(f):
    # Add torrents to transmission via the rpc. If one fails, move on to the next one.
        try:
            tc.add_torrent(line)
        except:
            pass
f.close()
