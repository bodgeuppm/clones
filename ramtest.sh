#!/bin//ash
###############################################################################
# Title: PlexGuide
#
# Author(s): Admin9705
# Coder : MrDoob - freelance Coder
# URL: https://plexguide.com -
# http://github.plexguide.com
# GNU: General Public License v3.0E
#
################################################################################

if [ $(dpkg-query -W -f='${Status}' lsb-release 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
echo "Installing lsb-release"
apt-get -yqq install lsb-release 2>&1 >> /dev/null
fi

fullrel=$(lsb_release -sd)
osname=$(lsb_release -si)
relno=$(lsb_release -sr | cut -d. -f1)


#check it is being run as root
if [ "$(id -u)" != "0" ]; then
  echo "Must be run from root or using sudo" && exit 1
fi

#ram test

if [ "$(free -m | grep Mem | awk 'NR=1 {print $2}')" -ge "8190" ]; then
	echo "Ram size over  Recommend System"
fi

if [ "$(free -m | grep Mem | awk 'NR=1 {print $2}')" -le "4095" ]; then 
	echo "Install abort Ram to low" && exit 1
fi

#$hdd test

 if [ "$(df -m --total --local -x tmpfs | grep 'total' | awk '{print $2}')" -ge "511900" ]; then
	echo "HDD size over Recommend System"
fi

if [ "$(df -m --total --local -x tmpfs | grep 'total' | awk '{print $2}')" -le "819200" ]; then
	echo "Install abourt ! HDD Space to low!" &&  exit 1
fi

# determine system
if ([ "$osname" = "Ubuntu" ] && [ $relno -ge 14 ]) || ([ "$osname" = "Debian" ] && [ $relno -ge 8 ]);
then
  echo $fullrel
else
 echo $fullrel
 echo "Only Ubuntu release 18.04 LTS/SERVER  and Debian 9 above  are supported"
 echo "Your system does not appear to be supported"
 echo "Check https://pgblitz.com/threads/pg-install-instructions.243/"
 exit 1

fi


 exit 0
