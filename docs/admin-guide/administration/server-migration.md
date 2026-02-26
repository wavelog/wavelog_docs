# Server Migration

!!! note
    This is for non-docker installs.

If you want to move your wavelog instance to another server, and maintain all your information, one method is as follows:

1. Dump the database to a file using:

`mysqldump -u your_db_user -p your_db_name > wavelog_backup.sql`

1. Copy this backup file to the new server

2. Install a fresh instance of Wavelog, following the [instructions](../../getting-started/installation/linux.md). This will involve setting up a new database, and running the `/install` script. Don't create/copy a config.php yet.

3. Load your database dump into your new database on the new server:

`mysql -u your_db_user -p your_db_name < /path/to/wavelog_backup.sql`

1. Edit your config.php if you had anything extra compared to a normal install.

If you can't remember your mysql username or database name from the old server you can use these commands to find them out:

```sql
# log in
sudo mysql -u root -p

# Show databases
SHOW DATABASES;

# Show users
SELECT User, Host FROM mysql.user;
```
