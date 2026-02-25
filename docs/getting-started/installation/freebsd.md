# FreeBSD

This page will guide you through the steps required to install Wavelog onto a FreeBSD web server that is using the FAMP stack (that's FreeBSD, Apache, MySQL, and PHP). The installation procedure does also apply for installing Wavelog in a Jail.

# Prerequisites

* Operating System: [FreeBSD](https://www.freebsd.org/) >= 12
* Web server: Apache >= 2.4 or Nginx >= 1.20
* Database: [MySQL](https://www.mysql.com) or [MariaDB](https://mariadb.org)
* [PHP](https://www.php.net) >= 8.0 plus modules:
  * php-ctype
  * php-curl
  * php-dom
  * php-filter
  * php-gd
  * php-mbstring
  * php-mysqli
  * php-session
  * php-simplexml
  * php-xml
  * php-zip
  * php-zlib

# Installation
## 1. Prepare Server Stack

Installing FreeBSD, database server and web server are tasks that are outside the scope of this guide but there are plenty of resources to help you get started. Have a look at this guide from HowtoForge to set up a [FAMP stack](https://www.howtoforge.com/install-apache-php-mysql-on-freebsd-12/) or a [FEMP stack](https://www.howtoforge.com/how-to-setup-femp-stack-nginx-mysql-php-on-freebsd-12/). Most steps are also valid voor FreeBSD 13 and PHP-8.

Once you have your server stack installed, make sure that the required PHP modules are available as not all will be installed by default. Example of installing PHP81 and required modules:

```bash
pkg install php81 php81-ctype php81-curl php81-filter php81-mbstring php81-mysqli php81-session php81-simplexml php81-xml php81-zip php81-zlib
```

You should replace the version number in the above command using the highest version number provided by your distribution and matching the installed version of PHP. Use ```php -v``` to check the installed version. 

## 2. Download Wavelog using Git

For ease of installation and updating, it's recommended to acquire the Wavelog application files using [Git](https://git-scm.com/). If GIT is not yet installed on your system use `pkg install git` to obtain it.

The `git clone` command is used to fetch the latest build of Wavelog from the repository on [GitHub](https://github.com/wavelog/Wavelog). This command downloads the application files in their current state on the _master_ branch:

```bash
git clone https://github.com/wavelog/Wavelog.git [output_directory]
```
Replace _output_directory_ with the full path to the directory where you'd like the application files to be created locally (don't include the square brackets). 
* For an Apache server: If you configured Apache with a site that uses /usr/local/www/apache24/data as its DocumentRoot directory then the command becomes `git clone https://github.com/wavelog/Wavelog.git /usr/local/www/apache24/data`. Have a look at the [Apache documentation](https://httpd.apache.org/docs/2.4/vhosts/examples.html) for more information on site configuration. 
* For a Nginx server: If you configured Nginx with a site that uses /usr/local/www/nginx as its root directory then the command becomes `git clone https://github.com/wavelog/Wavelog.git /usr/local/www/nginx`. For more information about configureing Nginx, see [Nginx documentation](https://nginx.org/en/docs/),

## 3. Set Directory Ownership and Permissions

During normal operation, Wavelog will need to write to certain files and directories within the root Wavelog directory (i.e. where you extracted the files in the previous step). You'll need to set the permissions and ownership on these directories appropriately.

The following folders need to be writable by PHP:

* /application/config/
* /application/logs/
* /assets/qslcard/
* /backup/
* /images/eqsl_card_images/
* /updates/
* /uploads/

⚠️ **Warning 1**: The following commands assume that you are using the FreeBSD _www_ webserver group. You should verify this is the case and modify the commands below appropriately if it is something different.

⚠️ **Warning 2**: Replace `/usr/local/www/apache24/data` in the below commands with the appropriate directory if you cloned the Git repository somewhere else in the previous step or if you are using a Nginx webserver!

**⚠️ Warning 3**: It is your responsibility to ensure you protect your system from intruders/attacks. These commands and permissions are just examples used to get Wavelog up and running and are not a guide on how to achieve a secure system. You should review these permissions after installation and make appropriate changes if you determine that finer-grained access control is needed.

First, set ownership using:
```bash
sudo chown -R www:www /usr/local/www/apache24/data/application/config/
sudo chown -R www:www /usr/local/www/apache24/data/application/logs/
sudo chown -R www:www /usr/local/www/apache24/data/assets/qslcard/
sudo chown -R www:www /usr/local/www/apache24/data/backup/
sudo chown -R www:www /usr/local/www/apache24/data/images/eqsl_card_images/
sudo chown -R www:www /usr/local/www/apache24/data/updates/
sudo chown -R www:www /usr/local/www/apache24/data/uploads/
```

Then grant write permissions on these directories to the group:
```bash
sudo chmod -R g+rw /usr/local/www/apache24/data/application/config/
sudo chmod -R g+rw /usr/local/www/apache24/data/application/logs/
sudo chmod -R g+rw /usr/local/www/apache24/data/assets/qslcard/
sudo chmod -R g+rw /usr/local/www/apache24/data/backup/
sudo chmod -R g+rw /usr/local/www/apache24/data/images/eqsl_card_images/
sudo chmod -R g+rw /usr/local/www/apache24/data/updates/
sudo chmod -R g+rw /usr/local/www/apache24/data/uploads/
```

More info about granting PHP write permissions can be read [here](https://unix.stackexchange.com/questions/35711/giving-php-permission-to-write-to-files-and-folders)

## 4. Create a SQL Database and User

Wavelog needs a MySQL database to store application and user settings, along with user data such as logbooks.

The basic steps for creating a blank database are very similar for both MySQL and MariaDB - we'll cover those here - but the specific steps relating to securing your database and server will differ. As with the Apache configuration, those latter steps are outside the scope of this guide but you can refer to [the MariaDB documentation](https://mariadb.com/kb/en/mysql_secure_installation/) or [the MySQL documentation](https://dev.mysql.com/doc/refman/8.0/en/mysql-secure-installation.html) as a starting point.

Let's start by using the `mysql` command to connect as the _root_ user. If your server is already configured for something else then you may have another user configured with the ability to create databases - you can substitute that username if so. Read more about connecting with the `mysql` client in [the MySQL documentation](https://dev.mysql.com/doc/mysql-getting-started/en/#mysql-getting-started-connecting).

`sudo mysql -u root -p`

**Note**: The `mysql` tool has the same name in both the MySQL and MariaDB packages.

Now issue the following command to create a database for Wavelog, replacing `db_name` with a name of your choice. Note this name down as you'll need it later for the Wavelog install wizard.

```sql
CREATE DATABASE db_name;
```

Next, create a user and grant it privileges on the Wavelog database. Creating a new user is optional if you already have a valid non-root user on the MySQL/MariaDB server. Remember to again replace `db_name` with the name you chose previously for the database, `user1` with the name of the user to create and `password1` with a [real, strong password](https://www.lastpass.com/password-generator)! Keep the username and password safe as you'll need these for the Wavelog install wizard later.

```sql
CREATE USER 'user1'@localhost IDENTIFIED BY 'password1';
GRANT ALL PRIVILEGES ON db_name.* TO 'user1'@'localhost';
QUIT
```

## 5. Run the Wavelog Install Wizard

You need to run the install wizard. At this point, please open `<url-to-wavelog>/install` and follow the guide.

When you have completed the install wizard, do the following:

* Create a new admin account (Admin Dropdown) and delete the demo account
* Update Country Files (Admin Dropdown)
* Create a station profile (Admin Dropdown) and set it as active

* If you want to know if the person you're working uses LoTW, run: `https://<URL-To-Wavelog>/index.php/lotw/load_users`. This is the initial run, but we'll run this every week from cron momentarily.

# Post-Install Tasks
## 1. Create a Bash Script to Update Wavelog using Git

Create a shell script file on the command line with `nano wavelog.sh`, or your preferred editor.

Paste the following into the new file:

```bash
#!/usr/local/bin/bash
cd <Full-Path-To-Wavelog-Folder> && git pull

chown -R www:www <Full-Path-To-Wavelog-Folder>
```

**Note** This example uses bash as the shell but other shells as csh or tcsh can also be used.

The full path should be an absolute path, relative to the root filesystem. Do not enter a relative path here.

Allow the shell script file to be executed:

`chmod +x wavelog.sh`

You can test it with `./wavelog.sh`

## 2. Create Cron Jobs to Automate Wavelog Tasks
You can use cron jobs to automate some of the regular Wavelog maintenance tasks. See [[Recommended Cron Jobs and Cronmanager]] for instructions.

## 3. Set-up Callbook Integration

Wavelog supports two amateur radio callbooks, these being QRZ and HamQTH both setups are similar and require you to edit the `application/config/config.php` file.

Make sure your username and password is the password you use to login to either service.

### QRZ

```php
$config['callbook'] = "qrz";
$config['qrz_username'] = "";
$config['qrz_password'] = "";
```
### HamQTH

```php
$config['callbook'] = "hamqth";
$config['hamqth_username'] = "";
$config['hamqth_password'] = "";
```
You can find more information on callbook integration at [https://github.com/wavelog/Wavelog/wiki/Callsign-Lookup](https://github.com/wavelog/Wavelog/wiki/Callsign-Lookup)