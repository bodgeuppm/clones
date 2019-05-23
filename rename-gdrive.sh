
#!/bin/bash
############################################

#Function
AC=find
NM=-name
MD=-maxdepth
EP=-empty

#############################################
## -def plex host:token
PT=nhEUsdiSCyrgMqf3quHC
PH=https://plex.free-4-live.rocks

#############################################

#if [ -z "$PT" ]; then

#    cat /var/plexguide/plex.token

# >&2 echo 'Plex-Token found well done'

#fi

#PT='tail /var/plexguide/plex.token' 

#ORDNER
DIR1=/mnt/complete
OUT=/mnt/move
SCP=/mnt/scripte
FBOT=/mnt/filebot

#############################################

#Ausführung unPACK FILME-SD

 $AC $DIR1 $MD 8 $NM "*.rar" -execdir unrar x -o- {} \;
 $AC $DIR1 $MD 8 $NM "*.sfv" -exec rm -f \{\} \;
 $AC $DIR1 $MD 8 $NM "*.txt" -exec rm -f \{\} \;
 $AC $DIR1 $MD 8 $NM "*.xml" -exec rm -f \{\} \;
 $AC $DIR1 $MD 8 $NM "Sample" -exec rm -rf {} \;
 $AC $DIR1 $MD 8 $NM "Proof" -type d -exec rm -rf \{} \;
 $AC $DIR1 $MD 8 $NM "Screens" -type d -exec rm -rf \{} \;
 $AC $DIR1 $MD 8 $NM "Cover" -type d -exec rm -rf \{} \;
 $AC $DIR1 $MD 8 $NM "Subs" -type d -exec rm -rf \{} \;
 $AC $DIR1 $MD 8 $NM "*jpg" -exec rm -f \{\} \;
 $AC $DIR1 $MD 8 $NM "*jpeg" -exec rm -f \{\} \;
 $AC $DIR1 $MD 8 $NM "*-sample.mkv" -exec rm -f \{\} \;
 $AC $DIR1 $MD 8 $NM "*sample" -exec rm -rf \{} \;
 $AC $DIR1 $MD 8 $NM "Screens*" -exec rm -rf \{} \;
 $AC $DIR1 $MD 8 $NM "Covers*" -exec rm -rf \{} \;
 $AC $DIR1 $MD 8 $NM "*.nfo" -exec rm -rf \{} \;
 $AC $DIR1 $MD 8 $NM "Sample*" -exec rm -f \{} \;
 $AC $DIR1 $MD 8 $NM "*sample*" -exec rm -f \{} \;
 $AC $DIR1 $MD 8 $NM "*samp*" -exec rm -f \{} \;
 $AC $DIR1 $MD 8 $NM "*.png" -exec rm -f \{} \;

 $AC $DIR1 $MD 15 -mindepth 1  $NM "*.r[a0-9][r0-9]" -type f -exec rm -rf \{} \;

#nfo clean

 $AC $DIR1 $MD 15 $NM "*.nfo" -type f -exec rm -rf \{} \;

 $AC $DIR1 -mindepth 2 -type d $EP -exec rmdir \{} \;

#############################################

##Rechte setzten
chown -cR mrdoob:mrdoob $DIR1
chmod 750 $DIR1


##rename-files
#python3 $SCP/rename.py $DIR1/FILME-HD/
#python3 $SCP/rename.py $DIR1/FILME-SD/
#############################################

# --def plex = host: token erneut zu scannen

#Sagen Sie der angegebenen Plex-Instanz, dass sie ihre Bibliothek erneut scannen soll.
#Plex Home-Instanzen erfordern ein Authentifizierungstoken .

# --def plex = host: token erneut zu scannen


#PT=cat /var/plexguide/plex.token)
#PH=http://localhost:32400

##filebot-running

#Serien
bash $FBOT/filebot.sh -script $FBOT/scripts/renall.groovy "$DIR1/SERIEN/" -non-strict --conflict override --format "$OUT/{plex}" --db TheTVDB --def plex=$PH:$PT
#Anime
#bash $FBOT.sh/filebot.sh -script $FBOT/scripts/renall.groovy "$DIR1/ANIME-incom/" -non-strict --conflict override --format "$OUT/{plex}" --db AniDB
#Filme-1080p
bash $FBOT/filebot.sh -script $FBOT/scripts/renall.groovy "$DIR1/FILME-HD/" -non-strict --conflict override --format "$OUT/{plex}" --db TheMovieDB --def plex=$PH:$PT


chown -cR mrdoob:mrdoob /mnt/move

exit 0
