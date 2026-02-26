## Instance-Backup

To Backup your whole instance, we recommend two things:
1.) Database Backup
2.) Filesystem Backup.

Here is an **example** how you can do that, if you're on a linux-Machine like Debian/Ubuntu:

`apt install borgbackup backupninja`

Create two files at `/etc/backup.d`:
First one: `10-db.mysql`:

```conf
### backupninja mysql config file ###

databases   = all
backupdir   = /var/backups/mysql
hotcopy     = no
sqldump     = yes
compress    = yes
configfile = /etc/mysql/debian.cnf
sqldumpoptions= --skip-lock-tables
dbusername = [root_at_db]
dbpassword = [root_pass]
dbhost = 127.0.0.1
```

Second one: `90.borg`:

```conf
## for more options see
## - example.borg
## - http://borgbackup.readthedocs.io/en/stable

[source]
include = /var/spool/cron/crontabs
include = /var/backups
include = /var/www

## for more info see : borg prune -h
prune = yes
keep = "15d"

[dest]
directory = /backup/my_wavelog
host = localhost
port = 22
user = root
archive = {now:%Y-%m-%dT%H:%M:%S}
compression = lz4
encryption = none
passphrase =
```

After you've done that, your system creates a full-backup of database, wavelog and it's (e)QSL-Cards and so on every night at 01:00.

The backup will be stored at `/backup/my_wavelog`. you can access it via `borg mount /backup/my_wavelog /mnt` easily.

After mounting you've the last 15days in subfolders in `/mnt`. Don't forget to umount (`borg umount /mnt`) after restoring it.

For more informations about the toolchain have a look at backupninja and borgbackup.

This is only one way / one example for a backupsolution.

## Docker-Backup manually

A manual backup of your docker container is quite easy. To make sure data is consistent we have to stop the container first.

```bash
sudo docker compose down
```

In the next step we define the backup path and making sure it exists.**Don't run this command as root**

```bash
BACKUP_DIR=/home/$USER/wavelog_backup
mkdir -p $BACKUP_DIR
```

Now we can copy the data. We make a copy of the docker compose file and compress the docker volumes into a tar.gz file

```bash
cp docker-compose.yml $BACKUP_DIR/
sudo tar czf "$BACKUP_DIR/wavelog_volumes_$(date +%F).tar.gz" -C /var/lib/docker/volumes $(sudo find /var/lib/docker/volumes -maxdepth 1 -type d -name 'wavelog*' -printf '%f\n')
```

To restore a backup copy the docker compose file and decompress the tar.gz file

```bash
sudo tar xzf wavelog_volumes_2025-04-30.tar.gz -C /var/lib/docker/volumes
```

## Docker SQL Dump

Dump

```bash
docker exec wavelog-db mariadb-dump -u [DB_USER] -p'[DB_PASS]' [DB_NAME] > wavelog_backup.sql
```

Restore

```bash
docker exec -i wavelog-db mariadb -u [DB_USER] -p'[DB_PASS]' [DB_NAME] < wavelog_backup.sql
```

## Docker-Backup with Borg

This is another backup method that stops the docker containers before the backup and restarts them after the backup is done to ensure the integrity of the database. Stopping the container is essential to avoid data loss.
Change the values according to your needs and put the file into `/etc/borgmatic/wavelog.yaml`:

```yaml

source_directories:
    - /home/phil/docker/wavelog
    - /var/lib/docker/volumes/wavelog*

# A required list of local or remote repositories with paths and
# optional labels (which can be used with the --repository flag to
# select a repository). Tildes are expanded. Multiple repositories are
# backed up to in sequence. Borg placeholders can be used. See the
# output of "borg help placeholders" for details. See ssh_command for
# SSH options like identity file or port. If systemd service is used,
# then add local repository paths in the systemd service file to the
# ReadWritePaths list. Prior to borgmatic 1.7.10, repositories was a
# list of plain path strings.
repositories:
    - path: ssh://user@host:22/./borgmatic/docker-wavelog
      label: backupserver

# Passphrase to unlock the encryption key with. Only use on
# repositories that were initialized with passphrase/repokey/keyfile
# encryption. Quote the value if it contains punctuation, so it parses
# correctly. And backslash any quote or backslash literals as well.
# Defaults to not set.
# encryption_passphrase: "!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~"
encryption_passphrase: changeme

# Keep all archives within this time interval.
# keep_within: 3H

# Number of secondly archives to keep.
# keep_secondly: 60

# Number of minutely archives to keep.
# keep_minutely: 60

# Number of hourly archives to keep.
# keep_hourly: 24

# Number of daily archives to keep.
keep_daily: 31

# Number of weekly archives to keep.
# keep_weekly: 4

# Number of monthly archives to keep.
keep_monthly: 6

# Number of yearly archives to keep.
keep_yearly: 1

# Stop docker container before backup to ensure database integrity; restart containers after backup.
before_backup:
  - docker compose -f /home/phil/docker/wavelog/docker-compose.yml down
after_backup:
  - docker compose -f /home/phil/docker/wavelog/docker-compose.yml up -d
```

Then add a systemd timer file (`/etc/systemd/system/borgmatic-wavelog.timer`) that schedules the backups. I run them at 04:20 and 15:30 each day:

```conf
[Unit]
Description=Run Borgmatic Backup for wavelog

[Timer]
OnCalendar=*-*-* 04:20:00
OnCalendar=*-*-* 15:30:00
Persistent=true

[Install]
WantedBy=timers.target
```

Reload systemd to apply the timer: `sudo systemctl daemon-reload`
