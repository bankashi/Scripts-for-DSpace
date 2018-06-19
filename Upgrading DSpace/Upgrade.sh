#!/bin/bash
########################################################################################
#Based on DSpace 6.x Documentation
#Written by bankashi
#Version: 1.5 RC
#Note: Use dos2unix - format DOS/Windows newline (CRLF) to Unix newline (\n)
#License:   
#			This Source Code Form is subject to the terms of the Mozilla Public
#			License, v. 2.0. If a copy of the MPL was not distributed with this
#			file, You can obtain one at http://mozilla.org/MPL/2.0/.
########################################################################################
if [ $EUID -ne 0 ]
then
	echo "!Este script se debe ejecutar como root¡"  
else
	DSPACE_PATH=/
	DSPACE_URL=https://github.com/DSpace/DSpace/releases/download/dspace-6.2/dspace-6.2-src-release.tar.gz
	DSPACE_US=/home/dspace/.bashrc
	########################################################################################
	PM_Prerequisites(){
		apt-get install openjdk-8-jdk tomcat7 apache2 ant maven postgresql-9.5 git npm ufw -y
		ufw allow 80 && ufw allow 443 && ufw allow 8080  
	}
	PM_DSpace_A(){
		if [ -d "$DSPACE_PATH/dspace-source" ]
		then
			echo "The directory exist!"
			echo "Do you want to overwrite the DSpace Source?"
			read -p "Choose your option [y/n]: " OPa 
			if [ "$OPa" = "y" ] || [ "$OPa" = "Y" ]
			then
				curl -L $DSPACE_URL > dspace-source.tar.gz
				echo "Decompressing the package DSpace Source..."
				tar xf dspace-source.tar.gz --transform 's!^[^/]\+\($\|/\)!dspace-source\1!'
				echo "Overwriting the package DSpace Source..."
				rm -rf $DSPACE_PATH/dspace-source
				mv dspace-source $DSPACE_PATH
				chown -R dspace:dspace $DSPACE_PATH/dspace-source
			else
				echo "Ok..."	
			fi
		else
				curl -L $DSPACE_URL > dspace-source.tar.gz
				echo "Decompressing and transferring the package DSpace Source..."
				tar xf dspace-source.tar.gz --transform 's!^[^/]\+\($\|/\)!dspace-source\1!'
				mv dspace-source $DSPACE_PATH
				chown -R dspace:dspace $DSPACE_PATH/dspace-source
		fi	
		###
		unset OPa && unset OPb
	}
	PM_DSpace_B(){
		if [ -d "$DSPACE_PATH/dspace" ]
		then
			echo "The directory exist!"
			echo "Do you want to overwrite or restoring the DSpace with a backup?"
			read -p "Choose your option [y/n]: " OPa 
			if [ "$OPa" = "y" ] || [ "$OPa" = "Y" ]
			then
				echo "Restoring the web applications for dspace folder"
				while true
				do
					read -p "Enter your filename (Example [/home/user/dspace.tar.gz, /opt/mydspace.tar.gz or dspace.tar.gz]: " Moon	
					if [ ! -f "$Moon" ]
					then
						echo "The file doesn't exist!"
					else
						echo "Decompressing the package DSpace..."
						tar xf $Moon --transform 's!^[^/]\+\($\|/\)!dspace\1!'
						echo "Overwriting the package DSpace..."
						yes | cp -rf dspace/* $DSPACE_PATH/dspace
						rm -rf dspace
						chown -R dspace:dspace $DSPACE_PATH/dspace
						break
					fi	
				done
			else
				echo "Ok..."	
			fi
		else
			echo "Restoring the web applications for dspace folder"
			while true
			do
				read -p "Enter your filename (Example [/home/user/dspace.tar.gz, /opt/mydspace.tar.gz or dspace.tar.gz]: " Moon		
				if [ ! -f "$Moon" ]
				then
					echo "The file doesn't exist!"
				else
					echo "Decompressing and transferring the package DSpace..."
					tar xf $Moon --transform 's!^[^/]\+\($\|/\)!dspace\1!'
					mv dspace $DSPACE_PATH
					chown -R dspace:dspace $DSPACE_PATH/dspace
					break
				fi	
			done
		fi
		###
		unset OPa && unset Moon
	}
	PM_DSpace_uC(){
	  	echo "Setting the dspace.cfg..."
		####
		while true
		do
			read -p "Enter your database password used for dspace: "  Dream 
			read -p "Enter it again: "  Land
			if [ "$Dream" = "$Land" ]
			then
				sed -i "s|db.password = dspace|db.password = ${Dream}|g" $DSPACE_PATH/dspace-source/dspace/config/dspace.cfg
				break
			else
				echo -e "Passwords didn't match. \n"
			fi
		done
		unset Dream && unset Land
		####
		while true
		do
			read -p "Type in a domain name (myrepo.dev or repo.com), press Enter: "  DwA 
			read -p "Enter it again: "  DwB
			if [ "$DwA" = "$DwB" ]
			then
				echo "Setting the domain name..."
				sed -i "s|dspace.hostname = localhost|dspace.hostname = ${DwA}|g" $DSPACE_PATH/dspace-source/dspace/config/dspace.cfg
				sed -i "s|dspace.baseUrl = http://localhost:8080|dspace.baseUrl = http://${DwA}|g" $DSPACE_PATH/dspace-source/dspace/config/dspace.cfg
				unset DwA && unset DwB
				break
			else
				echo -e "Oops, try again. Did you write your domain name correctly?\n"
			fi
		done
		####
		sed -i 's|dspace.url = ${dspace.baseUrl}/${dspace.ui}|dspace.url = ${dspace.baseUrl}|g' $DSPACE_PATH/dspace-source/dspace/config/dspace.cfg
		sed -i 's|dspace.ui = xmlui|#dspace.ui = xmlui|g' $DSPACE_PATH/dspace-source/dspace/config/dspace.cfg
		sed -i 's|<theme name="Atmire Mirage Theme" regex=".*" path="Mirage/" />|<theme name="Mirage 2" regex=".*" path="Mirage2/" />|g' $DSPACE_PATH/dspace-source/dspace/config/xmlui.xconf
	}
	PM_DSpace_D(){
		cd $DSPACE_PATH/dspace-source
		mvn -U clean package -Dmirage2.on=true
		cd $DSPACE_PATH/dspace-source/dspace/target/dspace-installer
		ant update
	}
	PM_Misc_A(){
		if [ -f "$DSPACE_US" ]
		then
			if grep -xq "umask 002" $DSPACE_US ; then
			  echo "umask - Ok..."
			else
			  echo "Setting the umask..."
			  sed -i '$a # Adapting DSpace for permission bits for newly created files' $DSPACE_US
			  sed -i '$a umask 002' $DSPACE_US
			  source $DSPACE_US
			fi 
		else
			echo "changing umask..."
			umask 002
		fi
	}
	PM_Misc_uB(){
		chmod -R 775 $DSPACE_PATH/dspace
		chmod -R 775 $DSPACE_PATH/dspace/var/oai/
	 	chmod -R 775 $DSPACE_PATH/dspace/log/
	}
	########################################################################################
	export -f PM_Prerequisites
	export -f PM_DSpace_A
	export -f PM_DSpace_B
	export -f PM_DSpace_uC
	export -f PM_DSpace_D
	export -f PM_Misc_A
	export -f PM_Misc_uB
	########################################################################################
	RULE=$(whiptail --title "DSpace Upgrade Automatic Task" --menu "Make your option" 16 140 9 \
		"1)" "Upgrading My DSpace"  \
		"2)" "README"  \
		"0)" "Exit"  3>&2 2>&1 1>&3	
	)
	exitstatus=$?
	[[ "$exitstatus" = 1 ]];
	case $RULE in
		"1)")
			whiptail --scrolltext --title "Important Note" --msgbox "We cannot accept responsibility for any data loss or corruption before proceeding, do extensive testing on spare infrastructure. \nYou proceed at your own risk. \n \n Choose Ok to continue." 16 80 9
			whiptail --scrolltext --title "Prerequisite Software" --msgbox "DSpace 6.x requires the following versions of prerequisite software: \n -Java 7 or 8 (Oracle or OpenJDK) \n -Apache Maven 3.0.5 or above \n -Apache Ant 1.8 or above \n -PostgreSQL 9.4 or above (with pgcrypto installed) \n -Tomcat 7 or above \n -node 6 or above \n -npm 3.10.8 or above \n \n Please note that the configuration and installation guidelines relating to a particular tool below are here for convenience. You should refer to the documentation for each individual component for complete and up-to-date details or contact your system administrator for more info. \n Also, Many of the tools are updated on a frequent basis, and the guidelines below may become out of date. \n \n Choose Ok to continue." 16 80 9   
			whiptail --scrolltext --title "Backup your DSpace" --msgbox "Make a complete backup of your system, including: \n -Database: Make a sdump of the database. For example: \n[ pg_dump -U dspace -f bk_dspace.dump dspace -Fc ] \n -DSpace: Backup the entire directory content of dspace. For example \n[ tar -czvf dspace.tar.gz /dspace ] \n -Customizations: If you have custom code, such as themes, modifications, or custom scripts, you will want to back them up to a safe location. \n \n It is strongly recommended that you create a backup of your DSpace instance. Also, backups are easy to recover from; a botched install/upgrade is very difficult if not impossible to recover from. \n \n Choose Ok to continue." 16 80 9
			echo "Do you want to continue this operation?"
			read -p "Choose your option [y/n]: " VOpts 
			if [ "$VOpts" = "y" ] || [ "$VOpts" = "Y" ]
			then
				if getent passwd | grep -c '^dspace:' > /dev/null 2>&1; then
					#PM_Prerequisites
					PM_DSpace_A && PM_DSpace_B
					service tomcat7 stop && PM_DSpace_uC
		  			su dspace -c "bash -c PM_DSpace_D"
					su dspace -c "bash -c PM_Misc_A"
					service tomcat7 start && PM_Misc_uB
					whiptail --scrolltext --title "Important Note" --msgbox "Update the OAI-PMH index with the newest content and re-optimize that index. For example: \n [ /dspace/bin/dspace oai import -c ] \n \n Choose Ok to continue." 16 80 9
				else
					echo "Creating the user...."
	    			useradd -m dspace
	    			#PM_Prerequisites
					PM_DSpace_A && PM_DSpace_B
					service tomcat7 stop && PM_DSpace_uC
		  			su dspace -c "bash -c PM_DSpace_D"
					su dspace -c "bash -c PM_Misc_A"
					service tomcat7 start && PM_Misc_uB
					whiptail --scrolltext --title "Important Note" --msgbox "Update the OAI-PMH index with the newest content and re-optimize that index. For example: \n [ /dspace/bin/dspace oai import -c ] \n \n Choose Ok to continue." 16 80 9
				fi
			else
			if [ "$VOpts" = "n" ] || [ "$VOpts" = "N" ]
			then
				echo "Cancelling...."
			else
				echo "Wrong option!"
			fi	
			fi
		;;
		####
		"2)")       
			whiptail --scrolltext --title "Important Note" --msgbox "We cannot accept responsibility for any data loss or corruption before proceeding, do extensive testing on spare infrastructure. \nYou proceed at your own risk. \n \n Choose Ok to continue." 16 80 9
			whiptail --scrolltext --title "License" --msgbox "This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. \nIf a copy of the MPL was not distributed with this file, You can obtain one at http://mozilla.org/MPL/2.0/. \n \n Choose Ok to continue." 16 80 9
	    ;;	
	    ####
		"0)")       
			echo "Bye."
	    ;;
	esac
fi