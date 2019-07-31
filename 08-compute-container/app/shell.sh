#!/bin/bash
trap "exit" INT
while :
do
	/etc/init.d/nginx start
	uwsgi --ini app.ini
	/bin/bash
done