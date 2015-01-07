#!/bin/sh

WWW_DIR=/var/www/
RUBY=`which ruby`
SENSOR=1
AMD=1

cwd=`dirname "${0}"`
expr "${0}" : "/.*" > /dev/null || cwd=`(cd "${cwd}" && pwd)`

boinccmd --get_tasks | $RUBY ${cwd}/tasklist.rb $WWW_DIR
boinccmd --get_project_status | $RUBY ${cwd}/projectlist.rb $WWW_DIR
if [ $SENSOR -eq 1 ] && [ $AMD -eq 1 ] ; then
	(sensors;  export DISPLAY=:0 ; aticonfig --odgt --adapter=all ) | $RUBY ${cwd}/sensors.rb $WWW_DIR
elif [ $SENSOR -eq 1 ] ; then
	sensors | $RUBY ${cwd}/sensors.rb $WWW_DIR
elif [ $AMD -eq 1 ] ; then
	(export DISPLAY=:0 ; aticonfig --odgt --adapter=all ) | $RUBY ${cwd}/sensors.rb $WWW_DIR
fi
