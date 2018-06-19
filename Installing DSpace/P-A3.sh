#!/bin/bash
########################################################################################
#Prototype A3 - Prototype A3 - Set up a WAN (wide area network) version of DSpace 6.2
#Based on DSpace 6.x Documentation
#Written by bankashi
#Version: 1.5 RC
#Note: Use dos2unix - format DOS/Windows newline (CRLF) to Unix newline (\n)
#License:   
#			This Source Code Form is subject to the terms of the Mozilla Public
#			License, v. 2.0. If a copy of the MPL was not distributed with this
#			file, You can obtain one at http://mozilla.org/MPL/2.0/.
########################################################################################
DWan(){
	echo "¡Asignando el dominio a dspace!"
	sed -i "s|dspace.hostname = localhost|dspace.hostname = $DNS_PASS|g" /dspace-source/dspace/config/dspace.cfg
	sed -i "s|dspace.baseUrl = http://localhost:8080|dspace.baseUrl = http://$DNS_PASS|g" /dspace-source/dspace/config/dspace.cfg
	cd /dspace-source
	mvn package -Dmirage2.on=true
	cd /dspace-source/dspace/target/dspace-installer/
	ant update
}
#Settings Temporals PATHs
export -f DWan
#######################################################
#Apache HTTP - How to proxy and proxy reverse 
while true
do
read -p "$(echo -e 'Introduzca solamente el dominio web. No agregar ni WWW, http:// o https://, por ejemplo(myrepo.local): \n\b')"  DwA 
read -p "$(echo -e 'Vuelva a escribir el dominio: \n\b')"  DwB
if [ "$DwA" = "$DwB" ]
then
a2enmod proxy
a2enmod proxy_ajp
a2enmod proxy_http
service apache2 restart
#############

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

####################
sed -i "s|myrepo.local|$DwA|g" /etc/apache2/sites-available/dspace.conf
a2dissite 000-default.conf
a2ensite dspace
service apache2 reload
export DNS_PASS=$DwA
break
else
echo -e "Disculpe, los dominios no son iguales\n"
fi 
done
#Add DNS into DSpace
su dspace -c "bash -c DWan"
###
echo "¡Ready!- You must wait for 3 to 5 minutes to adjust the links to the web server."
echo "¡Ready!- You can access the dspace -> http://$DNS_PASS"
echo "¡Recommendation! - Reboot the server (clear up java of redundant data)"
echo "¡IMPORTANT! - Set Up Scheduled Tasks via Cron for dspace user and root user"
####
unset DNS_PASS