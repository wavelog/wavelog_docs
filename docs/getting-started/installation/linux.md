# Linux

This page will guide you through the steps required to install Wavelog onto a Linux web server that is using the LAMP stack (that's Linux, Apache, MySQL, and PHP). The specifics of your server setup can be largely up to you as there are various Linux distributions, for example. This guide will focus on [Debian](https://www.debian.org) / [Ubuntu](https://ubuntu.com) so instructions given here may not apply to other distributions.

## Prerequisites

* Any modern Linux installation capable of supporting the other prerequisities.
  * Recommended:
    * Debian 11 or 12
    * Ubuntu 22.04

* Web server (e.g. Apache >= 2.4 or nginx)
* [MySQL](https://www.mysql.com) or [MariaDB](https://mariadb.org)
  * InnoDB has to be available and set as default engine
* [PHP](https://www.php.net) <= 8.2 plus modules (8.3 seems to work without issues):
  * php-curl
  * php-mbstring
  * php-mysql
  * php-xml
  * php-zip
  * php-gd
  * php-redis (if you want to use redis as cache-provider)

* Of course a web browser.
  * Absolute minimum resolution for viewport: 1024x768 (no official support!)
  * Recommended minimum resolution of the browser viewport: >=HD

## Installation

### 1. Prepare LAMP Stack

#### Debian

Installing a suitable operating system, database server and web server are tasks that are outside the scope of this guide but there are plenty of resources to help you get started. Have a look at these guides from DigitalOcean to set up either [Debian](https://www.digitalocean.com/community/tutorials/how-to-install-linux-apache-mariadb-php-lamp-stack-on-debian-11/) or [Ubuntu LTS](https://www.digitalocean.com/community/tutorials/how-to-install-linux-apache-mysql-php-lamp-stack-on-ubuntu-22-04/).

**Once you have your LAMP stack installed**, make sure that the required PHP modules are available as not all will be installed by default:

```bash
sudo apt install php-curl php-mysql php-mbstring php-xml php-zip php-gd php-apcu
```

If you use Apache2 as Webserver you maybe need aswell

```bash
sudo apt install libapache2-mod-php
```

Use ```php -v``` to check the installed version. Minimum Version is PHP 7.4

!!! note
    ### nginx configuration
    If you use nginx as web server you will need to make sure that the PHP handler does serve .php correctly and not only if the address ends on `.php`. See <a href="https://github.com/magicbug/cloudlog/issues/1613" target="_blank">this issue</a>. The basic change in the config is (remove the dollar sign):

    ```conf
     # pass PHP scripts to FastCGI server
     #
    - location ~ \.php$ {
    + location ~ \.php {
    ```
    ⚠️ After you have changed this value restart the nginx web server before continuing the installation.

#### Arch Linux / Manjaro Linux

```bash
# to install the LNMP stack and dependencies, you can run this command
sudo pacman -S git nginx php-fpm php-gd php-apcu php mariadb
# this will initialize mariadb - do not execute it if you have already databases running!
mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
# restart mariadb
systemctl restart mariadb
```

edit /etc/php/php.ini and uncomment the following lines

```php
extension=gd
extension=mysqli
```

### 2. Download Wavelog using Git

For ease of installation and updating, it's recommended to acquire the Wavelog application files using [Git](https://git-scm.com/). Git is most likely installed already on your Linux distribution. If not, use `sudo apt-get install git` to obtain it.

The `git clone` command is used to fetch the latest build of Wavelog from the repository on [GitHub](https://github.com/wavelog/Wavelog). The `--depth 1` option reduces the amount of data which is downloaded (you usually don't need the full commit history) This command downloads the application files in their current state on the `master` branch:

```bash
git clone --depth 1 https://github.com/wavelog/wavelog.git [output_directory]
```

Replace _output_directory_ with the full path to the directory where you'd like the application files to be created locally (don't include the square brackets). For example, if you configured Apache with a site that uses `/var/www/html` as its DocumentRoot directory then the command becomes  
`git clone --depth 1 https://github.com/wavelog/wavelog.git /var/www/html`  
Have a look at the [Webserver Configurations](../../admin-guide/configuration/webserver.md) for more information on site configuration.

### 3. Set Directory Ownership and Permissions

During normal operation, Wavelog will need to write to certain files and directories within the root Wavelog directory (i.e. where you extracted the files in the previous step). You'll need to set the permissions and ownership on these directories appropriately.

The following folders need to be writable by PHP:

* /application/config/
* /application/logs/
* /backup/
* /updates/
* /uploads/
* /images/eqsl_card_images/

⚠️ **Warning 1**: The following commands assume that you are using the Ubuntu/Debian default _www-data_ webserver group. You should verify this is the case - especially if you are using another distribution - and modify the commands below appropriately if it is something different.

⚠️ **Warning 2**: Replace `/var/www/html` in the below command with the appropriate directory if you cloned the Git repository somewhere else in the previous step!

**⚠️ Warning 3**: It is your responsibility to ensure you protect your system from intruders/attacks. These commands and permissions are just examples used to get Wavelog up and running and are not a guide on how to achieve a secure system. You should review these permissions after installation and make appropriate changes if you determine that finer-grained access control is needed.

Set the basic permissions (work in most cases). Don't forget to adjust the directory:

```bash
directory=/var/www/html

# debian
sudo chown -R www-data:www-data $directory
# arch linux / manjaro linux
sudo chown -R http:http $directory

# change permissions of directories and files
sudo find $directory -type d -exec chmod 755 {} \;
sudo find $directory -type f -exec chmod 664 {} \;
```

These permissions may differ on your setup!

### 4. Create a SQL Database and User

Wavelog needs a MySQL database to store application and user settings, along with user data such as logbooks.

The basic steps for creating a blank database are very similar for both MySQL and MariaDB - we'll cover those here - but the specific steps relating to securing your database and server will differ. As with the Apache configuration, those latter steps are outside the scope of this guide but you can refer to [the MariaDB documentation](https://mariadb.com/kb/en/mysql_secure_installation/) or [the MySQL documentation](https://dev.mysql.com/doc/refman/8.0/en/mysql-secure-installation.html) as a starting point.

Let's start by using the `mysql` command to connect as the _root_ user. If your server is already configured for something else then you may have another user configured with the ability to create databases - you can substitute that username if so. Read more about connecting with the `mysql` client in [the MySQL documentation](https://dev.mysql.com/doc/mysql-getting-started/en/#mysql-getting-started-connecting).

MySQL: `sudo mysql -u root -p`

MariaDB: `sudo mariadb -u root -p`

Now issue the following command to create a database for Wavelog, replacing `db_name` with a name of your choice, e.g. `wavelog`. Note this name down as you'll need it later for the Wavelog install wizard.

```sql
CREATE DATABASE db_name;
```

Next, create a user and grant it privileges on the Wavelog database. Creating a new user is optional if you already have a valid non-root user on the MySQL/MariaDB server. Remember to again replace `db_name` with the name you chose previously for the database, `user1` with the name of the user (e.g. `waveloguser`) to create and `password1` with a [real, strong password](https://www.lastpass.com/password-generator)! Keep the username and password safe as you'll need these for the Wavelog installer later.

```sql
CREATE USER 'user1'@localhost IDENTIFIED BY 'password1';
GRANT ALL PRIVILEGES ON db_name.* TO 'user1'@'localhost';
QUIT
```

### 5. Configure the Webserver

Configure the webserver of your choice according to the [webserver configuration](../../admin-guide/configuration/webserver.md) page.

### 6. Run the Wavelog Installer

You need to run the installer. At this point, please open `<url-to-wavelog>/install` and follow the guide.

* If you want to know if the person you're working uses LoTW, run: `https://<URL-To-Wavelog>/index.php/update/lotw_users`. This is the initial run, but we'll run this every week from cron momentarily.

## Post-Install Tasks

### Create Cron Jobs to Automate Wavelog Tasks

You can use cron jobs to automate some of the regular Wavelog maintenance tasks. See [Recommended Cron Jobs and Cronmanager](../../admin-guide/administration/cron-jobs.md) for instructions.

After your first login you have to set up some things in Wavelog. Just follow the warnings on the dashboard.
