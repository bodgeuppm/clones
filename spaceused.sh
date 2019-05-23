#!/bin/bash 

while [ 1 ]; do

 rm -rf /var/plexguide/logs/spaceused.log

echo " Used space @ $(date)"  >> /var/plexguide/logs/spaceused.log

	 du -sh /mnt/cache >> /var/plexguide/logs/spaceused.log
	 du -sh /mnt/pgblitz >> /var/plexguide/logs/spaceused.log
	 du -sh /mnt/down >> /var/plexguide/logs/spaceused.log
	 du -sh /mnt/complete >> /var/plexguide/logs/spaceused.log

echo "" >> /var/plexguide/logs/spaceused.log

echo " Used Traffic @ "  >> /var/plexguide/logs/spaceused.log

	 vnstat -d | tail -n 3 | head -n 1 >> /var/plexguide/logs/spaceused.log

sleep 30

done
