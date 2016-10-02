# Introduction

* SquirrelMail comes installed with BX5106R.
* There is no Webmail in 5107/5108R and later installs. [5107R missing webmail support](http://mail.blueonyx.it/pipermail/blueonyx/2011-July/007901.html)

# Locations

* `/usr/share/squirrelmail/` -- SquirrelMail core code
* `/etc/squirrelmail/` -- files 644 root:admserv - Actual Configuration files here are symlinked in core
* `/var/lib/squirrelmail/prefs/` - User Preferences
* `/var/spool/squirrelmail/attach` - Attachments
* `/etc/httpd/conf.d/squirrelmail.conf.bx` - http Port 444 webmail apache conf
* `/etc/admserv/conf.d/squirrelmail.conf` - https Port 81 webmail apache conf

# Customisations for BlueOnyx

* BlueOnyx uses `hunspell` instead of `ispell`, the default in SquirelMail config 
* `functions/i18n.php` has all languages as scalars and jap conv hardcoding in BlueOnyx
* `src/view_text.php` Japanese language exception hardcoded
* `data/default_pref` file is moved to `/etc/squirrelmail` and symlinked from there
* Custom`function sqrestrict_to_num()` in `functions/global.php` replaces `(int)` typecasting in core files

# Defaults

````
chmod 755 /usr/share/squirrelmail/config/conf.pl
yum install hunspell-en
cd /usr/share/squirrelmail/plugins/squirrelspell
ln -s ../../../../../etc/squirrelmail/sqspell_config.php .
cd /usr/share/squirrelmail/config/
ln -s ../../../../etc/squirrelmail/config_local.php .
ln -s ../../../../etc/squirrelmail/config.php
````

# Resolved References

* [Installing Squirrelmail on BlueOnyx 6 5107R](https://www.server-centre.net/support/blueonyx-squirrelmail.htm)
* [5107R missing webmail support](http://mail.blueonyx.it/pipermail/blueonyx/2011-July/007901.html)
* [Added separate httpd squirrelmail.conf and fixed suPHP for AdmServ conf](http://devel.blueonyx.it/trac/changeset?new=914%40%2F&old=912%40%2F)
* [SquirrelMail and suPHP issues](http://mail.blueonyx.it/pipermail/blueonyx/2012-August/011076.html)
* [SquirrelMail suPHP solution](http://blueonyx.mail.blueonyx.narkive.com/EKPDqeny/blueonyx-11075-squirrelmail-and-suphp)
* [SquirrelMail EPEL Issues in Missing WebMail](http://mail.blueonyx.it/pipermail/blueonyx/2011-July/007905.html)

# OpenWebMail

* [Installing OpenWebmail on BlueOnyx server](http://coding.infoconex.com/post/2011/10/10/Installing-OpenWebmail-on-BlueOnyx-server)
* [How to set up OpenWebMail in CentOS](http://xmodulo.com/open-webmail-centos.html)
* [OpenWebMail RedHat HOWTO](https://openwebmail.org/openwebmail/download/redhat/howto/00-openwebmail.html)
* [OpenWebMail CentOS HOWTO](http://openwebmail.lagmonster.org/download/centos/el6/00.readme.txt)
* [OpenWebMail RedHat Install](http://openwebmail.org/openwebmail/download/redhat/howto/00-openwebmail.html)

# RoundCube Mail
