#!/bin/sh

#######################################
# Author: Michael Stauber
# (c) Team BlueOnyx 2009-2011
# http://www.blueonyx.it
# Date: Fri 15 Jul 2011 04:26:59 PM PDT
#######################################

## Check permission
if [ $UID -ne 0 ]; then
  echo "This installer must be executed by root or with sudo."
  exit 1
fi

# Check for SELinux status:
if [ -f /etc/selinux/config ]; then
        SEL=`/bin/cat /etc/selinux/config | /bin/grep "^SELINUX=" | /bin/cut -d = -f2`
        if [ "$SEL" = "disabled" ] ; then
                /bin/echo ""
                /bin/echo "SELinux is disabled. Perfect!"
                /bin/echo ""
        else
                /bin/echo "***********"
                /bin/echo "** ERROR **"
                /bin/echo "***********"
                /bin/echo "SELinux is NOT disabled!"
                /bin/echo ""
                /bin/echo "Please note: This RHEL6 clone currently has SELinux set to 'targeted' or 'enabled'."
                /bin/echo "But BlueOnyx requires it to be 'disabled'. Before you can install BlueOnyx, "
                /bin/echo "you must edit /etc/selinux/config and in there find this line:"
                /bin/echo ""
                /bin/echo "SELINUX=enabled"
                /bin/echo "...or..."
                /bin/echo "SELINUX=targeted"
                /bin/echo ""
                /bin/echo "Change it to this:"
                /bin/echo ""
                /bin/echo "SELINUX=disabled"
                /bin/echo ""
                /bin/echo "Then save the changes and REBOOT. A reboot IS required. Do not skip this!"
                /bin/echo ""
                /bin/echo "Afterwards run this installer again to continue the installation."
		/bin/echo ""
                exit 1
        fi
fi

# Quotachecks for both VPS and stand alone installs:
if [ -e "/proc/user_beancounters" ];then
	# This is for OpenVZ VPS's:
	VPSQUOTA=`/bin/ls -k1 /aquota.group /aquota.user | /usr/bin/wc -l`
	if [ "$VPSQUOTA" != "2" ] ; then
                /bin/echo "***********"                              
                /bin/echo "** ERROR **"                              
                /bin/echo "***********"                              
                /bin/echo ""                                         
                /bin/echo "This OpenVZ container does NOT have 2nd level disk quota enabled!"
                /bin/echo ""                                         
                /bin/echo "Please enable 2nd level disk quota and run this installer again!"                                         
                /bin/echo ""                                         
		exit 1
	fi
else
    # Stand alone installs: Check if /home exists and has quota is enabled:
    if [ -d /home ];then                             

        # Check if /home is a separate partition:
        PART=`/bin/cat /etc/fstab | /bin/grep /home | /usr/bin/wc -l`
        if [ "$PART" = "1" ] ; then                                  
                /bin/echo ""                                         
                /bin/echo "Partition /home exists. Good."            
                /bin/echo ""                                         
        else                                                         
                /bin/echo "***********"                              
                /bin/echo "** ERROR **"                              
                /bin/echo "***********"                              
                /bin/echo ""                                         
                /bin/echo "Partition /home does NOT exists!"
                /bin/echo ""
                /bin/echo "Please note: BlueOnyx requires that /home exists and is a separate partition!"
                /bin/echo ""
                /bin/echo "Apparently this is not the case on this system. Please reinstall the OS and"
                /bin/echo "make sure during partitioning that /home exists, has quota enabled and is"
                /bin/echo "large enough to hold all your sites and users."
                /bin/echo ""
                exit 1
        fi

        # Check if quota is enabled:
        USERQUOTA=`/bin/cat /etc/fstab | /bin/grep /home | /bin/grep "usrquota" | /usr/bin/wc -l`
        GROUPQUOTA=`/bin/cat /etc/fstab | /bin/grep /home | /bin/grep "grpquota" | /usr/bin/wc -l`
        if [ "$USERQUOTA" != "1" ] || [ "$GROUPQUOTA" != "1" ] ; then
                /bin/echo "***********"
                /bin/echo "** ERROR **"
                /bin/echo "***********"
                /bin/echo ""
                /bin/echo "Partition /home does NOT have userquota OR groupquota (or both) enabled!"
                /bin/echo ""
                /bin/echo "BlueOnyx requires that /home has file system quotas for users and groups enabled!"
                /bin/echo ""
                /bin/echo "Apparently this is not the case on this system. To enable quota, please do this:"
                /bin/echo ""
                /bin/echo "Edit /etc/fstab and find the line where your /home partition is configured."
                /bin/echo ""
                /bin/echo "It could look similar (but not identical!) to this:"
                /bin/echo ""
                /bin/echo "/dev/VolGroup00/LogVol04 /home  ext3    defaults  1 2"
                /bin/echo ""
                /bin/echo "Change the entry 'defaults' for your /home partition and add ',usrquota,grpquota'"
                /bin/echo "to it, so that it looks similar to this:"
                /bin/echo ""
                /bin/echo "/dev/VolGroup00/LogVol04 /home  ext3    defaults,usrquota,grpquota  1 2"
                /bin/echo ""
                /bin/echo "Afterwards you need to run the following commands as shown:"
                /bin/echo ""
                /bin/echo "/bin/mount -o remount /home"
                /bin/echo "/sbin/quotacheck -cuga"
                /bin/echo "/sbin/quotaon -aug"
                /bin/echo ""
                /bin/echo "Once that is done, run this installer again."
                /bin/echo ""
                exit 1
        else
                /bin/echo "Partition /home has user and group quota enabled. Good."
                /bin/echo ""
        fi
    else
        /bin/echo "***********"
        /bin/echo "** ERROR **"
        /bin/echo "***********"
        /bin/echo ""
        /bin/echo "Directory /home does not exist!"
        /bin/echo ""
        /bin/echo "Please note: BlueOnyx requires that /home exists and is a separate partition!"
        /bin/echo ""
        /bin/echo "Apparently this is not the case on this system. Please reinstall the OS and"
        /bin/echo "make sure during partitioning that /home exists, has quota enabled and is"
        /bin/echo "large enough to hold all your sites and users."
        /bin/echo ""
        exit 1
    fi
