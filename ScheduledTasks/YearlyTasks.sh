#! /bin/bash
#
#
#
#Scheduled Tasks DSpaces - YEARLY TASKS
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
DT_Yearly(){
	cd /home/dspace
	/dspace/bin/dspace stats-util -s      
}
########################## Exports #########################
export -f DT_Permissions
export -f DT_Yearly
############################################################################################
	if getent passwd | grep -c '^dspace:' > /dev/null 2>&1; then
		cd /home/dspace
		DT_Permissions
		su dspace -c "bash -c DT_Yearly"
		DT_Permissions
	else
		echo "User doesn't exist...."
	fi
fi
