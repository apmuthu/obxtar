#!/bin/sh

#######################################
# Auther: Hisao SHIBUYA
# $Id:$
#######################################

## Check permission
if [ $UID -ne 0 ]; then
  echo "This installer must be executed by root or with sudo."
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
if [ $? -eq 0 ]; then
  echo
  echo "** ERROR **"
  echo "BlueQuartz-5100R is already installed."
  echo "** Please execute update.sh instead of install.sh. **"
  exit 1
fi

requires="php distcache mod_perl bind-chroot openssh telnet-server expect net-snmp ntp perl-XML-Parser gd net-snmp-utils php-mbstring audit-libs dovecot php-mysql mysql mysql-server"
for rpm in $requires; do
  rpm -q $rpm > /dev/null
  if [ $? -eq 1 ]; then
    echo
    echo "** ERROR **"
    echo "[$rpm] is not installed. Please install [$rpm] package."
    exit 1
  fi
  echo "[$rpm] is installed."
done


## delete package
removes="vsftp compat-pwdb"
for rpm in $removes; do
  rpm -q $rpm > /dev/null
  if [ $? -eq 0 ]; then
    rpm -e $rpm > /dev/null
    echo
    echo "remove [$rpm] package."
  fi
done


echo


## Install RPMS
echo
echo "[Phase 2 : installing RPMS...]"
echo
RPM_PATH=`pwd`/RPMS

# install base-bluequartz-glue first
rpm -ivh --nodeps $RPM_PATH/base-bluequartz-glue*
rpm -Uvh --nodeps --force $RPM_PATH/*.rpm


## start daemons
echo
echo "[Phase 3 : restart daemons...]"
echo
hostname localhost
services="bluequartz cced.init httpd admserv xinetd sendmail"
#services="httpd admserv xinetd sendmail"
for service in $services; do
  /sbin/chkconfig $service on
  /sbin/service $service restart
done


## check admin user is exist
id admin > /dev/null 2>&1
if [ $? -eq 1 ]; then
  /usr/sausalito/constructor/base/user/50_addAdmin.pl
fi

id admin > /dev/null 2>&1
if [ $? -eq 1 ]; then
  echo "Fail to add admin user"
  exit 1;
fi


## post scripts
/usr/sausalito/constructor/base/wizard/\:sysreset\:linkToWizard.pl


## finished
echo
echo "Finish installation"
echo
echo "Access http://xxx.xxx.xxx.xxx/login with admin/admin"
echo "** Your root password is same as admin password. **"
echo