fi

## Check installed RPMS
echo
echo "[Phase 1 : Checking intalled RPMS ...]"
echo

if [ -f /etc/redhat-release ] && [ "`rpm -q --qf=%{version} centos-release`" = "6" ]; then 
  if [ "`rpm -q --qf=%{arch} centos-release`" = "i686" ]; then 
	PLTF='5107'; 
  fi 
  if [ "`rpm -q --qf=%{arch} centos-release`" = "x86_64" ]; then 
	PLTF='5108'; 
  fi 
fi 
if [ -f /etc/redhat-release ] && [ "`rpm -q --qf=%{version} sl-release|cut -d \. -f1`" = "6" ]; then 
  if [ "`rpm -q --qf=%{arch} sl-release`" = "i686" ]; then 
	PLTF='5107'; 
  fi 
  if [ "`rpm -q --qf=%{arch} sl-release`" = "x86_64" ]; then 
	PLTF='5108'; 
  fi 
fi 
if [ -f /etc/redhat-release ] && [ "`rpm -q --qf=%{version} redhat-release|cut -d \. -f1`" = "6" ]; then 
  if [ "`rpm -q --qf=%{arch} redhat-release`" = "i686" ]; then 
	PLTF='5107'; 
  fi 
  if [ "`rpm -q --qf=%{arch} redhat-release`" = "x86_64" ]; then 
	PLTF='5108'; 
  fi 
fi; 

if [ -f /etc/redhat-release ] && [ $PLTF != "5107" ]; then
  /bin/echo "***********"
  /bin/echo "** ERROR **"
  /bin/echo "***********"
  /bin/echo "This installer is only for 32-bit RHEL6, CentOS6 or Scientific Linux 6!"
  exit 1;
fi

rpm -q base-blueonyx-capstone > /dev/null
if [ $? -eq 0 ]; then
  /bin/echo "***********"
  /bin/echo "** ERROR **"
  /bin/echo "***********"
  /bin/echo "Looks like BlueOnyx (or parts of it) may already be installed?"
  /bin/echo ""
  /bin/echo "Do you really want to continue? [Y|N] "
  /bin/echo ""
  read DOIT
  if [ $DOIT == "n" ] || [ $DOIT == "N" ]; then 
  	/bin/echo ""
  	/bin/echo "Install terminated on user request."
  	/bin/echo ""
  	/bin/echo ""
	exit 1
  fi
fi

## delete package
removes="vsftp compat-pwdb postfix"
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
echo "[Phase 2 : Setting up repositories ...]"
echo
RPM_PATH=`pwd`/RPMS
VZRPM_PATH=`pwd`/RPMS.vz

