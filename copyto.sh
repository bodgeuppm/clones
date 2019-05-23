#!/bin/bash

while [ 1 ]; do

rm /var/plexguide/moveto.log

echo "" >> /var/plexguide/moveto.log
echo "----------------------------" >> /var/plexguide/moveto.log
echo "PG Blitz Log - First Startup" >> /var/plexguide/moveto.log

  rclone moveto "/mnt/down/FILME-HD/" "/mnt/complete/FILME-HD/" \
  --log-file=/var/plexguide/moveto.log \
  --log-level INFO --stats 5s --stats-file-name-length 0 \
  --transfers 6 \
  --min-age 24h \
  --use-server-modtime

  rclone moveto "/mnt/down/SERIEN/" "/mnt/complete/SERIEN/" \
  --log-file=/var/plexguide/moveto.log \
  --log-level INFO --stats 5s --stats-file-name-length 0 \
  --transfers 6 \
  --min-age 24h \
  --use-server-modtime

  rclone moveto "/mnt/down/ANIME/" "/mnt/complete/ANIME/" \
  --log-file=/var/plexguide/moveto.log \
  --log-level INFO --stats 5s --stats-file-name-length 0 \
  --transfers 6 \
  --min-age 24h \
  --use-server-modtime

  echo "Files moved | older as 24h " >> /var/plexguide/moveto.log
  echo "unpack | rename runnig" >> /var/plexguide/moveto.log

  sleep 30

#Function
AC=find
NM=-name
MD=-maxdepth
EP=-empty

#############################################
## -def plex host:token
PT=$(cat /var/plexguide/plex.token)
PH=plex

#############################################

#ORDNER
DIR1=/mnt/complete
OUT=/mnt/cache
SCP=/mnt/scripte
FBOT=/mnt/filebot

#############################################

#Ausführung unPACK FILME-SD
 $AC $DIR1 $MD 8 $NM "*.rar" -execdir unrar x -o- -c-  {} \; >> /var/plexguide/moveto.log
 $AC $DIR1 $MD 8 $NM "*.sfv" -exec rm -f \{\} \; >> /var/plexguide/moveto.log
 $AC $DIR1 $MD 8 $NM "*.txt" -exec rm -f \{\} \; >> /var/plexguide/moveto.log
 $AC $DIR1 $MD 8 $NM "*.xml" -exec rm -f \{\} \; >> /var/plexguide/moveto.log
 $AC $DIR1 $MD 8 $NM "Sample" -exec rm -rf {} \; >> /var/plexguide/moveto.log
 $AC $DIR1 $MD 8 $NM "Proof" -type d -exec rm -rf \{} \; >> /var/plexguide/moveto.log
 $AC $DIR1 $MD 8 $NM "Screens" -type d -exec rm -rf \{} \; >> /var/plexguide/moveto.log
 $AC $DIR1 $MD 8 $NM "Cover" -type d -exec rm -rf \{} \; >> /var/plexguide/moveto.log
 $AC $DIR1 $MD 8 $NM "Subs" -type d -exec rm -rf \{} \; >> /var/plexguide/moveto.log
 $AC $DIR1 $MD 8 $NM "*jpg" -exec rm -f \{\} \; >> /var/plexguide/moveto.log
 $AC $DIR1 $MD 8 $NM "*jpeg" -exec rm -f \{\} \; >> /var/plexguide/moveto.log
 $AC $DIR1 $MD 8 $NM "*-sample.mkv" -exec rm -f \{\} \; >> /var/plexguide/moveto.log
 $AC $DIR1 $MD 8 $NM "*sample" -exec rm -rf \{} \; >> /var/plexguide/moveto.log
 $AC $DIR1 $MD 8 $NM "Screens*" -exec rm -rf \{} \; >> /var/plexguide/moveto.log
 $AC $DIR1 $MD 8 $NM "Covers*" -exec rm -rf \{} \; >> /var/plexguide/moveto.log
 $AC $DIR1 $MD 8 $NM "*.nfo" -exec rm -rf \{} \; >> /var/plexguide/moveto.log
 $AC $DIR1 $MD 8 $NM "Sample*" -exec rm -f \{} \; >> /var/plexguide/moveto.log
 $AC $DIR1 $MD 8 $NM "*sample*" -exec rm -f \{} \; >> /var/plexguide/moveto.log
 $AC $DIR1 $MD 8 $NM "*samp*" -exec rm -f \{} \; >> /var/plexguide/moveto.log
 $AC $DIR1 $MD 8 $NM "*.png" -exec rm -f \{} \; >> /var/plexguide/moveto.log
 $AC $DIR1 $MD 15 -mindepth 1  $NM "*.r[a0-9][r0-9]" -type f -exec rm -rf \{} \; >> /var/plexguide/moveto.log
 $AC $DIR1 $MD 8 $NM "subs" -type d -exec rm -rf \{} \; >> /var/plexguide/moveto.log
 $AC $DIR1 $MD 8 "#" -exec -type -f -exec rm -rf \{} \; >> /var/plexguide/moveto.log

#nfo clean

 $AC $DIR1 $MD 15 $NM "*.nfo" -type f -exec rm -rf \{} \; >> /var/plexguide/moveto.log
 $AC $DIR1 -mindepth 2 -type d $EP -exec rmdir \{} \; >> /var/plexguide/moveto.log
 $AC /mnt/down/ -mindepth 2 -type d $EP -exec rmdir \{} \; >> /var/plexguide/moveto.log
 $AC /mnt/cache/ -mindepth 2 -type d $EP -exec rmdir \{} \; >> /var/plexguide/moveto.log

#############################################

##Rechte setzten
chown -cR <<//paste the username //>>:<<//paste the username //>> $DIR1 >> /var/plexguide/moveto.log
chmod -R 775 $DIR1 >> /var/plexguide/moveto.log
#############################################


#Serien
bash $FBOT/filebot.sh -script $FBOT/scripts/renall.groovy "$DIR1/SERIEN/" -non-strict --conflict override --format "$OUT/{plex}" --db TheTVDB >> /var/plexguide/moveto.log
#Anime
bash $FBOT/filebot.sh -script $FBOT/scripts/renall.groovy "$DIR1/ANIME/" -non-strict --conflict override --format "$OUT/{plex}" --db TheTVDB >> /var/plexguide/moveto.log
#Filme-1080p
bash $FBOT/filebot.sh -script $FBOT/scripts/renall.groovy "$DIR1/FILME-HD/" -non-strict --conflict override --format "$OUT/Movies/{n} ({y})/{n} ({y})" --db TheMovieDB >> /var/plexguide/moveto.log

#reCeeate folder
#mkdir $DIR1/{FILME-HD,SERIEN}

#rights
chown -cR <<//paste the username //>>:<<//paste the username //>> /mnt/cache >> /var/plexguide/moveto.log
chmod -cR 775 /mnt/cache >> /var/plexguide/moveto.log

rm -rf /var/plexguide/moveto.log >> /var/plexguide/moveto.log
echo "" >> /var/plexguide/moveto.log
echo "log cleaned" >> /var/plexguide/moveto.log
echo "" >> /var/plexguide/moveto.log
echo "all done | sleep for 3h" >> /var/plexguide/moveto.log
echo "" >> /var/plexguide/moveto.log
echo "finished @ $(date)"  >> /var/plexguide/moveto.log

  sleep 3h

done
