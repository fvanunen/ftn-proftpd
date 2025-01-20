# ftn-proftpd
proftpd config for FTN

```
apt install proftpd proftpd-mod-crypto
mkdir /srv/ftp/in
ln -s /srv/ftp/in /srv/ftp/incoming
chown ftp /srv/ftp/in /srv/ftp/incoming
```
add the script file to crontab.
