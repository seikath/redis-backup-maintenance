# redis-backup-maintenance
Redis backup and maintenance script

## INSTALL
- install at /opt/bin:

```bash
test ! -d /opt/bin && mkdir -p /opt/bin && cd /opt/bin && wget https://raw.githubusercontent.com/seikath/redis-backup-maintenance/master/redis.backup.maintenance.sh && chmod +x redis.backup.maintenance.sh
```

## USAGE
- example crontab

```bash
*/15 * * * * /opt/bin/redis.backup.maintenance.sh >> /var/log/redis.backup.log 2>&1
```
- put a line at the /etc/rc.local to unlock the script in case or sudden reboot or shutdown

```bash
test -d /var/run/redis.backup.lock.dir && rm -rf /var/run/redis.backup.lock.dir
```