rpm -hUv $RPM_PATH/blueonyx-yumconf-2.0.0-3.i386.rpm
rpm -hUv $RPM_PATH/solarspeed-blueonyx-repo-1.0.0-SOL3.i386.rpm

# If we're in an OpenVZ VPS (and *only* then!), we need the virtual 5106R YUM repository file as well:
if [ -e "/proc/user_beancounters" ];then
	rpm -hUv $VZRPM_PATH/solarspeed-virtual-5107R-repo-1.0.4-SOL1.i386.rpm
	# And we also install the VZ RPMs:
	rpm -hUv --force --nodeps $VZRPM_PATH/vzdev-1.0-7.swsoft.noarch.rpm
	rpm -hUv --force --nodeps $VZRPM_PATH/vzdummy-init-fc13-1.0-1.noarch.rpm
	rpm -hUv --force --nodeps $VZRPM_PATH/vzdummy-kernel-el6-2.6.32-SOL1.i386.rpm
	/bin/rm -f /etc/rc3.d/S80fix_grub
fi

echo
echo "[Phase 3 : Updating base OS ...]"
echo

/usr/bin/yum clean all
/usr/bin/yum update -y

echo
echo "[Phase 4 : Installing RPMS ...]"
echo

# OpenVZ work around:
if [ -e "/proc/user_beancounters" ];then
        /usr/bin/yum install -y ethtool mingetty module-init-tools
fi

# Install the groups "core", "base" and "BlueOnyx", which should get everything we need:
/usr/bin/yum -y groupinstall core base BlueOnyx

# Raid:
# If RAID is NOT present, we remove the RAID related RPMs that came aboard during the groupinstall:
MD=`/bin/cat /proc/mdstat | /bin/grep ^md | /usr/bin/wc -l`
if [ "$MD" == "0" ]; then
	echo
	echo "[RAID-Phase : No RAID detected, removing RAID support ...]"
	echo
  	/usr/bin/yum remove -y base-raid-capstone base-raid-glue base-raid-locale-en_US base-raid-ui
	/bin/rm -f /etc/rc3.d/S20mdchk
fi

# Turn unneeded services off
echo
echo "[Phase 5 : turn unneeded daemons off ...]"
echo
OFF_SERVICES="smartd autofs irqbalance netfs microcode_ctl mdchk kudzu iscsid iscsi sysstat ip6tables auditd kdump lldpad fcoe atd messagebus NetworkManager gpm"
for S in $OFF_SERVICES; do
        if [ -f /etc/init.d/$S ];then
                /sbin/chkconfig $S off
        fi
done

# Turn needed services on and restart them:
echo
echo "[Phase 6 : restarting daemons...]"
echo
ON_SERVICES="syslog iptables xinetd blueonyx cced.init admserv sendmail named httpd"
for S in $ON_SERVICES; do
        if [ -f /etc/init.d/$S ];then
                /sbin/chkconfig $S on
                /sbin/service $S restart
        fi
done

# Install CD-Installer RPM:
rpm -hUv --force --nodeps $RPM_PATH/blueonyx-cd-installer-6.0-20110715.i386.rpm

echo
echo "[Phase 7 : Cleaning up ...]"
echo

# Post install scripts:
echo
echo "[Phase 8 : Running post install scripts ...]"
echo
/tmp/finish_install.sh  > /dev/null 2>&1
/usr/bin/perl -pi -e "s/\/tmp\/setup.sh//" /root/.bashrc

## check admin user exist
id admin > /dev/null 2>&1
if [ $? -eq 1 ]; then
  /usr/sausalito/constructor/base/user/50_addAdmin.pl
fi

id admin > /dev/null 2>&1
if [ $? -eq 1 ]; then
  echo "Failed to add admin user. Sorry, something went wrong!"
  echo "Please try to run this script again ..."
  exit 1;
fi

## post scripts
/usr/sausalito/constructor/base/wizard/\:sysreset\:linkToWizard.pl

# Yum logfile fix:
touch /var/log/yum.log
chmod 644 /var/log/yum.log

/usr/bin/yum clean all

## finished
echo
echo "The installation has finished!"
echo
echo "Please point your browser to http://xxx.xxx.xxx.xxx/login and login with "
echo "username 'admin' and password 'blueonyx'"
echo ""
echo "** Your root password is same as admin password.        **"
echo "** SSH root logins are disabled by default now!         **"
echo "** Use user 'admin' instead for SSH and 'su -' to root! **"
echo

