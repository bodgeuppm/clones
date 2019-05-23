#!/bin/bash

mkdir /mnt/gdrive/plexguide/plexfullbackup/

cp -arv /opt/appdata/plex/ /tmp/plex-backup/

chown -cR 1000:1000 /tmp/plex-backup/

cd /tmp/

tar -cf plexfullbackup-"$(date '+%Y-%m-%d').tar.gz" plex-backup/

cp -arv plexfullbackup-"$(date '+%Y-%m-%d').tar.gz" /mnt/gdrive/plexguide/plexfullbackup/

rm /tmp/plexfullbackup-"$(date '+%Y-%m-%d').tar.gz"

rm -rv /tmp/plex-backup/*

exit 0
