#! /bin/bash
#
#
#
#Scheduled Tasks DSpaces - WEEKLY TASKS
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
DT_Weekly(){
	cd /home/dspace
	/dspace/bin/dspace checker -l -p
	/dspace/bin/dspace checker-emailer      
}
########################## Exports #########################
export -f DT_Permissions
export -f DT_Weekly
############################################################################################
	if getent passwd | grep -c '^dspace:' > /dev/null 2>&1; then
		cd /home/dspace
		DT_Permissions
		su dspace -c "bash -c DT_Weekly"
		DT_Permissions
	else
		echo "User doesn't exist...."
	fi
fi
