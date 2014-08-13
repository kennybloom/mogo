#!/bin/sh
PATH=/home/cloud/.rbenv/shims:/home/cloud/.rbenv/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/lib/jvm/java-1.7.0-openjdk-amd64
export PATH
cd /home/cloud/applications/mogo 
/home/cloud/.rbenv/shims/rake RAILS_ENV=production mogosync:sync_db 2>&1 >>/home/cloud/applications/mogo/log/sync_db.log
