#!/bin/bash

# file names to filter

UNWANTED_FILES=(
'pgblitz.log'
'dedupe.log'
'clean.log'
)

# advanced settings

FIND=$(which find)
FIND_BASE_CONDITION='-type f'
FIND_ADD_NAME='-o -name'
FIND_ACTION=' -delete'

#Folder Setting
#Folder Setting

TARGET_FOLDER=$1'/var/plexguide/logs/'

TARGET_FOLDER=$1'/var/plexguide/logs/'
if [ ! -d "${TARGET_FOLDER}" ]; then
        echo 'Target directory does not exist.'
        exit 1
fi

condition="-name '${UNWANTED_FILES[0]}'"
for ((i = 1; i < ${#UNWANTED_FILES[@]}; i++))
do
    condition="${condition} ${FIND_ADD_NAME} '${UNWANTED_FILES[i]}'"
done

command="${FIND} '${TARGET_FOLDER}' ${FIND_BASE_CONDITION} \( ${condition} \) ${FIND_ACTION}"
echo "Executing ${command}"
eval ${command}

exit 0


