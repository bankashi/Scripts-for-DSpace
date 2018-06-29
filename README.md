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

# Miscellaneous
## Scheduled Tasks via Cron (crontab)
### Root user
```sh
1 0 * * * chmod -R 775 /dspace/log/ > /dev/null
2 0 * * * chmod -R 775 /dspace/var/oai/ > /dev/null
0 3 * * * chmod -R 775 /dspace/var/oai/ > /dev/null
```
### Dspace user
```sh
3 0 * * * /dspace/bin/dspace oai import -c > /dev/null
3 0 * * * /dspace/bin/dspace oai import -c > /dev/null
0 3 * * * /dspace/bin/dspace filter-media
0 4 * * * /dspace/bin/dspace curate -q admin_ui
0 0,8,16 * * * /dspace/bin/dspace generate-sitemaps > /dev/null
0 6 * * * /dspace/bin/dspace sub-daily
0 3 * * 0 /dspace/bin/dspace checker -l -p
0 6 * * 0 /dspace/bin/dspace checker-emaile
0 1 1 * * /dspace/bin/dspace cleanup > /dev/null
```

## Editing Route Source 
**Note:** This repository was installed in the root
### page-structure.xsl
```sh
$ nano /dspace-source/dspace-xmlui-mirage2/src/main/webapp/xsl/core/page-structure.xsl
```
### item-view.xsl
```sh
$ nano /dspace-source/dspace-xmlui-mirage2/src/main/webapp/xsl/aspect/artifactbrowser/item-view.xsl
```
### languages
```sh
$ mkdir /dspace-source/dspace/modules/xmlui/src/main/webapp/i18n/
$ nano/dspace-source/dspace/modules/xmlui/src/main/webapp/i18n/messages_en.xml
```
### static content
```sh
$ mkdir /dspace-source/dspace/modules/xmlui/src/main/webapp/static/
$ mkdir /dspace-source/dspace/modules/xmlui/src/main/webapp/static/mycontent/
$ nano /dspace-source/dspace/modules/xmlui/src/main/webapp/static/mycontent/mystyle.css
```

### input-forms.xml
```sh
$ nano /dspace-source/dspace/config/input-forms.xml
```
### news-xmlui.xml
```sh
$ nano /dspace-source/dspace/config/news-xmlui.xml
```

# Contribution guidelines
- Written: bankashi
- Version: 2.0 RC

# License
This Source Code Form is subject to the terms of the Mozilla PublicLicense, v. 2.0. 