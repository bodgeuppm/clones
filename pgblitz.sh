#!/bin/bash
#
# Title:      PGBlitz (Reference Title File)
# Author(s):  Admin9705 & PhysK
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################

# Starting Actions
touch /var/plexguide/logs/pgblitz.log

# Repull excluded folder 
 wget -qN https://raw.githubusercontent.com/PGBlitz/PGClone/v8.6/functions/exclude -P /opt/pgclone/functions/

echo "" >> /var/plexguide/logs/pgblitz.log
echo "" >> /var/plexguide/logs/pgblitz.log
echo "----------------------------" >> /var/plexguide/logs/pgblitz.log
echo "PG Blitz Log - First Startup" >> /var/plexguide/logs/pgblitz.log
chown -R 1000:1000 "{{hdpath}}/downloads"
chmod -R 775 "{{hdpath}}/downloads"
chown -R 1000:1000 "{{hdpath}}/move"
chmod -R 775 "{{hdpath}}/move"
startscript () {
while read p; do

  cleaner="$(cat /var/plexguide/cloneclean)"
  useragent="$(cat /var/plexguide/uagent)"

  let "cyclecount++"
  echo "----------------------------" >> /var/plexguide/logs/pgblitz.log
  echo "PG Blitz Log - Cycle $cyclecount" >> /var/plexguide/logs/pgblitz.log
  echo "" >> /var/plexguide/logs/pgblitz.log
  echo "Utilizing: $p" >> /var/plexguide/logs/pgblitz.log

  rclone moveto "{{hdpath}}/downloads/" "{{hdpath}}/move/" \
  --config /opt/appdata/plexguide/rclone.conf \
  --log-file=/var/plexguide/logs/pgblitz.log \
  --log-level ERROR --stats 5s --stats-file-name-length 0 \
  --min-age 2m \
  --fast-list \
  --update \
  --exclude-from="/opt/appdata/plexguide/exclude/exclude-file.txt"

  chown -R 1000:1000 "/mnt/move"
  chmod -R 775 "/mnt/move"

  rclone moveto "{{hdpath}}/move" "${p}{{encryptbit}}:/" \
  --config /opt/appdata/plexguide/rclone.conf \
  --log-file=/var/plexguide/logs/pgblitz.log \
  --log-level INFO --stats 5s --stats-file-name-length 0 \
  --tpslimit 12 \
  --checkers=20 \
  --transfers=16 \
  --bwlimit {{bandwidth.stdout}}M \
  --max-size=300G \
  --user-agent="$useragent" \
  --drive-chunk-size={{vfs_dcs}}M \
  --exclude-from="/opt/appdata/plexguide/exclude/exclude-file.txt"

  echo "Cycle $cyclecount - Sleeping for 30 Seconds" >> /var/plexguide/logs/pgblitz.log
  cat /var/plexguide/logs/pgblitz.log | tail -200 > /var/plexguide/logs/pgblitz.log
  #sed -i -e "/Duplicate directory found in destination/d" /var/plexguide/logs/pgblitz.log
  sleep 30
  echo "Cycle $cyclecount - Sleeping for 30 Seconds" >> /var/plexguide/logs/pgblitz.log
  cat /var/plexguide/logs/pgblitz.log | tail -200 > /var/plexguide/logs/pgblitz.log
  #sed -i -e "/Duplicate directory found in destination/d" /var/plexguide/logs/pgblitz.log
  sleep 30

  #Quick fix
  # Remove empty directories
  #find "$dlpath/downloads/" -mindepth 2 -type d -empty -exec rm -rf {} \;
  #find "$dlpath/move/" -type d -empty -exec rm -rf {} \;
  #find "$dlpath/move/" -mindepth 2 -type f -cmin +5 -size +1M -exec rm -rf {} \;

  # Remove empty directories
  find "{{hdpath}}/move/" -mindepth 2 -type d -mmin +2 -empty -exec rm -rf {} \;

  # Removes garbage | torrent folder excluded 
  find "{{hdpath}}/downloads" -mindepth 2 -type d -cmin +$cleaner  $(printf "! -name %s " $(cat /opt/pgclone/functions/exclude)) -empty -exec rm -rf {} \;
  find "{{hdpath}}/downloads" -mindepth 2 -type f -cmin +$cleaner  $(printf "! -name %s " $(cat /opt/pgclone/functions/exclude)) -size +1M -exec rm -rf {} \;

done </var/plexguide/.blitzfinal
}

# keeps the function in a loop
cheeseballs=0
while [[ "$cheeseballs" == "0" ]]; do startscript; done
