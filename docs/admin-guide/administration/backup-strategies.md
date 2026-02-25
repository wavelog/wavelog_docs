## Backup-Strategies

Wavelog itself uses some files and a lot of Database-Things to keep the data. Currently there's no explicit "Backup-Tool" integrated within Wavelog. But nevertheless there are possibilities to keep ur Data safe in case of desasters.

### Backup as a User

Simply export your ADIF-Files from time to time. This is the heart of your private Log. So it's always a good idea to keep a local copy of that from time to time. ADIF-Export can be done via the User-Menu (upper right) and then ADIF-Import/Export.
Keep in mind that the ADIF doesn't contain your eQSL-Images nor your scanned QSL-Images. At this moment there's no option to export them as a User.

### Backup as instance-Owner (strongly recommended)

There are many ways to Backup your whole system. We will describe _one_ solution, knowing that this isn't 100% safe. But it should fit most of the needs for a normal instance. Cons are listed below.

#### Backupninja

* Install [backupninja](https://0xacab.org/liberate/backupninja) on your system. The Debian way:
```
sudo apt install backupninja
```

* configure Backupninja. Simply add a file called `10-wavelog.mysql` located at `/etc/backup.d/` with the following content: Please replace the Strings within the brackets with the infos from your instance:

```
databases   = [[all] or [name of your wavelog_db]]
backupdir   = /var/backups/mysql
hotcopy     = no
sqldump     = yes
compress    = yes
configfile = /etc/mysql/debian.cnf
sqldumpoptions= --skip-lock-tables
dbusername = [root or username for your wavelog-db]
dbpassword = [password for the above user]
```

* Have a look at `/etc/backupninja.conf` to set times and so on.

From this moment on the Database will be dumped every night (or whatever you set at `/etc/backupninja.conf`) into `/var/backups/mysql`. That DB-Backup will be consistent in itself. The DB may NOT be consistent to Userfiles like Images, if a user uploads QSL-Images during the backup. 

#### Duplicity
Putting duplicity on top to backup the Files (including the QLS-Images/eQSL-Images/DB-Dump and more) to any Service you like (and duplicity supports) is a good idea. you can also use rsync for that

todo: Short-Tutorial for duplicity and triggering backupninja from duplicity
todo: Recovery

##### Conclusio:

I am using this for about 2 years now, and never had a problem. But - tbh - it's no "Enterprise-Backup". If you are running a business (or sth. else which is very important) with Wavelog you should consider other Backup-methods like zfs-snapshots, LVM-Snapshots or Enterprise SANs. Due to the reason that this is not really Wavelog related, but more linux-admin-related we will not provide an "Admin-Tutorial" or sth. like that.
And yes, we know that this strategy doesn't fit all environments like "el-cheapo-Hosters" with only FTP-Access. But as always in life: If you want enterprise-feeling you should use a root-Server like a VPS or sth. like that.