#!/bin/bash
########################################################################################
#Prototype A1 - Compiling and installing DSpace 6.2 on Ubuntu Server 16.10
#Based on DSpace 6.x Documentation
#Written by bankashi
#Version: 1.5 RC
#Note: Use dos2unix - format DOS/Windows newline (CRLF) to Unix newline (\n)
#License:   
#			This Source Code Form is subject to the terms of the Mozilla Public
#			License, v. 2.0. If a copy of the MPL was not distributed with this
#			file, You can obtain one at http://mozilla.org/MPL/2.0/.
########################################################################################
#Global Variables
DSPACE_URL="https://github.com/DSpace/DSpace/releases/download/dspace-6.2/dspace-6.2-src-release.tar.gz"
DSPACE_TAR="dspace-6.2-src-release.tar.gz"
DSPACE_BUILD="dspace-6.2-src-release"
DSPACE_US=/home/dspace/.bashrc
#Functions
postgres_A(){
	echo "Tener en cuenta que la misma password agregado aquí, debe ser igual agregado en el fichero dspace.cfg"
	createuser --username=postgres --no-superuser --pwprompt dspace
	createdb --username=postgres --owner=dspace --encoding=UNICODE dspace
	psql --username=postgres dspace -c "CREATE EXTENSION pgcrypto;"      
} 
dspace_A(){
	while true
	do
		read -s -p "$(echo -e 'Introduzca la misma contraseña del usuario para la database dpsace: \n\b')"  PwdA 
	    read -s -p "$(echo -e 'Vuelva a escribir la contraseña: \n\b')"  PwdB 
		if [ "$PwdA" = "$PwdB" ]
	    then
	    	sed -i "s|db.password = dspace|db.password = $PwdA|g" /dspace-source/dspace/config/dspace.cfg
	    	sed -i 's|dspace.url = ${dspace.baseUrl}/${dspace.ui}|dspace.url = ${dspace.baseUrl}|g' /dspace-source/dspace/config/dspace.cfg
	    	sed -i 's|dspace.ui = xmlui|#dspace.ui = xmlui|g' /dspace-source/dspace/config/dspace.cfg
	    	sed -i 's|<theme name="Atmire Mirage Theme" regex=".*" path="Mirage/" />|<theme name="Mirage 2" regex=".*" path="Mirage2/" />|g' /dspace-source/dspace/config/xmlui.xconf
	    	cd /dspace-source
			mvn package -Dmirage2.on=true
			cd /dspace-source/dspace/target/dspace-installer/
			ant fresh_install
	        break
		else
			echo -e "Disculpe, las contraseñas no son iguales\n"
			
		fi 
	done
}
misc_A(){
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
misc_B(){
	if id -nG "tomcat7" | grep -qw "dspace"; then
	    echo "tomcat user - Ok..."
	else
		echo "Setting the tomcat user..."
	    usermod -a -G dspace tomcat7
	fi
	###
	chmod -R 775 /dspace
	chmod -R 775 /dspace/var/oai/
 	chmod -R 775 /dspace/log/
}
#Export Functions
export -f postgres_A
export -f dspace_A
export -f misc_A
export -f misc_B
#######################################################
useradd -m dspace
wget -c -t 5 -T 10 "${DSPACE_URL}"
echo "Descomprimiendo y transfiriendo el paquete DSpace..."
tar xf "${DSPACE_TAR}"
mv "${DSPACE_BUILD}" /dspace-source/
chown dspace:dspace /dspace-source/ -R
###
su postgres -c "bash -c postgres_A"
###
mkdir /dspace
chown dspace:dspace /dspace/ -R
sed -i '$a host dspace dspace 127.0.0.1 255.255.255.255 md5' /etc/postgresql/9.5/main/pg_hba.conf
sed -i "s|#listen_addresses = 'localhost'|listen_addresses = 'localhost'|g" /etc/postgresql/9.5/main/postgresql.conf
/etc/init.d/postgresql restart
###
su dspace -c "bash -c dspace_A"
###
su dspace -c "bash -c misc_A"
###
misc_B
###
echo "¡Ready!- Launch Script P-A2"





