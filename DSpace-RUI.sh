#! /bin/bash
########################################################################################
#Based on DSpace 6.x Documentation
#Written by bankashi - Team Ridda2
#Version: 2.0 RC
#Note: Use dos2unix - format DOS/Windows newline (CRLF) to Unix newline (\n)
#License:   
#			This Source Code Form is subject to the terms of the Mozilla Public
#			License, v. 2.0. If a copy of the MPL was not distributed with this
#			file, You can obtain one at http://mozilla.org/MPL/2.0/.
########################################################################################
if [ $EUID -ne 0 ]
then
echo "This script must be run as root!"  
else
while true
do
	if [ -z "$DSHOST" ]
	then
		export DSHOST=/opt/dspacehost
	else
		if [ ! -d "$DSHOST" ]
		then
			mkdir -pv $DSHOST
		else
			while true
			do
				if [ -z "$DSCONF" ]
				then
					export DSCONF=/opt/dspacehost/shost.conf
				else
					if [ ! -f "$DSCONF" ]
					then
						echo "The shost.conf doesn't exist!"
						echo "Creating the file..."
###################################################
cat > $DSCONF << "EOF"
# Automatically generated file; DO NOT EDIT / DO NOT DELETE.
DSPACE_PATH=/
DSPACE_URL=https://github.com/DSpace/DSpace/releases/download/dspace-6.3/dspace-6.3-src-release.tar.gz
PSQL_SOU=/etc/postgresql/9.5/main
DSPACE_US=/home/dspace/.bashrc
JAVA_TCNANA=/etc/default/tomcat7
TCNANA_CON=/var/lib/tomcat7/conf/server.xml
TCATA=/var/lib/tomcat7/conf/Catalina/localhost
REPO_MURL=localhost
EOF
###################################################
						##
						echo "Do you want to change the default PATH [/] of the installation of the dspace?"
						read -p "Choose your option [y/n]: " VOpts 
						if [ "$VOpts" = "y" ] || [ "$VOpts" = "Y" ]
						then
							echo "Setting the file system (dspace) on the Ubuntu"
							while true
							do
								read -p "$(echo -e 'Enter your path (Example [/usr/bin or /opt]: \n\b')" Sun
								export Shine=$Sun
								if [ -d "$Shine" ]
								then
									if [ "$Shine" = "/" ]; then
										echo "the default route is a setting on /"
									else
										sed -i "s|DSPACE_PATH=/|DSPACE_PATH=$Shine|g" $DSCONF
									fi
									break
								else
									echo -e "Oops, try again. Did you write your path correctly?\n"
								fi
							done
						else
						if [ "$VOpts" = "n" ] || [ "$VOpts" = "N" ]
						then
							echo "the default route is a setting on /"
						else
							echo "Wrong option!"
						fi	
						fi
					else
						echo "Ok..."
						break
					fi	
				fi
			done
			###
			break
		fi	
	fi
