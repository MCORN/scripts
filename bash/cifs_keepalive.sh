#!/bin/bash

while read spot; do
   touch --no-create "${spot}/.cifs_keepalive"
done <<< "$(mount | awk '/cifs/{ print $3; }')"
