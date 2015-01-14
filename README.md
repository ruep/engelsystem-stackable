# Installation eines [Engelsystems](https://github.com/engelsystem/engelsystem) in Docker

## Vorrausetzungen:

Docker ist installiert und läuft 

## Vorgehen:
Die Files in ein Verzeichnis kopieren und in dem Verzeichnis::

    >>> git clone https://github.com/ruep/engelsystem-stackable.git /engel && cd /engel

    >>> docker run -v /var/lib/mysql --name=engel_datastore -d busybox echo 'Engel Datastore'
    >>> docker build -t ruep/engelssytem-stackable .
    >>> docker run -d -e MYSQL_PASS="<your_password>" --name db --volumes-from engel_datastore -p 3306:3306 tutum/mysql:5.5
    >>> docker run -d --link db:db --name app -e DB_PASS="<your_password>" -p 80:80 ruep/engelssytem-stackable

    >>> vi ~/.msmtprc

    OSX: 
    >>> 

Engelsystem im Browser aufrufen  
Anmeldung mit `admin:asdfasdf` vornehmen. 

## Was nicht funktioniert
* email verschicken

## Probleme?:

Wenn keine Anmeldung erscheint::

    >>> docker ps  
   
Es sollten zwei Container laufen 

Zum starten einer Bash in einen der beiden Container::

    >>> docker exec -i -t <CONTAINER_ID> bash

Der dritte Container beinhaltet nur die Daten.

## Backup 

Ein Verzeichnis backups anlegen::

    >>> docker run -it --rm -v $(pwd):/backups --link=db:db tutum/mysql:5.5 bash
    >>> mysqldump --host $DB_PORT_3306_TCP_ADDR -u admin -p engelsystem > /backups/engelsystem.sql

## Restore

Ins Verzeichnis backups gehen::
    >>> docker run -it --rm -v $(pwd):/backups --link=db:db tutum/mysql:5.5 bash
    >>> mysql -u admin -p -h $DB_PORT_3306_TCP_ADDR engelsystem
    >>> source /backups/engelsystem.sql