done
########################## Module A ##########################
PM_Prerequisites(){
	apt-get install openjdk-8-jdk tomcat7 apache2 ant maven postgresql-9.5 git npm ufw -y
	ufw default deny incoming
	ufw default allow outgoing
	ufw allow 22
	ufw allow 80
	ufw allow 443
	ufw allow 8080
	ufw enable      
}
PM_DSpace_A(){
	source $DSCONF
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
	echo "Do you want to merge any other customizations (if needed or desired)?"
	read -p "Choose your option [y/n]: " OPb 
	if [ "$OPb" = "y" ] || [ "$OPb" = "Y" ]
	then
		echo "Important. Use the command [ exit ], only once to exit this instance!"
		su root
		echo "Ready..."
	else
		echo "Ok..."	
	fi
	###
	unset OPa && unset OPb
}
PM_DSpace_A_Inst(){
	source $DSCONF
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
}
PM_DSpace_B(){
	source $DSCONF
	if [ -d "$DSPACE_PATH/dspace" ]
	then
		echo "The directory exist!"
		echo "Do you want to overwrite the DSpace?"
		read -p "Choose your option [y/n]: " OPa 
		if [ "$OPa" = "y" ] || [ "$OPa" = "Y" ]
		then
			echo "Restoring the web applications for dspace folder"
			while true
			do
				read -p "$(echo -e 'Enter your filename (Example [/home/user/dspace.tar.gz, /opt/mydspace.tar.gz or dspace.tar.gz]: \n\b')" Moon	
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
			read -p "$(echo -e 'Enter your filename (Example [/home/user/dspace.tar.gz, /opt/mydspace.tar.gz or dspace.tar.gz]: \n\b')" Moon	
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
PM_DSpace_B_Inst(){
	source $DSCONF
	if [ -d "$DSPACE_PATH/dspace" ]
	then
		echo "The directory exist!"
	else
		echo "Creating package DSpace..."
		mkdir $DSPACE_PATH/dspace
		chown -R dspace:dspace $DSPACE_PATH/dspace
	fi
}
PM_DSpace_C(){
	source $DSCONF
	if grep -xq "# Design Your Own DSpace Settings" $DSPACE_PATH/dspace-source/dspace/config/dspace.cfg ; then
		echo "dspace.cfg - Ok..."
	else
	  	echo "Setting the dspace.cfg..."
	  	####
	  	if [ "$DSPACE_PATH" = "/" ]; then
			echo "the default route is a setting on /dspace"
		else
			sed -i "s|dspace.dir = /dspace|dspace.dir = ${DSPACE_PATH}/dspace|g" $DSPACE_PATH/dspace-source/dspace/config/dspace.cfg
		fi
		####
		while true
		do
			read -p "$(echo -e 'Type in a domain name (myrepo.dev or repo.com), press Enter: \n\b')"  DwA 
			read -p "$(echo -e 'Enter it again:: \n\b')"  DwB
			if [ "$DwA" = "$DwB" ]
			then
				echo "Setting the domain name..."
				sed -i "s|REPO_MURL=localhost|REPO_MURL=${DwA}|g" $DSCONF
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
		sed -i '$a # Design Your Own DSpace Settings' $DSPACE_PATH/dspace-source/dspace/config/dspace.cfg
	fi 
	###
	sed -i 's|<theme name="Atmire Mirage Theme" regex=".*" path="Mirage/" />|<theme name="Mirage 2" regex=".*" path="Mirage2/" />|g' $DSPACE_PATH/dspace-source/dspace/config/xmlui.xconf
}
PM_DSpace_uC(){
	source $DSCONF
	if grep -xq "# Design Your Own DSpace Settings" $DSPACE_PATH/dspace-source/dspace/config/dspace.cfg ; then
		echo "dspace.cfg - Ok..."
	else
	  	echo "Setting the dspace.cfg..."
	  	####
	  	if [ "$DSPACE_PATH" = "/" ]; then
			echo "the default route is a setting on /dspace"
		else
			sed -i "s|dspace.dir = /dspace|dspace.dir = ${DSPACE_PATH}/dspace|g" $DSPACE_PATH/dspace-source/dspace/config/dspace.cfg
		fi
		####
		while true
		do
			read -p "$(echo -e 'Enter your database password used for dspace: \n\b')"  Dream 
			read -p "$(echo -e 'Enter it again: \n\b')"  Land
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
			read -p "$(echo -e 'Type in a domain name (myrepo.dev or repo.com), press Enter: \n\b')"  DwA 
			read -p "$(echo -e 'Enter it again:: \n\b')"  DwB
			if [ "$DwA" = "$DwB" ]
			then
				echo "Setting the domain name..."
				sed -i "s|REPO_MURL=localhost|REPO_MURL=${DwA}|g" $DSCONF
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
		sed -i '$a # Design Your Own DSpace Settings' $DSPACE_PATH/dspace-source/dspace/config/dspace.cfg
	fi 
	###
	sed -i 's|<theme name="Atmire Mirage Theme" regex=".*" path="Mirage/" />|<theme name="Mirage 2" regex=".*" path="Mirage2/" />|g' $DSPACE_PATH/dspace-source/dspace/config/xmlui.xconf
}
PM_DSpace_D(){
	source $DSCONF
	###
	cd $DSPACE_PATH/dspace-source
	mvn -U clean package -Dmirage2.on=true
	cd $DSPACE_PATH/dspace-source/dspace/target/dspace-installer
	ant update
}
PM_DSpace_D_Inst(){
	source $DSCONF
	###
	cd $DSPACE_PATH/dspace-source
	mvn package -Dmirage2.on=true
	cd $DSPACE_PATH/dspace-source/dspace/target/dspace-installer
	ant fresh_install
}
PM_Postgres_A(){
	if psql  -lqtA | cut -d\| -f1 | grep -qFx "dspace"; then
		echo "The database already exists"
	else
		createuser --username=postgres --no-superuser dspace
		createdb --username=postgres --owner=dspace --encoding=UNICODE dspace
		psql --username=postgres dspace -c "CREATE EXTENSION pgcrypto;"
	fi 
}
PM_Postgres_B(){
	source $DSCONF
	while true
	do
	read -p "$(echo -e 'Enter password for new role: \n\b')"  Dream 
	read -p "$(echo -e 'Enter it again: \n\b')"  Land
	if [ "$Dream" = "$Land" ]
	then
		sudo -u postgres psql -c "ALTER USER dspace WITH PASSWORD '${Dream}';"
		sed -i "s|db.password = dspace|db.password = ${Dream}|g" $DSPACE_PATH/dspace-source/dspace/config/dspace.cfg
		break
	else
		echo -e "Passwords didn't match. \n"
	fi
	done
	###
	unset Dream && unset Land
}
PM_Postgres_C(){
	source $DSCONF
	if [ -d "$PSQL_SOU" ]
	then
		if grep -xq "host dspace dspace 127.0.0.1 255.255.255.255 md5" $PSQL_SOU/pg_hba.conf ; then
		  echo "pg_hba.conf - Ok..."
		else
		  echo "Setting the pg_hba.conf..."
		  sed -i '$a host dspace dspace 127.0.0.1 255.255.255.255 md5' $PSQL_SOU/pg_hba.conf
		  /etc/init.d/postgresql restart
		fi 
		###
		if grep -xq "# Adapting DSpace for postgresql" $PSQL_SOU/postgresql.conf ; then
		  echo "postgresql.conf - Ok..."
		else
		  echo "Setting the postgresql.conf..."
		  sed -i "s|#listen_addresses = 'localhost'|listen_addresses = 'localhost'|g" $PSQL_SOU/postgresql.conf
		  sed -i '$a # Adapting DSpace for postgresql' $PSQL_SOU/postgresql.conf
		  /etc/init.d/postgresql restart
		fi 	
	else
		echo "You need to install postgresql 9.5"
	fi
}
PM_RestoreDB(){
	echo "Do you want to restore the database for dspace?"
	read -p "Choose your option [y/n]: " OPc 
	if [ "$OPc" = "y" ] || [ "$OPc" = "Y" ]
	then
		echo "Important. Use the command [ exit ], only once to exit this instance!"
		echo "Use the command [ pg_restore -d dspace -U dspace -C filename.dump ] to restoring the db"
		su dspace
		echo "Ready..."
	else
		echo "Ok..."	
	fi
	###
	unset OPc
}
PM_BackUp(){
	cd
	pg_dump -U dspace -f bk_dspace_$(date +"%Y-%m-%d").dump dspace -Fc
	tar -czvf dspace_$(date +"%Y-%m-%d").tar.gz $DSPACE_PATH/dspace
}
PM_Misc_A(){
	source $DSCONF
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
PM_Misc_B(){
	source $DSCONF
	if id -nG "tomcat7" | grep -qw "dspace"; then
	    echo "tomcat user - Ok..."
	else
		echo "Setting the tomcat user..."
	    usermod -a -G dspace tomcat7
	fi
	###
	chmod -R 775 $DSPACE_PATH/dspace
	chmod -R 775 $DSPACE_PATH/dspace/var/oai/
 	chmod -R 775 $DSPACE_PATH/dspace/log/
}
PM_Misc_uB(){
	source $DSCONF
	chmod -R 775 $DSPACE_PATH/dspace
	chmod -R 775 $DSPACE_PATH/dspace/var/oai/
 	chmod -R 775 $DSPACE_PATH/dspace/log/
}
########################## Module B ##########################
PM_Tomcat(){
	source $DSCONF
	echo "One moment, please... Configuring Tomcat Settings"
	if [ -f "/etc/profile" ]
	then
		if grep -xq "export CATALINA_BASE=/var/lib/tomcat7" /etc/profile ; then
			echo "CATALINA_BASE - Ok..."
		else
			echo "Setting CATALINA_BASE"
		  	sed -i '$a export CATALINA_BASE=/var/lib/tomcat7' /etc/profile
		  	source /etc/profile
		fi 
		###
		if grep -xq "export CATALINA_HOME=/usr/share/tomcat7" /etc/profile ; then
		  	echo "CATALINA_HOME - Ok..."
		else
		  	echo "Setting CATALINA_HOME"
		  	sed -i '$a export CATALINA_HOME=/usr/share/tomcat7' /etc/profile
		  	source /etc/profile
		fi
		###
		if grep -xq 'JAVA_HOME="/usr/lib/jvm/java-1.8.0-openjdk-amd64/"' /etc/environment ; then
		  	echo "JAVA_HOME - Ok..."
		else
		  	echo "Setting JAVA_HOME"
			sed -i '$a JAVA_HOME="/usr/lib/jvm/java-1.8.0-openjdk-amd64/"' /etc/environment
			source /etc/environment
		fi
	else
		echo "Profile doesn't exist!"
	fi
	####Java Memory Settings####
	ram=$(awk '/^(MemTotal)/{print $2}' /proc/meminfo)
	lim=12582912
	if [ "$ram" -ge "$lim" ]; then
		sed -i 's|JAVA_OPTS="-Djava.awt.headless=true -Xmx128m -XX:+UseConcMarkSweepGC"|JAVA_OPTS="-Djava.awt.headless=true -Xmx2048m -Xms1024m -XX:MaxPermSize=1024m -XX:+UseConcMarkSweepGC -XX:+CMSIncrementalMode -Dfile.encoding=UTF-8"|g' $JAVA_TCNANA
	else
		sed -i 's|JAVA_OPTS="-Djava.awt.headless=true -Xmx128m -XX:+UseConcMarkSweepGC"|JAVA_OPTS="-Djava.awt.headless=true -Xmx1024m -Xms512m -XX:MaxPermSize=512m -XX:+UseConcMarkSweepGC -XX:+CMSIncrementalMode -Dfile.encoding=UTF-8"|g' $JAVA_TCNANA
	fi
	###Tomcat protocols###
	if [ -f "$TCNANA_CON" ]
	then
		if grep -xq "<!--Adapting DSpace for tomcat-->" $TCNANA_CON ; then
			echo "Tomcat Settings - Ok..."
		else
			echo "Setting Tomcat"
		  	sed -i 's|<Connector port="8080" protocol="HTTP/1.1"|<Connector port="8080"|g' $TCNANA_CON
			sed -i 's|<Connector port="8080"|&\n\t\tmaxThreads="150"|' $TCNANA_CON
			sed -i 's|maxThreads="150"|&\n\t\tminSpareThreads="25"|' $TCNANA_CON
			sed -i 's|minSpareThreads="25"|&\n\t\tmaxSpareThreads="75"|' $TCNANA_CON
			sed -i 's|maxSpareThreads="75"|&\n\t\tenableLookups="false"|' $TCNANA_CON
			sed -i 's|enableLookups="false"|&\n\t\tacceptCount="100"|' $TCNANA_CON
			sed -i 's|connectionTimeout="20000"|&\n\t\tdisableUploadTimeout="true"|' $TCNANA_CON
			sed -i 's|<!-- Define an AJP 1.3 Connector on port 8009 -->|<Connector port="8009" protocol="AJP/1.3" redirectPort="8443" URIEncoding="UTF-8"/>|g' $TCNANA_CON
			sed -i '$a <!--Adapting DSpace for tomcat-->' $TCNANA_CON
			###
			service tomcat7 restart
			systemctl daemon-reload
		fi
	else
		echo "server.xml doesn't exist!"
	fi
	##### Web Apps#####
	if [ -d "$TCATA" ]
	then
		if [ -f "$TCATA/ROOT.xml" ]
		then
			echo "ROOT.xml - Ok..."
		else
			echo "Creating ROOT.xml..."
############
cat > $TCATA/ROOT.xml << "EOF"
<?xml version='1.0'?>
<Context
    docBase="/dspace/webapps/xmlui"
    reloadable="false"
    cachingAllowed="true"/>
EOF
############
			sed -i "s|/dspace/webapps/xmlui|${DSPACE_PATH}/dspace/webapps/xmlui|g" $TCATA/ROOT.xml
		fi
		####
		if [ -f "$TCATA/solr.xml" ]
		then
			echo "solr.xml - Ok..."
		else
			echo "Creating solr.xml..."
############
cat > $TCATA/solr.xml << "EOF"
<?xml version='1.0'?>
<Context
    docBase="/dspace/webapps/solr"
    reloadable="false"
    cachingAllowed="true"/>
EOF
############
			sed -i "s|/dspace/webapps/solr|${DSPACE_PATH}/dspace/webapps/solr|g" $TCATA/solr.xml
		fi
		####
		if [ -f "$TCATA/oai.xml" ]
		then
			echo "oai.xml - Ok..."
		else
			echo "Creating oai.xml..."
############
cat > $TCATA/oai.xml << "EOF"
<?xml version='1.0'?>
<Context
    docBase="/dspace/webapps/oai"
    reloadable="false"
    cachingAllowed="true"/>
EOF
############
			sed -i "s|/dspace/webapps/oai|${DSPACE_PATH}/dspace/webapps/oai|g" $TCATA/oai.xml
		fi
		####
	else
		echo "Catalina doesn't exist!"
	fi
}
PM_Apache(){
	source $DSCONF
	if [ -d "/etc/apache2/sites-available" ]
	then
		if [ -f "/etc/apache2/sites-available/dspace.conf" ]
		then
			echo "dspace.conf - Ok..."
		else
			echo "Creating dspace.conf..."
			a2enmod proxy && a2enmod proxy_ajp && a2enmod proxy_http
			service apache2 restart
############
cat > /etc/apache2/sites-available/dspace.conf << "EOF"
<VirtualHost *:80>
ServerName myrepo.local
ServerAlias *.myrepo.local
AddDefaultCharset UTF-8

ProxyRequests off
ProxyPreserveHost On

ProxyPass /       ajp://localhost:8009/
ProxyPassReverse / ajp://localhost:8009/

LogLevel warn

ErrorLog ${APACHE_LOG_DIR}/dspace_error.log
CustomLog ${APACHE_LOG_DIR}/dspace_access.log combined

</VirtualHost>
EOF
############
			sed -i "s|myrepo.local|${REPO_MURL}|g" /etc/apache2/sites-available/dspace.conf
			a2dissite 000-default.conf && a2ensite dspace.conf && service apache2 reload
		fi
	else
		echo "Apache doesn't exist!"
	fi
	####
	clear
	echo "Ready! - You must wait for 3 to 5 minutes to adjust the links to the web server."
	echo "IMPORTANT! - Set Up Scheduled Tasks via Cron for dspace user and root user."
	echo "Recommendation #1! - Reboot the server (clear up java of redundant data)"
}
########################## Exports #########################
#A
export -f PM_Prerequisites
export -f PM_DSpace_A
export -f PM_DSpace_A_Inst
export -f PM_DSpace_B
export -f PM_DSpace_B_Inst
export -f PM_DSpace_C
export -f PM_DSpace_uC
export -f PM_DSpace_D
export -f PM_DSpace_D_Inst
export -f PM_Postgres_A
export -f PM_Postgres_B
export -f PM_Postgres_C
export -f PM_BackUp
export -f PM_RestoreDB
export -f PM_Misc_A
export -f PM_Misc_B
export -f PM_Misc_uB
#B
export -f PM_Tomcat
export -f PM_Apache
############################################################################################
RULE=$(whiptail --title "DSpace Replication, Upgrade & Install Automatic Tasks Suite" --menu "Make your option" 16 140 9 \
	"1)" "Replicating / Migrating to a new server [Only Ubuntu Servers 16.04+]."   \
	"2)" "Upgrading DSpace [Only Ubuntu Servers 16.04+]."  \
	"3)" "Installing DSpace [Is under active development]."  \
	"0)" "Exit"  3>&2 2>&1 1>&3	
)
######
exitstatus=$?
[[ "$exitstatus" = 1 ]];
#####
case $RULE in
	"1)")
		whiptail --scrolltext --title "Important Note" --msgbox "We cannot accept responsibility for any data loss or corruption before proceeding, do extensive testing on spare infrastructure. \nYou proceed at your own risk. \n \n Choose Ok to continue." 16 80 9
		echo "Do you want to continue this operation?"
		read -p "Choose your option [y/n]: " VOpts 
		if [ "$VOpts" = "y" ] || [ "$VOpts" = "Y" ]
		then
			PM_Prerequisites
			###
			if getent passwd | grep -c '^dspace:' > /dev/null 2>&1; then
    			#Module A
    			PM_DSpace_A
    			su postgres -c "bash -c PM_Postgres_A"
    			PM_RestoreDB && PM_DSpace_B && PM_Postgres_B && PM_Postgres_C
    			service tomcat7 stop && PM_DSpace_C
    			su dspace -c "bash -c PM_DSpace_D"
    			su dspace -c "bash -c PM_Misc_A"
    			service tomcat7 start && PM_Misc_B
    			#Module B
    			PM_Tomcat && PM_Apache
			else
				echo "Creating the user...."
    			useradd -m dspace
    			#Module A
    			PM_DSpace_A
    			su postgres -c "bash -c PM_Postgres_A"
    			PM_RestoreDB && PM_DSpace_B && PM_Postgres_B && PM_Postgres_C
    			service tomcat7 stop && PM_DSpace_C
    			su dspace -c "bash -c PM_DSpace_D"
    			su dspace -c "bash -c PM_Misc_A"
    			service tomcat7 start && PM_Misc_B
    			#Module B
    			PM_Tomcat && PM_Apache
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
		whiptail --scrolltext --title "Prerequisite Software" --msgbox "DSpace 6.x requires the following versions of prerequisite software: \n -Java 7 or 8 (Oracle or OpenJDK) \n -Apache Maven 3.0.5 or above \n -Apache Ant 1.8 or above \n -PostgreSQL 9.4 or above (with pgcrypto installed) \n -Tomcat 7 or above \n -node 6 or above \n -npm 3.10.8 or above \n \n Please note that the configuration and installation guidelines relating to a particular tool below are here for convenience. You should refer to the documentation for each individual component for complete and up-to-date details or contact your system administrator for more info. \n Also, Many of the tools are updated on a frequent basis, and the guidelines below may become out of date. \n \n Choose Ok to continue." 16 80 9   
		whiptail --scrolltext --title "Backup your DSpace" --msgbox "Make a complete backup of your system, including: \n -Database: Make a sdump of the database. For example: \n[ pg_dump -U dspace -f bk_dspace.dump dspace -Fc ] \n -DSpace: Backup the entire directory content of dspace. For example \n[ tar -czvf dspace.tar.gz /dspace ] \n -Customizations: If you have custom code, such as themes, modifications, or custom scripts, you will want to back them up to a safe location. \n \n It is strongly recommended that you create a backup of your DSpace instance. Also, backups are easy to recover from; a botched install/upgrade is very difficult if not impossible to recover from. \n \n Choose Ok to continue." 16 80 9
		###
		echo "Do you want to continue this operation?"
		read -p "Choose your option [y/n]: " VOpts 
		if [ "$VOpts" = "y" ] || [ "$VOpts" = "Y" ]
		then
			if getent passwd | grep -c '^dspace:' > /dev/null 2>&1; then
				PM_DSpace_A && PM_DSpace_B
				service tomcat7 stop && PM_DSpace_uC
	  			su dspace -c "bash -c PM_DSpace_D"
				su dspace -c "bash -c PM_Misc_A"
				service tomcat7 start && PM_Misc_uB
				whiptail --scrolltext --title "Important Note" --msgbox "Update the OAI-PMH index with the newest content and re-optimize that index. For example: \n [ /dspace/bin/dspace oai import -c ] \n \n Choose Ok to continue." 16 80 9
			else
				echo "Creating the user...."
    			useradd -m dspace
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
	"3)")       
		whiptail --scrolltext --title "Important Note" --msgbox "We cannot accept responsibility for any data loss or corruption before proceeding, do extensive testing on spare infrastructure. \nYou proceed at your own risk. \n \n Choose Ok to continue." 16 80 9
		echo "Do you want to continue this operation?"
		read -p "Choose your option [y/n]: " VOpts 
		if [ "$VOpts" = "y" ] || [ "$VOpts" = "Y" ]
		then
			if getent passwd | grep -c '^dspace:' > /dev/null 2>&1; then
				PM_Prerequisites
				#Module A
				PM_DSpace_A_Inst
				su postgres -c "bash -c PM_Postgres_A"
				PM_DSpace_B_Inst && PM_Postgres_B && PM_Postgres_C && PM_DSpace_C
				su dspace -c "bash -c PM_DSpace_D_Inst"
				su dspace -c "bash -c PM_Misc_A"
				PM_Misc_B
				#Module B
				PM_Tomcat && PM_Apache
				PM_Misc_uB
			else
				PM_Prerequisites
				echo "Creating the user...."
				useradd -m dspace
				#Module A
				PM_DSpace_A_Inst
				su postgres -c "bash -c PM_Postgres_A"
				PM_DSpace_B_Inst && PM_Postgres_B && PM_Postgres_C && PM_DSpace_C
				su dspace -c "bash -c PM_DSpace_D_Inst"
				su dspace -c "bash -c PM_Misc_A"
				PM_Misc_B
				#Module B
				PM_Tomcat && PM_Apache
				PM_Misc_uB
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
	"0)")       
		echo "bye"
    ;;
esac
fi