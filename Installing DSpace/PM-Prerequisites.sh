#!/bin/bash
########################################################################################
#Prototype PM-Prerequisites to DSpace on Ubuntu Server 16.04
#Based on DSpace 6.x Documentation	  
#Written by bankashi
#Version: 1.5 RC
#Note: Use dos2unix - format DOS/Windows newline (CRLF) to Unix newline (\n)
#License:   
#			This Source Code Form is subject to the terms of the Mozilla Public
#			License, v. 2.0. If a copy of the MPL was not distributed with this
#			file, You can obtain one at http://mozilla.org/MPL/2.0/.
########################################################################################
apt-get install openjdk-8-jdk tomcat7 apache2 ant maven postgresql-9.5 git npm dos2unix ufw -y
#ufw default deny incoming
#ufw default allow outgoing
#ufw allow 22
ufw allow 80
ufw allow 443
ufw allow 8080
#ufw enable
echo "¡Ready!- Launch Script P-A1"