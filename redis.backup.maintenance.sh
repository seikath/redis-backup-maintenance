#!/bin/bash                                                                                                                                                                                                                                   
## Fri, 07 Aug 2015 12:12:57 +0300                                                                                                                                                                                                            
## redis backup every 15 minutes                                                                                                                                                                                                              
##*/15 * * * * /opt/bin/redis.backup.sh >> /var/log/redis.backup.log 2>&1                                                                                                                                                                     
##                                                                                                                                                                                                                                            

#redis-cli LASTSAVE | awk '{print $1}' | { read gmt ; date "+%Y-%m-%d %H:%M:%S" -d "@$gmt" ; }                                                                                                                                                
# 2015-08-07 01:25:54                                                                                                                                                                                                                         

lockf="/var/run/redis.backup.lock.dir"

# check for running script start                                                                                                                                                                                                              
if [ -d "${lockf}" ]
then
    echo "$(date +%Y-%m-%d.%H.%M.%S) : ${lockf} exists, exiting"
    exit 0
else
    mkdir "${lockf}" && echo "$(date +%Y-%m-%d.%H.%M.%S) : created lock at ${lockf}"
fi


echo "$(date +%Y-%m-%d.%H.%M.%S) : redis backup start"
echo "$(date +%Y-%m-%d.%H.%M.%S) : cleanup the /redis_backups and leave the last 6 backups"
#find /redis_backups -maxdepth 1 -type f -name "dump.rdb.*" | sort -r | sed '6,$!d' | while read to_be_deleted; do rm -fvv {$to_be_deleted};done                                                                                              
find /redis_backups -maxdepth 1 -type f -name "dump.rdb.*" | sort -r | sed '7,$!d' | while read to_be_deleted; do rm -f ${to_be_deleted} && echo "$(date +%Y-%m-%d.%H.%M.%S) : deleted ${to_be_deleted}";done

last_save=$(redis-cli LASTSAVE | awk '{print $1}')
echo -n "$(date +%Y-%m-%d.%H.%M.%S) : executing redis-cli BGSAVE : "
redis-cli BGSAVE
while true
do
    if [ $(redis-cli LASTSAVE | awk '{print $1}') -eq ${last_save}  ]
    then
        echo -n ". "
        sleep 2
    else
        echo ""
        echo "$(date +%Y-%m-%d.%H.%M.%S) : start ionice -c2 -n0 cp -vv /opt/redis/dump.rdb to /redis_backups/"
        ionice -c2 -n0 cp -vv /opt/redis/dump.rdb  /redis_backups/dump.rdb.$(date +%Y-%m-%d.%H.%M.%S) && echo "$(date +%Y-%m-%d.%H.%M.%S) : backup comleted"
        break
    fi
done


if [ -d "${lockf}" ]
then
    echo "$(date +%Y-%m-%d.%H.%M.%S) : removing the lock"
    rm -rf "${lockf}"
fi


