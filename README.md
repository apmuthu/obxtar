# obxtar
* Based on BlueQuartz and BlueOnyx install tar scripts
* Any modifications to these scripts will be in appropriate folders
* These changes are not in any way supported or endorsed by the official BlueQuartz or BlueOnyx teams
* Use content and code here at your own risk
* BX 520x series is experimental currently as the new theme relies on CodeIgniter - too slow, too heavy.

## Versions
### BQ5102R
* BlueQuartz Based on CentOS 4.9 / PHP 4.3.9
* NuOnce CD v4.8 no longer supported
* [BlueQuartz PKGs](http://mirror.data-hotel.biz/pub01/CobaltSoftwares/BlueQuartz/Data-BlueOnyx/BQ-Pkgs/)
* [Security Advisory and fix](http://www.blueonyx.it/index.php?mact=News,cntnt01,detail,0&cntnt01articleid=95&cntnt01returnid=15)
* Requires the insertion of the following lines into all /etc/httpd/conf/vhosts/site*.include files and /etc/httpd/conf/vhosts/preview within the VirtualHost tags:
````
RewriteEngine On
RewriteCond %{HTTP:Range} bytes=0-.* [NC]
RewriteRule .? http://%{SERVER_NAME}/ [R=302,L]
````

### BX5106R / PHP 5.1.6
* Based on CentOS 5.8 (will upgrade to CentOS v5.10)
* 32 bit

### BX5107R / PHP 5.3.3
* Based on CentOS 6.x / Scientific Linux 6 / RHEL 6
* 32 bit

### BX5108R / PHP 5.3.3
* Based on CentOS 6.x / Scientific Linux 6 / RHEL 6
* 64 bit

### BX5208R / PHP 5.3.3 (Experimental)
* Based on CentOS 6.x / Scientific Linux 6 / RHEL 6
* 64 bit
* Admserv runs on Chorizo theme
* Chorizo is based on CodeIgniter
* [Upgrading to BX5208R](https://www.virtbiz.com/support/index.php?/Knowledgebase/Article/View/125/3/upgrade-to-blueonyx-5208r)

## Notes
* All tar files here contain an install.sh file that needs to be executed in a minimal CentOS (or SL or RHEL) install of appropriate version listed above
* Installs can be done on physical machines or OpenVZ containers
* Initial "root" password should be "blueonyx"

## References
* [TAR Files](http://blueonyx.precisionweb.net/BlueOnyx/TAR/) | [ISO Files](http://blueonyx.precisionweb.net/BlueOnyx/ISO/)
* [Install BlueOnyx in Proxmox OpenVZ CentOS VPS](http://saralinux.blogspot.in/2014/01/install-blueonyx.html)
* [Installing a VPS from a BlueOnyx Template](http://www.blog.paranoidpenguin.net/2011/11/installing-a-blueonyx-openvz-template-with-proxmox-ve/)
* [French Wiki Page on BlueOnyx Install](http://wiki.kogite.fr/index.php/Proxmox_Openvz)
* [Forum Post on BX Installation](http://permalink.gmane.org/gmane.linux.devices.blueonyx.user/8957)
* [Forum Post on Multiple Gateways in one VPS using global IP on veth](http://forum.proxmox.com/threads/1733-Physical-Host-with-2-NICs-Each-with-Different-Gateways?p=9287#post9287)
* [OpenWebMail on BlueOnyx](http://coding.infoconex.com/post/2011/10/10/Installing-OpenWebmail-on-BlueOnyx-server)
* [Spam-Milter on BlueOnyx](http://simonecapra.com/2014/03/installing-spamass-milter-blueonyx/)
* [Step By Step install Mailscanner Solution](https://linuxstep.wordpress.com/step-by-step-install-mailscanner-solution/)
* [Install SpamAssassin on BlueQuartz](http://labs.erweb.it/pub/installing_spamassassin.php)
