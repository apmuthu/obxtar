: '
== Locations ==
/usr/share/squirrelmail/ -- SquirrelMail core code
/etc/squirrelmail/ -- files 644 root:admserv - Actual Configuration files here are symlinked in core
/var/lib/squirrelmail/prefs/ - User Preferences
/var/spool/squirrelmail/attach - Attachments
/etc/httpd/conf.d/squirrelmail.conf.bx - http Port 444 webmail apache conf
/etc/admserv/conf.d/squirrelmail.conf - https: Port 81 webmail apache conf

== BlueOnyx specifics ==
BlueOnyx uses hunspell instead of ispell, the default in SquirelMail config 
functions/i18n.php has all languages as scalars and jap conv hardcoding in BlueOnyx
src/view_text.php jap lang exception hardcoded
data/default_pref file is moved to /etc/squirrelmail and symlinked from there
Custom function sqrestrict_to_num() in functions/global.php replaces (int) typecasting in core files
'

mkdir -p /root/sqmail/epel
cd /root/sqmail/epel
# Upload the epel squirrelmail rpms or get them with:
wget \
http://mirror.bytemark.co.uk/fedora/epel/6/x86_64/php-pear-DB-1.7.13-3.el6.noarch.rpm \
http://dl.fedoraproject.org/pub/epel/6/x86_64/squirrel-2.2.4-2.el6.x86_64.rpm \
http://dl.fedoraproject.org/pub/epel/6/x86_64/squirrel-devel-2.2.4-2.el6.x86_64.rpm \
http://dl.fedoraproject.org/pub/epel/6/x86_64/squirrel-libs-2.2.4-2.el6.x86_64.rpm \
http://dl.fedoraproject.org/pub/epel/6/x86_64/squirrelmail-1.4.22-4.el6.noarch.rpm
 
yum localinstall php-pear-DB-1.7.13-3.el6.noarch.rpm
yum localinstall squirrelmail-1.4.22-4.el6.noarch.rpm
yum localinstall squirrel-devel-2.2.4-2.el6.x86_64.rpm \
                 squirrel-2.2.4-2.el6.x86_64.rpm \
                 squirrel-libs-2.2.4-2.el6.x86_64.rpm
cd ..
mkdir -p /root/sqmail/bxglue
cd /root/sqmail/bxglue
# alternate sites: http://blueonyx.precisionweb.net/BlueOnyx/5106R/CentOS6/blueonyx/i386/RPMS/
# Upload the BlueOnyx Glue RPMs or get them with (choose your mirror):
wget -c \
http://updates.blueonyx.it/pub/BlueOnyx/5106R/CentOS6/blueonyx/i386/RPMS/base-squirrelmail-capstone-1.0.0-0BX18.el6.noarch.rpm \
http://updates.blueonyx.it/pub/BlueOnyx/5106R/CentOS6/blueonyx/i386/RPMS/base-squirrelmail-glue-1.0.0-0BX18.el6.noarch.rpm \
http://updates.blueonyx.it/pub/BlueOnyx/5106R/CentOS6/blueonyx/i386/RPMS/base-squirrelmail-locale-da_DK-1.0.0-0BX18.el6.noarch.rpm \
http://updates.blueonyx.it/pub/BlueOnyx/5106R/CentOS6/blueonyx/i386/RPMS/base-squirrelmail-locale-de_DE-1.0.0-0BX18.el6.noarch.rpm \
http://updates.blueonyx.it/pub/BlueOnyx/5106R/CentOS6/blueonyx/i386/RPMS/base-squirrelmail-locale-en_US-1.0.0-0BX18.el6.noarch.rpm \
http://updates.blueonyx.it/pub/BlueOnyx/5106R/CentOS6/blueonyx/i386/RPMS/base-squirrelmail-locale-es_ES-1.0.0-0BX18.el6.noarch.rpm \
http://updates.blueonyx.it/pub/BlueOnyx/5106R/CentOS6/blueonyx/i386/RPMS/base-squirrelmail-locale-fr_FR-1.0.0-0BX18.el6.noarch.rpm \
http://updates.blueonyx.it/pub/BlueOnyx/5106R/CentOS6/blueonyx/i386/RPMS/base-squirrelmail-locale-it_IT-1.0.0-0BX18.el6.noarch.rpm \
http://updates.blueonyx.it/pub/BlueOnyx/5106R/CentOS6/blueonyx/i386/RPMS/base-squirrelmail-locale-ja_JP-1.0.0-0BX18.el6.noarch.rpm \
http://updates.blueonyx.it/pub/BlueOnyx/5106R/CentOS6/blueonyx/i386/RPMS/base-squirrelmail-locale-nl_NL-1.0.0-0BX18.el6.noarch.rpm \
http://updates.blueonyx.it/pub/BlueOnyx/5106R/CentOS6/blueonyx/i386/RPMS/base-squirrelmail-locale-pt_PT-1.0.0-0BX18.el6.noarch.rpm \
http://updates.blueonyx.it/pub/BlueOnyx/5106R/CentOS6/blueonyx/i386/RPMS/base-squirrelmail-ui-1.0.0-0BX18.el6.noarch.rpm
 
yum localinstall base-squirrelmail-capstone-1.0.0-0BX18.el6.noarch.rpm \
     base-squirrelmail-glue-1.0.0-0BX18.el6.noarch.rpm \
     base-squirrelmail-locale-da_DK-1.0.0-0BX18.el6.noarch.rpm \
     base-squirrelmail-locale-de_DE-1.0.0-0BX18.el6.noarch.rpm \
     base-squirrelmail-locale-en_US-1.0.0-0BX18.el6.noarch.rpm \
     base-squirrelmail-locale-es_ES-1.0.0-0BX18.el6.noarch.rpm \
     base-squirrelmail-locale-fr_FR-1.0.0-0BX18.el6.noarch.rpm \
     base-squirrelmail-locale-it_IT-1.0.0-0BX18.el6.noarch.rpm \
     base-squirrelmail-locale-ja_JP-1.0.0-0BX18.el6.noarch.rpm \
     base-squirrelmail-locale-nl_NL-1.0.0-0BX18.el6.noarch.rpm \
     base-squirrelmail-locale-pt_PT-1.0.0-0BX18.el6.noarch.rpm \
     base-squirrelmail-ui-1.0.0-0BX18.el6.noarch.rpm
 
chown -R admserv:root /var/spool/squirrelmail/attach

:'
chmod 755 /usr/share/squirrelmail/config/conf.pl
yum install hunspell-en
cd /usr/share/squirrelmail/plugins/squirrelspell
ln -s ../../../../../etc/squirrelmail/sqspell_config.php .
cd /usr/share/squirrelmail/config/
ln -s ../../../../etc/squirrelmail/config_local.php .
ln -s ../../../../etc/squirrelmail/config.php
'

/etc/init.d/cced.init restart
/etc/init.d/admserv restart

