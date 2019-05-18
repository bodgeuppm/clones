#!/bin/bash
############################################

#Function
AC=find
NM=-name
MD=-maxdepth
EP=-empty
#############################################
#ORDNER
DIR1=/mnt/unionfs
#############################################
#remover
 $AC $DIR1 $MD 8 $NM "*.sfv" -exec rm -f \{\} \;
 $AC $DIR1 $MD 8 $NM "*.txt" -exec rm -f \{\} \;
 $AC $DIR1 $MD 8 $NM "*.xml" -exec rm -f \{\} \;
 $AC $DIR1 $MD 8 $NM "Sample" -exec rm -rf {} \;
 $AC $DIR1 $MD 8 $NM "Proof" -type d -exec rm -rf \{} \;
 $AC $DIR1 $MD 8 $NM "Screens" -type d -exec rm -rf \{} \;
 $AC $DIR1 $MD 8 $NM "Cover" -type d -exec rm -rf \{} \;
 $AC $DIR1 $MD 8 $NM "*jpg" -exec rm -f \{\} \;
 $AC $DIR1 $MD 8 $NM "*jpeg" -exec rm -f \{\} \;
 $AC $DIR1 $MD 8 $NM "*-sample.mkv" -exec rm -f \{\} \;
 $AC $DIR1 $MD 8 $NM "*sample" -exec rm -rf \{} \;
 $AC $DIR1 $MD 8 $NM "Screens*" -exec rm -rf \{} \;
 $AC $DIR1 $MD 8 $NM "*.nfo" -exec rm -rf \{} \;
 $AC $DIR1 $MD 8 $NM "Sample*" -exec rm -f \{} \;
 $AC $DIR1 $MD 8 $NM "*sample*" -exec rm -f \{} \;
 $AC $DIR1 $MD 8 $NM "*samp*" -exec rm -f \{} \;
 $AC $DIR1 $MD 8 $NM "*.png" -exec rm -f \{} \;
 $AC $DIR1 $MD 8 $NM "subs" -type d -exec rm -rf \{} \;
 $AC $DIR1 $MD 8 $NM "#" -exec -type -f -exec rm -rf \{} \;
 $AC $DIR1 $MD 15 $NM "*.nfo" -type f -exec rm -rf \{} \;
 $AC $DIR1 -mindepth 2 -type d $EP -exec rmdir \{} \;

exit 0
