# redis-backup-maintenance
Redis backup and maintenance script

## INSTALL


## USAGE
- example crontab

(*/15 * * * * /opt/bin/redis.backup.maintenance.sh >> /var/log/redis.backup.log 2>&1)
- put a line at the /etc/rc.local to unlock the script 

(test -d /var/run/redis.backup.lock.dir && rm -rf /var/run/redis.backup.lock.dir)
