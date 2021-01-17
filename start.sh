#!/bin/bash
/etc/init.d/apache2 start
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
