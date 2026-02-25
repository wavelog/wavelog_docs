# OpenBSD

This page will guide you through the steps required to install Wavelog onto an OpenBSD web server that is using the OHMP stack (that's OpenBSD, httpd, MariaDB and PHP). Most of the text has been taken from the page [Installation on a FreeBSD Server](https://github.com/wavelog/Wavelog/wiki/Installation-on-a-FreeBSD-Server) and adapted to OpenBSD.

# Prerequisites

* Operating System: [OpenBSD](https://www.openbsd.org/) (tested on OpenBSD 7.2)
* Web server: [httpd](https://man.openbsd.org/httpd)
* Database: [MariaDB](https://mariadb.org)
* [PHP](https://www.php.net) 8.0

# Installation
## 1. Prepare Server Stack

Installing OpenBSD, database server and web server are tasks that are outside the scope of this guide but there are plenty of resources to help you get started. Have a look at this [guide](http://www.h-i-r.net/p/setting-up-openbsd-relayd-based-httpd.html) or at the corresponding man pages.

Once you have your server stack installed, make sure that the required additionally packages are available. Example of installing PHP80 and required packages:

```bash
doas pkg_add php-mysqli mariadb-server curl php-curl
```

Please choose version 8.0 when asked by the installer. 

## 2. Download Wavelog using Git

For ease of installation and updating, it is recommended to acquire the Wavelog application files using [Git](https://git-scm.com/). If GIT is not yet installed on your system use `pkg_add git` to obtain it.

The `git clone` command is used to fetch the latest build of Wavelog from the repository on [GitHub](https://github.com/wavelog/Wavelog). This command downloads the application files in their current state on the _master_ branch:

```bash
doas git clone https://github.com/wavelog/Wavelog.git [output_directory]
```
Replace _output_directory_ with the full path to the directory where you'd like the application files to be created locally (don't include the square brackets). In this example, we use the DocumentRoot directory "/var/www/htdocs/wavelog":

```bash
doas git clone https://github.com/wavelog/Wavelog.git /var/www/htdocs/wavelog
```

## 3. Set Directory Ownership and Permissions

During normal operation, Wavelog will need to write to certain files and directories within the root Wavelog directory (i.e. where you extracted the files in the previous step). You'll need to set the permissions and ownership on these directories appropriately.

The following folders need to be writable by PHP:

* /application/config/
* /application/logs
* /assets/qslcard/
* /backup
* /updates
* /uploads
* /images/eqsl_card_images/


⚠️ **Warning 1**: The following commands assume that you are using the OpenBSD _www_ webserver group. You should verify this is the case and modify the commands below appropriately if it is something different.

⚠️ **Warning 2**: Replace `/var/www/htdocs/wavelog` in the below commands with the appropriate directory if you cloned the Git repository somewhere else in the previous step.

**⚠️ Warning 3**: It is your responsibility to ensure you protect your system from intruders/attacks. These commands and permissions are just examples used to get Wavelog up and running and are not a guide on how to achieve a secure system. You should review these permissions after installation and make appropriate changes if you determine that finer-grained access control is needed.

First, set ownership using:
```bash
doas chown -R root:www /var/www/htdocs/wavelog/application/config/
doas chown -R root:www /var/www/htdocs/wavelog/application/logs
doas chown -R root:www /var/www/htdocs/wavelog/assets/qslcard/
doas chown -R root:www /var/www/htdocs/wavelog/backup
doas chown -R root:www /var/www/htdocs/wavelog/updates
doas chown -R root:www /var/www/htdocs/wavelog/uploads
doas chown -R root:www /var/www/htdocs/wavelog/images/eqsl_card_images/
```

Then grant write permissions on these directories to the group:
```bash
doas chmod -R g+rw /var/www/htdocs/wavelog/application/config/
doas chmod -R g+rw /var/www/htdocs/wavelog/application/logs
doas chmod -R g+rw /var/www/htdocs/wavelog/assets/qslcard/
doas chmod -R g+rw /var/www/htdocs/wavelog/backup
doas chmod -R g+rw /var/www/htdocs/wavelog/updates
doas chmod -R g+rw /var/www/htdocs/wavelog/uploads
doas chmod -R g+rw /var/www/htdocs/wavelog/images/eqsl_card_images/
```

More info about granting PHP write permissions can be read [here](https://unix.stackexchange.com/questions/35711/giving-php-permission-to-write-to-files-and-folders)

## 4. Create a SQL Database and User

Wavelog needs a MySQL database to store application and user settings, along with user data such as logbooks.

We'll cover the basic steps for creating a blank database but we won't go into much detail for the specific steps relating to securing your database server. Please refer to [the MySQL documentation](https://dev.mysql.com/doc/refman/8.0/en/mysql-secure-installation.html) as a starting point.

Anyhow, the following commands will help you set up the database system and perform some first security measures:

```bash
doas /usr/local/bin/mysql_install_db
doas rcctl start mysqld
doas /usr/local/bin/mysql_secure_installation
```

After this, let's start by using the `mysql` command to connect as the _root_ user. If your server is already configured for something else then you may have another user configured with the ability to create databases - you can substitute that username if so. Read more about connecting with the `mysql` client in [the MySQL documentation](https://dev.mysql.com/doc/mysql-getting-started/en/#mysql-getting-started-connecting).

`doas mysql -u root -p`

Now issue the following command to create a database for Wavelog, replacing `db_name` with a name of your choice. Note this name down as you'll need it later for the Wavelog install wizard.

```sql
CREATE DATABASE db_name;
```

Next, create a user and grant it privileges on the Wavelog database. Creating a new user is optional if you already have a valid non-root user on the MariaDB server. Remember to again replace `db_name` with the name you chose previously for the database, `user1` with the name of the user to create and `password1` with a strong password! Keep the username and password safe as you'll need these for the Wavelog install wizard later.

```sql
CREATE USER 'user1'@localhost IDENTIFIED BY 'password1';
GRANT ALL PRIVILEGES ON db_name.* TO 'user1'@'localhost';
QUIT
```

## 5. Make some important file accessible to httpd

OpenBSD's httpd is running inside a chroot and therefore sees '/var/www/' as '/'. This again means that httpd's worker processes can't access files residing in '/etc', for example. We can make these certain files accessible by copying them into the chroot directory. It is probably also possible to link them but this has not been tested by me.

```bash
doas mkdir -p /var/www/etc/ssl
doas cp /etc/ssl/cert.pem /var/www/etc/ssl/
doas cp /etc/resolv.conf /var/www/etc/
doas cp /etc/services /var/www/etc/
```

## Configure PHP and enable modules

We need to configure some items inside the file `/etc/php-8.0.ini` that are required by Wavelog:

Please find and adapt the following line:

```
allow_url_fopen = On
```

Also uncomment the following modules inside the above mentioned file:

```
extension=bz2
extension=curl
extension=mbstring
extension=openssl
```

## 6. Run the Wavelog Install Wizard

You need to run the install wizard. At this point, please open `<url-to-wavelog>/install` and follow the guide.

When you have completed the install wizard, do the following:

* Create a new admin account (Admin Dropdown) and delete the demo account
* Update Country Files (Admin Dropdown)
* Create a station profile (Admin Dropdown) and set it as active

* If you want to know if the person you're working uses LoTW, run: `https://<URL-To-Wavelog>/index.php/lotw/load_users`. This is the initial run, but we'll run this every week from cron momentarily.

# Post-Install Tasks

The OpenBSD install tutorial ends here and refers to the probably more regularily updated [Linux Installation Guide](https://github.com/wavelog/Wavelog/wiki/Installation) for the post-install tasks.