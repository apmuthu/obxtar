# obxtar
* Based on BlueQuartz and BlueOnyx install tar scripts
* Any modifications to these scripts will be in appropriate folders
* These changes are not in any way supported or endorsed by the official BlueQuartz or BlueOnyx teams
* Use content and code here at your own risk
* BX 520x series is not supported currently as the new theme relies on CodeIgniter - too slow, too heavy.

## Versions
### BQ5102R
* BlueQuartz Based on CentOS 4.9 / PHP 4.3.9
* NuOnce CD v4.8 no longer supported
* [BlueQuartz PKGs](http://mirror.data-hotel.biz/pub01/CobaltSoftwares/BlueQuartz/Data-BlueOnyx/BQ-Pkgs/)
* [Security Advisory and fix](http://www.blueonyx.it/index.php?mact=News,cntnt01,detail,0&cntnt01articleid=95&cntnt01returnid=15)
** requires the insertion of the following lines into all /etc/httpd/conf/vhosts/site*.include files and /etc/httpd/conf/vhosts/preview within the VirtualHost tags:
````
RewriteEngine On
RewriteCond %{HTTP:Range} bytes=0-.* [NC]
RewriteRule .? http://%{SERVER_NAME}/ [R=302,L]
````

### BX5106R 
*  Based on CentOS 5.8 (will upgrade to CentOS v5.10)
*  32 bit

### BX5107R
* Based on CentOS 6.x / Scientific Linux 6 / RHEL 6
* 32 bit

### BX5108R
* Based on CentOS 6.x / Scientific Linux 6 / RHEL 6
* 64 bit

## Notes
* All tar files here contain an install.sh file that needs to be executed in a minimal CentOS (or SL or RHEL) install of appropriate version listed above
* All installs can be done on physical machines or OpenVZ containers
* All initial "root" passwords should be "blueonyx"
* All BX series above have default PHP 5.1.6

## References
* [TAR Files](http://blueonyx.precisionweb.net/BlueOnyx/TAR/)
* [Install BlueOnyx in Proxmox OpenVZ CentOS VPS](http://saralinux.blogspot.in/2014/01/install-blueonyx.html)
* [Installing a VPS from a BlueOnyx Template](http://www.blog.paranoidpenguin.net/2011/11/installing-a-blueonyx-openvz-template-with-proxmox-ve/)
* [French Wiki Page on BlueOnyx Install](http://wiki.kogite.fr/index.php/Proxmox_Openvz)
* [Forum Post on BX Installation](http://permalink.gmane.org/gmane.linux.devices.blueonyx.user/8957)
* [Upgrading to BX520.R](https://www.virtbiz.com/support/index.php?/Knowledgebase/Article/View/125/3/upgrade-to-blueonyx-5208r)
