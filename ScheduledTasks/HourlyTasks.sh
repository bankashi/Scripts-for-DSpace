#! /bin/bash
#
#
#Scheduled Tasks DSpaces - HOURLY TASKS
#
#Remember -> dos2unix & chmod +x script.sh commands 
#
if [ $EUID -ne 0 ]
then
echo "This script must be run as root!"  
else
########################## Modules #########################
DT_Permissions(){
	chmod -R 775 /dspace/log/ && chmod -R 775 /dspace/var/oai/      
}
DT_Hourly(){
	cd /home/dspace
	/dspace/bin/dspace generate-sitemaps   
}
########################## Exports #########################
export -f DT_Permissions
export -f DT_Hourly
############################################################################################
	if getent passwd | grep -c '^dspace:' > /dev/null 2>&1; then
		cd /home/dspace
		DT_Permissions
		su dspace -c "bash -c DT_Hourly"
		DT_Permissions
	else
		echo "User doesn't exist...."
	fi
fi
