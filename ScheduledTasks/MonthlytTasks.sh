#! /bin/bash
#           _.====.._
#         ,:._       ~-_
#             `\        ~-_
#               | _  _  |  `.
#             ,/ /_)/ | |    ~-_
#    -..__..-''  \_ \_\ `_      ~~--..__...----... BigWave ...
#
#Scheduled Tasks DSpaces - MONTHLY TASKS
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
DT_Monthly(){
	cd /home/dspace
	/dspace/bin/dspace cleanup
	/dspace/bin/dspace stat-general
	/dspace/bin/dspace stat-monthly
	/dspace/bin/dspace stat-report-general
	/dspace/bin/dspace stat-report-monthly     
}
########################## Exports #########################
export -f DT_Permissions
export -f DT_Monthly
############################################################################################
	if getent passwd | grep -c '^dspace:' > /dev/null 2>&1; then
		cd /home/dspace
		DT_Permissions
		su dspace -c "bash -c DT_Monthly"
		DT_Permissions
	else
		echo "User doesn't exist...."
	fi
fi
