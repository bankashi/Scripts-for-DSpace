#!/bin/bash
########################################################################################
#Prototype A2 - Set up a local version of DSpace 6.2
#Based on DSpace 6.x Documentation
#Written by bankashi
#Version: 1.5 RC
#Note: Use dos2unix - format DOS/Windows newline (CRLF) to Unix newline (\n)
#License:   
#           This Source Code Form is subject to the terms of the Mozilla Public
#           License, v. 2.0. If a copy of the MPL was not distributed with this
#           file, You can obtain one at http://mozilla.org/MPL/2.0/.
########################################################################################
#Functions
dspace_Ab(){
	#Administrator to dspace
	echo "¡Haga una cuenta inicial de administrador para DSpace!"
	/dspace/bin/dspace create-administrator
}
#Settings Temporals PATHs
export -f dspace_Ab
#######################################################
#Exportación de las variables de Catalina en el OS
echo "Por favor espere...Configurando DSpace en Tomcat 7..."
sed -i '$a export CATALINA_BASE=/var/lib/tomcat7' /etc/profile
sed -i '$a export CATALINA_HOME=/usr/share/tomcat7' /etc/profile
source /etc/profile

#Configuración del Java heap en Tomcat 7
ram=$(awk '/^(MemTotal)/{print $2}' /proc/meminfo)
lim=12582912
if [ "$ram" -ge "$lim" ]; then
    sed -i 's|JAVA_OPTS="-Djava.awt.headless=true -Xmx128m -XX:+UseConcMarkSweepGC"|JAVA_OPTS="-Djava.awt.headless=true -Xmx2048m -Xms1024m -XX:MaxPermSize=1024m -XX:+UseConcMarkSweepGC -XX:+CMSIncrementalMode -Dfile.encoding=UTF-8"|g' /etc/default/tomcat7
else
    sed -i 's|JAVA_OPTS="-Djava.awt.headless=true -Xmx128m -XX:+UseConcMarkSweepGC"|JAVA_OPTS="-Djava.awt.headless=true -Xmx1024m -Xms512m -XX:MaxPermSize=512m -XX:+UseConcMarkSweepGC -XX:+CMSIncrementalMode -Dfile.encoding=UTF-8"|g' /etc/default/tomcat7
fi

#Exportación de las variables Java en el OS
sed -i '$a JAVA_HOME="/usr/lib/jvm/java-1.8.0-openjdk-amd64/"' /etc/environment
source /etc/environment

#Configuración de puertos en el Tomcat 7
sed -i 's|<Connector port="8080" protocol="HTTP/1.1"|<Connector port="8080"|g' /var/lib/tomcat7/conf/server.xml
sed -i 's|<Connector port="8080"|&\n\t\tmaxThreads="150"|' /var/lib/tomcat7/conf/server.xml
sed -i 's|maxThreads="150"|&\n\t\tminSpareThreads="25"|' /var/lib/tomcat7/conf/server.xml
sed -i 's|minSpareThreads="25"|&\n\t\tmaxSpareThreads="75"|' /var/lib/tomcat7/conf/server.xml
sed -i 's|maxSpareThreads="75"|&\n\t\tenableLookups="false"|' /var/lib/tomcat7/conf/server.xml
sed -i 's|enableLookups="false"|&\n\t\tacceptCount="100"|' /var/lib/tomcat7/conf/server.xml
sed -i 's|connectionTimeout="20000"|&\n\t\tdisableUploadTimeout="true"|' /var/lib/tomcat7/conf/server.xml
sed -i 's|<!-- Define an AJP 1.3 Connector on port 8009 -->|<Connector port="8009" protocol="AJP/1.3" redirectPort="8443" URIEncoding="UTF-8"/>|g' /var/lib/tomcat7/conf/server.xml
#####
service tomcat7 restart
systemctl daemon-reload

#App necessary to tomcat 7
cat > /var/lib/tomcat7/conf/Catalina/localhost/ROOT.xml << "EOF"
<?xml version='1.0'?>
<Context
    docBase="/dspace/webapps/xmlui"
    reloadable="false"
    cachingAllowed="true"/>
EOF

cat > /var/lib/tomcat7/conf/Catalina/localhost/solr.xml << "EOF"
<?xml version='1.0'?>
<Context
    docBase="/dspace/webapps/solr"
    reloadable="false"
    cachingAllowed="true"/>
EOF

cat > /var/lib/tomcat7/conf/Catalina/localhost/oai.xml << "EOF"
<?xml version='1.0'?>
<Context
    docBase="/dspace/webapps/oai"
    reloadable="false"
    cachingAllowed="true"/>
EOF

#Optionals apps
#cat > /var/lib/tomcat7/conf/Catalina/localhost/rdf.xml << "EOF"
# <?xml version='1.0'?>
# <Context
#     docBase="/dspace/webapps/rdf"
#     reloadable="false"
#     cachingAllowed="true"/>
# EOF

# cat > /var/lib/tomcat7/conf/Catalina/localhost/rest.xml << "EOF"
# <?xml version='1.0'?>
# <Context
#     docBase="/dspace/webapps/rest"
#     reloadable="false"
#     cachingAllowed="true"/>
# EOF

# cat > /var/lib/tomcat7/conf/Catalina/localhost/sword.xml << "EOF"
# <?xml version='1.0'?>
# <Context
#     docBase="/dspace/webapps/sword"
#     reloadable="false"
#     cachingAllowed="true"/>
# EOF

# cat > /var/lib/tomcat7/conf/Catalina/localhost/swordv2.xml << "EOF"
# <?xml version='1.0'?>
# <Context
#     docBase="/dspace/webapps/swordv2"
#     reloadable="false"
#     cachingAllowed="true"/>
# EOF
###
su dspace -c "bash -c dspace_Ab"
###
echo "¡Ready!- Launch Script P-A3"



 


