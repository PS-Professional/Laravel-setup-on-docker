#!/bin/bash
/etc/init.d/apache2 start
cd /etc/apache2/sites-available && a2dissite 000-default.conf && a2ensite app.conf
cd /var/www/html && /etc/init.d/apache2 reload
sleep 2
STATE=0
while [[ $STATE -eq 0 ]]
do
APACHE_STATE=`/etc/init.d/apache2 status | grep 'Active' | sed  's/     //' | cut -f 2 -d ' '`
if [[ $APACHE_STATE -eq active ]]
then
	echo 1 > /dev/null
else
	/etc/init.d/apache2 restart
fi
done
