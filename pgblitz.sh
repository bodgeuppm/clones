#!/bin/bash
#
# Title:      PGBlitz (Reference Title File)
# Author(s):  Admin9705 & PhysK
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################
source /opt/pgclone/functions/pgblitz.sh

#starter
#stasks

# Outside Variables
dlpath=$(cat /var/plexguide/server.hd.path)

# Starting Actions

touch /var/plexguide/logs/pgblitz.log

# Inside Variables
ls -la /opt/appdata/pgblitz/keys/processed | awk '{print $9}' | grep gdsa > /opt/appdata/plexguide/key.list
keytotal=$(wc -l /opt/appdata/plexguide/key.list | awk '{ print $1 }')

keyfirst=$(cat /opt/appdata/plexguide/key.list | head -n1)
keylast=$(cat /opt/appdata/plexguide/key.list | tail -n1)

keycurrent=0
cyclecount=0

echo "" >> /var/plexguide/logs/pgblitz.log
echo "" >> /var/plexguide/logs/pgblitz.log
echo "----------------------------" >> /var/plexguide/logs/pgblitz.log
echo "PG Blitz Log - First Startup" >> /var/plexguide/logs/pgblitz.log

chown -R 1000:1000 "$dlpath/downloads"
chmod -R 775 "$dlpath/downloads"
chown -R 1000:1000 "$dlpath/move"
chmod -R 775 "$dlpath/move"

while [ 1 ]; do

  dlpath=$(cat /var/plexguide/server.hd.path)

  # Permissions

  if [ "$keylast" == "$keyuse" ]; then keycurrent=0; fi

  let "keycurrent++"
  keyuse=$(sed -n ''$keycurrent'p' < /opt/appdata/plexguide/key.list)

  encheck=$(cat /var/plexguide/pgclone.transport)
    if [ "$encheck" == "eblitz" ]; then
    keytransfer="${keyuse}C"; else keytransfer="$keyuse"; fi

let "cyclecount++"
  echo "----------------------------" >> /var/plexguide/logs/pgblitz.log
  echo "PG Blitz Log - Cycle $cyclecount" >> /var/plexguide/logs/pgblitz.log
  echo "" >> /var/plexguide/logs/pgblitz.log
  echo "Utilizing: $keytransfer" >> /var/plexguide/logs/pgblitz.log
  
  rclone moveto "$dlpath/downloads/" "$dlpath/move/" \
  --config /opt/appdata/plexguide/rclone.conf \
  --log-file=/var/plexguide/logs/pgblitz.log \
  --log-level INFO --stats 5s --stats-file-name-length 0 \
  --min-age 3d \
  --transfers=4 \
  --checkers=8 \
  --fast-list \
  --update \
  --exclude-from="/opt/appdata/pgblitz/exclude/exclude-file.txt"

  chown -R 1000:1000 "$dlpath/move"
  chmod -R 775 "$dlpath/move"

  rclone moveto "$dlpath/move/" "$keytransfer:/" \
  --config /opt/appdata/plexguide/rclone.conf \
  --log-file=/var/plexguide/logs/pgblitz.log \
  --log-level INFO --stats 5s --stats-file-name-length 0 \
  --min-age 1m \
  --tpslimit 12 \
  --checkers=8 \
  --transfers=4 \
  --update \
  --user-agent="mycase" \
  --fast-list \
  --bwlimit 1000M \
  --max-size=300G \
  --drive-chunk-size=128M \
  --exclude-from="/opt/appdata/pgblitz/exclude/exclude-file.txt"

  echo "Cycle $cyclecount - Sleeping for 30 Seconds" >> /var/plexguide/logs/pgblitz.log
  cat /var/plexguide/logs/pgblitz.log | tail -200 > /var/plexguide/logs/pgblitz.log

  sleep 5

# Remove empty directories
find "$dlpath/downloads" -mindepth 2 -type d -empty -exec rm -rf {} \;
find "$dlpath/move/" -type d -empty -exec rm -rf {} \;
find "$dlpath/move/" -mindepth 2 -type f -cmin +5 -size +1M -exec rm -rf {} \;

done
