#!/bin/bash

# this directory will get a copy of every incoming pkt file.
L=/var/spool/ftn/archive/

# create any missing directory
mkdir -p $L
mkdir -p ~/tmp/

# stop processing if the incoming directory is empty.
if find "/srv/ftp/in" -maxdepth 0 -empty | grep -q "."; then
    echo "[$(date)] /srv/ftp/in is empty" 
    exit 0
fi

# make a list of all the FTN addresses that you want to accept netmail for; the 00 are example addresses; the \.* allows for netmails to be routed to your points
FTN_REGEX="^(2:280/0000|618:500/00|21:1/00)\.*"

# this is the directory where proftpd writes the uploads
FILES="/srv/ftp/in/*"
for f in $FILES
do
  echo "Processing $f file..."
  b=$(basename $f)
  # we try and move the file so that we know the upload is finished
  mv -v $f ~/tmp/$b
  # we relie on pktinfo to get the Destination address from the pkt file to see if it is for us. If not, it will stay in the tmp folder forever.
  my_str=$(pktinfo ~/tmp/$b | grep DestAddr | awk '{print $2}')
if [[ $my_str =~ $FTN_REGEX ]]; then
    echo "destination is local"
    # make an archive copy
    cp -v ~/tmp/$b $L/`date '+%s'`_$b
    # move to the insecure directory of hpt
    mv -v ~/tmp/$b /var/spool/ftn/inb/insecure/$b
fi
  sleep 2
done
# since we didn't exit on empty, flag hpt to do tossing
touch /var/spool/ftn/flags/toss
