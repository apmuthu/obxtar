#!/bin/sh

#######################################
# Author: Michael Stauber
# (c) Team BlueOnyx 2009
# http://www.blueonyx.it
# Date: Wed 01 Apr 2009 12:36:55 PM EDT
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
                /bin/echo "Please note: This CentOS5 currently has SELinux set to 'targeted' or 'enabled'."
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

if [ -f /etc/redhat-release ] && [ "`rpm -q --qf=%{version} centos-release`" != "5" ]; then
  /bin/echo "***********"
  /bin/echo "** ERROR **"
  /bin/echo "***********"
  /bin/echo "This installer is for CentOS 5 only!"
  exit 1;
fi

rpm -q base-blueonyx-capstone > /dev/null
if [ $? -eq 0 ]; then
  /bin/echo "***********"
  /bin/echo "** ERROR **"
  /bin/echo "***********"
  /bin/echo "BlueOnyx-5106R is already installed."
  exit 1
fi

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
echo "[Phase 2 : Setting up repositories ...]"
echo
RPM_PATH=`pwd`/RPMS

# install base-bluequartz-glue first
rpm -hUv $RPM_PATH/blueonyx-yumconf-*
rpm -hUv $RPM_PATH/solarspeed-blueonyx-repo-*

# If we're in an OpenVZ VPS (and *only* then!), we need the virtual 5106R YUM repository file as well:
if [ -e "/proc/user_beancounters" ];then
	rpm -hUv $RPM_PATH/solarspeed-virtual-5106R-repo-*
	# And we also install the dummy-centos RPM as the user may not have the right one:
	rpm -hUv --force --nodeps $RPM_PATH/dummy-centos-*
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

# Check OS if all required RPMs are installed:
/usr/bin/yum install -y acl am-bins analog apr apr-util aspell aspell-en attr audit audit-libs basesystem bash bc beecrypt bind bind-chroot bind-libs bind-utils binutils bzip2 bzip2-libs centos-release cgiwrap chkconfig coreutils cpio cracklib cracklib-dicts crash crontabs cryptsetup curl cyrus-sasl cyrus-sasl-md5 cyrus-sasl-plain db4 dbus dbus-glib device-mapper dhclient dialog diffutils distcache dmraid dos2unix dosfstools dovecot dump e2fsprogs ed eject elfutils elfutils-libelf ethtool expat expect fbset file filesystem findutils fontconfig freetype ftp gawk gd gdbm glib glib2 glibc glibc-common glib-ghash gmp gpm grep groff grub gzip hdparm hesiod httpd httpd-manual hwdata indexhtml info initscripts iproute iptables iptstate iputils jpackage-utils jwhois kbd krb5-libs krb5-workstation less libacl libattr libcap libc-client libgcc libgcrypt libgpg-error libidn libjpeg libpng libselinux libsepol libstdc++ libtermcap libuser libxml2 libxml2-python libxslt lm_sensors logrotate logwatch lsof lvm2 lynx m4 mailcap mailx mailman make man man-pages mc mdadm mgetty mingetty mktemp mod_cband mod_nss mod_perl mod_ssl ms-sys mtools mtr mt-st mysql mysql-server nano nc ncurses net-snmp net-snmp-libs net-snmp-utils net-tools newt nscd nss_db nss_ldap ntp ntsysv numactl openldap openssh openssh-clients openssh-server openssl pam pam_ccreds pam_krb5 pam_passwdqc parted passwd pax pciutils pcre perl perl-Authen-PAM perl-Compress-Zlib perl-Data-Flow perl-DBD-MySQL perl-DBI perl-GD perl-GDGraph perl-GDTextUtil perl-handler-utils perl-HTML-Parser perl-HTML-Tagset perl-Jcode perl-libwww-perl perl-Quota perl-suidperl perl-URI perl-XML-Parser php php-gd php-imap php-mbstring php-mysql php-pear pine policycoreutils poprelayd popt prelink procmail procps proftpd psacct psmisc pwdb python python-elementtree python-sqlite python-urlgrabber pyxf86config quota rdate rdist re2c readline redhat-logos rhpl rmt rootfiles rpm rpm-libs rpm-python rsync schedutils sed sendmail sendmail-cf sendmail-doc setarch setserial setup setuptool shadow-utils slang slocate specspo sqlite sudo swatch symlinks sysklogd syslinux sysreport SysVinit talk tar tcl tcpdump tcp_wrappers telnet telnet-scripts telnet-server termcap time tmpwatch traceroute tzdata udev unix2dos unzip usbutils usermode utempter util-linux vim-minimal vixie-cron webalizer wget which xinetd xmlsec1 xmlsec1-openssl yum zip zlib

