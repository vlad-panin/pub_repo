#!/bin/bash
tomcatHome=$(grep 'CATALINA_HOME' /home/tomcat/.bash_profile |  awk -F"'" '{print $2}')
backupDir=`date +%Y%m%d`
cd $tomcatHome/conf/
dirCheck="$tomcatHome/conf/202"
if [ -d ${dirCheck}* ] 2>/dev/null; then
  echo "Backup dir already exist"
  exit 1
else
  ls ${dirCheck}* >/dev/null 2>&1
  if [ $? -ne 0 ]; then
    echo "No backup dir found. Good!"
    mkdir $backupDir
    cp server.keystore $backupDir/server.keystore
    chmod 400 $backupDir/server.keystore
    cp /tmp/server.keystore .
    exit 0
  else
    echo "More than one folder starting with ${ID}"
	  exit 2
  fi
fi
