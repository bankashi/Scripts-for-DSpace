# DSpace Replication, Upgrade & Install Automatic Tasks Suite
This project represents a collection of files and scripts be code files (having a .sh extension). For example, crontab scripts, Dublin Core Application Profile Guidelines or customize XML files. 
This will help you how to create a repository [DSpace](https://github.com/DSpace/DSpace) and how to replicate or upgrade core dspace, aspects and themes for Manakin (dspace-xmlui), and other webservice/applications without complicated Technical documentation.

Our goal is to help your IT department or future DSpace members to maintain and develop their repositories. As many institutions have limited support, DSpace members should have best practice strategies to support the institutional missions.

# Prerequisite
- Ubuntu Server 16.04.x LTS (Tested and Supported Software).
- Root user or Super User (ability to read, modify and execute specific files and directories).
- dos2unix (DOS-based text files use a pair of carriage return "CR" and line feed "LF" as a new-line delimiter).
- Don't install unnecessary packages.

# How do I get set up?
First, use **dos2unix** in the script
```sh
$ dos2unix DSpace-RUI.sh
```
now, run the script. This script has three options (1. Replication, 2. Upgrade & 3. Install), please select the option of your preference and follow the instructions of the script
```sh
$ . ./DSpace-RUI.sh
```

# Documentation
This script is based on the [DSpace 6.x Documentation](https://wiki.duraspace.org/display/DSDOC6x/DSpace+6.x+Documentation)

# General Information
- Written: bankashi
- Version: 2.0 RC

# Miscellaneous
**Note:** For example, the installation path is /opt

## Scheduled Tasks via Cron (crontab)
>[While every DSpace installation is unique, in order to get the most out of DSpace, we highly recommend enabling these basic cron settings](https://wiki.duraspace.org/display/DSDOC6x/Scheduled+Tasks+via+Cron)
### Root user
```sh
1 0 * * * chmod -R 775 /opt/dspace/log/ > /dev/null
2 0 * * * chmod -R 775 /opt/dspace/var/oai/ > /dev/null
0 3 * * * chmod -R 775 /opt/dspace/var/oai/ > /dev/null
```
### Dspace user
```sh
3 0 * * * /opt/dspace/bin/dspace oai import -c > /dev/null
10 0 * * * /opt/dspace/bin/dspace index-discovery > /dev/null
0 3 * * * /opt/dspace/bin/dspace filter-media > /dev/null
0 4 * * * /opt/dspace/bin/dspace curate -q admin_ui > /dev/null
0 0,8,16 * * * /opt/dspace/bin/dspace generate-sitemaps > /dev/null
0 6 * * * /opt/dspace/bin/dspace sub-daily > /dev/null
0 3 * * 0 /opt/dspace/bin/dspace checker -l -p > /dev/null
0 6 * * 0 /opt/dspace/bin/dspace checker-emailer > /dev/null
0 1 1 * * /opt/dspace/bin/dspace cleanup > /dev/null
```

## Editing Route Source 
**Note:** For example, the installation path is /opt

### page-structure.xsl
```sh
$ nano /opt/dspace-source/dspace-xmlui-mirage2/src/main/webapp/xsl/core/page-structure.xsl
```
### item-view.xsl
```sh
$ nano /opt/dspace-source/dspace-xmlui-mirage2/src/main/webapp/xsl/aspect/artifactbrowser/item-view.xsl
```
### languages
>[Recommended location for i18n customizations](https://wiki.duraspace.org/display/DSDOC6x/Localization+L10n)
```sh
$ mkdir /opt/dspace-source/dspace/modules/xmlui/src/main/webapp/i18n/
$ nano /opt/dspace-source/dspace/modules/xmlui/src/main/webapp/i18n/messages_en.xml
```
### static contents
>[Repository admins and developers will also benefit because of the tools available to make both simple and advanced customizations](https://wiki.duraspace.org/display/DSDOC6x/Mirage+2+Configuration+and+Customization)
```sh
$ mkdir /opt/dspace-source/dspace/modules/xmlui/src/main/webapp/static/
$ mkdir /opt/dspace-source/dspace/modules/xmlui/src/main/webapp/static/mycontent/
$ nano /opt/dspace-source/dspace/modules/xmlui/src/main/webapp/static/mycontent/mystyle.css
```

### input-forms.xml
```sh
$ nano /opt/dspace-source/dspace/config/input-forms.xml
```
### news-xmlui.xml
```sh
$ nano /opt/dspace-source/dspace/config/news-xmlui.xml
```

## Rebuild DSpace
> dspace user
```sh
$ cd /opt/dspace-source
$ mvn package -Dmirage2.on=true
$ cd /opt/dspace-source/dspace/target/dspace-installer/
$ ant update
```
> root user
```sh
$ service tomcat7 restart && service apache2 restart
```

## Create an initial administrator account
```sh
$ /opt/dspace/bin/dspace create-administrator
```

## Back Up
**Note:** For example, a dspace user
```sh
$	sudo -u dspace pg_dump -U dspace -f mybackup.dump dspace -Fc
$   tar -czvf dspace.tar.gz dspace
```

# License
This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. 