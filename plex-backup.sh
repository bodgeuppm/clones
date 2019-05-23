#!/bin/bash

mkdir /mnt/gdrive/plexguide/plexdbbackups/

cp -arv /opt/appdata/plex/database/Library/Application\ Support/Plex\ Media\ Server/Plug-in\ Support/ /tmp/plex-backup/

chown -cR 1000:1000 /tmp/plex-backup/

cd /tmp/

tar -cf plexdbbackup-"$(date '+%Y-%m-%d').tar.gz" plex-backup/

cp -arv plexdbbackup-"$(date '+%Y-%m-%d').tar.gz" /mnt/gdrive/plexguide/plexdbbackups/

rm /tmp/plexdbbackup-"$(date '+%Y-%m-%d').tar.gz"

rm -rv /tmp/plex-backup/*

exit 0