# Install BlueOnyx RPMs:
/usr/bin/yum install --exclude=base-maillist* -y sausalito-cce-client sausalito-cce-server sausalito-gallery sausalito-gallery-locale-en sausalito-gallery-locale-ja sausalito-i18n sausalito-palette 5106R-cmu 5106R-shell-tools base-admserv-capstone base-admserv-glue base-alpine-capstone base-alpine-glue base-alpine-hardware-conf base-alpine-locale-en base-alpine-locale-ja base-alpine-ui base-am-capstone base-am-glue base-am-locale-en base-am-locale-ja base-am-ui base-apache-am base-apache-bandwidth-capstone base-apache-bandwidth-glue base-apache-bandwidth-locale-en base-apache-bandwidth-locale-ja base-apache-bandwidth-ui base-apache-capstone base-apache-glue base-apache-locale-en base-apache-locale-ja base-apache-ui base-backupcontrol-capstone base-backupcontrol-glue base-backupcontrol-locale-en base-backupcontrol-locale-ja base-backupcontrol-ui base-blueonyx-capstone base-blueonyx-glue base-disk-am base-disk-capstone base-disk-glue base-disk-locale-en base-disk-locale-ja base-disk-ui base-dns-am base-dns-capstone base-dns-glue base-dns-locale-en base-dns-locale-ja base-dns-ui base-documentation-capstone base-documentation-locale-en base-documentation-locale-ja base-documentation-ui base-email-am base-email-capstone base-email-glue base-email-locale-en base-email-locale-ja base-email-ui base-ftp-am base-ftp-capstone base-ftp-glue base-ftp-locale-en base-ftp-locale-ja base-ftp-ui base-import-capstone base-import-glue base-import-locale-en base-import-locale-ja base-import-ui base-java-am base-java-capstone base-java-filler base-java-glue base-java-locale-de_DE base-java-locale-en base-java-ui base-mailman-am base-mailman-capstone base-mailman-glue base-mailman-locale-en base-mailman-locale-ja base-mailman-ui base-memory-capstone base-memory-glue base-memory-locale-en base-memory-locale-ja base-mysql-am base-mysql-capstone base-mysql-glue base-mysql-locale-da_DK base-mysql-locale-de_DE base-mysql-locale-en base-mysql-locale-ja base-mysql-ui base-network-am base-network-capstone base-network-glue base-network-locale-en base-network-locale-ja base-network-ui base-phpmyadmin-capstone base-phpmyadmin-glue base-phpmyadmin-locale-da_DK base-phpmyadmin-locale-de_DE base-phpmyadmin-locale-en base-phpmyadmin-locale-ja base-phpmyadmin-ui base-phpsysinfo-capstone base-phpsysinfo-glue base-phpsysinfo-locale-da_DK base-phpsysinfo-locale-de_DE base-phpsysinfo-locale-en base-phpsysinfo-ui base-power-capstone base-power-glue base-power-locale-en base-power-locale-ja base-power-ui base-sauce-basic-capstone base-sauce-basic-glue base-sauce-basic-locale-en base-sauce-basic-locale-ja base-schedule-capstone base-schedule-glue base-schedule-locale-en base-schedule-locale-ja base-services-capstone base-services-glue base-services-locale-en base-services-locale-ja base-services-ui base-shell-capstone base-shell-glue base-shell-locale-en base-shell-locale-ja base-shell-ui base-sitestats-capstone base-sitestats-glue base-sitestats-locale-en base-sitestats-locale-ja base-sitestats-scripts base-sitestats-ui base-snmp-am base-snmp-capstone base-snmp-glue base-snmp-locale-en base-snmp-locale-ja base-snmp-ui base-squirrelmail-capstone base-squirrelmail-glue base-squirrelmail-locale-da_DK base-squirrelmail-locale-de_DE base-squirrelmail-locale-en base-squirrelmail-locale-ja base-squirrelmail-ui base-ssh-capstone base-ssh-glue base-ssh-locale-en base-ssh-locale-ja base-ssh-ui base-ssl-capstone base-ssl-glue base-ssl-locale-en base-ssl-locale-ja base-ssl-ui base-subdomains-capstone base-subdomains-glue base-subdomains-locale-da_DK base-subdomains-locale-de_DE base-subdomains-locale-en base-subdomains-locale-ja base-subdomains-ui base-swupdate-capstone base-swupdate-glue base-swupdate-locale-en base-swupdate-locale-ja base-swupdate-ui basesystem base-system-capstone base-system-glue base-system-locale-en base-system-locale-ja base-system-ui base-telnet-am base-telnet-capstone base-telnet-glue base-telnet-locale-en base-telnet-locale-ja base-telnet-ui base-time-capstone base-time-glue base-time-locale-en base-time-locale-ja base-time-src base-time-ui base-user-capstone base-user-glue base-user-locale-en base-user-locale-ja base-user-ui base-vsite-capstone base-vsite-glue base-vsite-locale-en base-vsite-locale-ja base-vsite-ui base-wizard-capstone base-wizard-glue base-wizard-locale-en base-wizard-locale-ja base-wizard-ui nuonce-cd-upgrade nuonce-dnsImport nuonce-hostsfix nuonce-mindterm solarspeed-ioncube base-*-locale-da_DK base-*-locale-de_DE base-*-locale-en base-*-locale-ja

