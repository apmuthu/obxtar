#!/bin/sh

#######################################
# Auther: Hisao SHIBUYA
# $Id:$
#######################################

## Check permission
if [ $UID -ne 0 ]; then
  echo "This updater must be executed by root or with sudo."
  exit 1
fi


## Check installed RPMS
echo
echo "[Phase 1 : checking intalled RPMS...]"
echo

if [ -f /etc/redhat-release ] && [ "`rpm -q --qf=%{version} centos-release`" != "4" ]; then
  echo "** ERROR **"
  echo "This package supports for CentOS 4 only!!"
  exit 1;
fi

rpm -q base-bluequartz-capstone > /dev/null
if [ $? -eq 1 ]; then
  echo
  echo "** ERROR **"
  echo "BlueQuartz-5100R is not installed."
  echo "** Please execute install.sh instead of update.sh. **"
  exit 1
fi

echo


## Install RPMS
echo
echo "[Phase 2 : updating RPMS...]"
echo
RPM_PATH=`pwd`/RPMS

rpm -Uvh --nodeps $RPM_PATH/base-bluequartz-glue*
rpm -Uvh --nodeps --force $RPM_PATH/*.rpm


## start daemons
echo
echo "[Phase 3 : restart daemons...]"
echo
services="bluequartz cced.init httpd admserv xinetd sendmail"
#services="httpd admserv xinetd sendmail"
for service in $services; do
  /sbin/chkconfig $service on
  /sbin/service $service restart
done


## finished
echo
echo "Finish update process"
echo