# If we're in an OpenVZ VPS (and *only* then!), we need the nuonce-solarspeed-vbq-constructors as well:
if [ -e "/proc/user_beancounters" ];then
	/usr/bin/yum install -y nuonce-solarspeed-vbq-constructors
fi

# Fix a small networking problem.  If you don't enable this, you may get a route for the 169.254/16 network
echo "NOZEROCONF=yes" >> /etc/sysconfig/network

# Raid:
# If RAID was enabled, lets set it up!
MD=`/bin/cat /proc/mdstat | /bin/grep ^md | /usr/bin/wc -l`
if [ "$MD" != "0" ]; then
	echo
	echo "[RAID-Phase : RAID detected, installing and configuring RAID support ...]"
	echo
  	/usr/bin/yum install -y base-raid-capstone base-raid-glue base-raid-locale-en base-raid-locale-ja base-raid-ui
  	# Fix RAID!
  	/sbin/lsraid -R -p | sed "/^$/d" | grep -v "#" > /etc/raidtab
fi

# Turn unneeded services off
echo
echo "[Phase 5 : turn unneeded daemons off ...]"
echo
OFF_SERVICES="anacron portmap netfs lm_sensors gpm kudzu"
for S in $OFF_SERVICES; do
        if [ -f /etc/init.d/$S ];then
                /sbin/chkconfig $S off
        fi
done

# Turn needed services on and restart them:
echo
echo "[Phase 6 : restart daemons...]"
echo
ON_SERVICES="syslog httpd iptables xinetd bluequartz cced.init admserv sendmail named"
for S in $ON_SERVICES; do
        if [ -f /etc/init.d/$S ];then
                /sbin/chkconfig $S on
                /sbin/service $S restart
        fi
done

# Install CD-Installer RPM:
rpm -hUv --force --nodeps $RPM_PATH/blueonyx-cd-installer-*

echo
echo "[Phase 7 : Cleaning up ...]"
echo

# Post install scripts:
echo
echo "[Phase 8 : Running post install scripts ...]"
echo
/tmp/finish_install.sh  > /dev/null 2>&1
/usr/bin/perl -pi -e "s/\/tmp\/setup.sh//" /root/.bashrc

## check admin user is exist
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

/usr/bin/yum clean all

## finished
echo
echo "The installation has finished!"
echo
echo "Please point your browser to http://xxx.xxx.xxx.xxx/login and login with "
echo "username 'admin' and password 'blueonyx'"
echo ""
echo "** Your root password is same as admin password. **"
echo "** SSH root logins are disabled by default now!  **"
echo

