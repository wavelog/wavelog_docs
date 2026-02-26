# DietPi Installation & Wavelog requirements installation

Wavelog has been tested on a Raspberry Pi Zero W, Raspberry Pi 3 and a 4B. It can be installed in the normal manner described in the Linux installation. A variation is to use the DietPi distribution which can automate many of the installation steps for you.

DietPi is a minimal, command line OS based on Debian that uses a menu system for the installation of common software that runs on SBC’s like the Raspberry Pi. An items, such as a webserver, is selected and then it is installed automatically. Many of the additional steps are removed for you so it can simplify the process. There are packages for CertBot and NoIP which can help if you are planning on hosting this yourself with your own domain name rather than using a hosting provider.

## Download and Install DietPi

Follow the installation instructions on the [Diet Pi Website](https://dietpi.com/docs/install/). There is a graphical method as well. The installation should take around 30 minutes. It is recommended that if this is your first time using a RPi and you are unfamiliar with terms like ssh and the command line then refer to the Raspberry Pi official documentation. It is preferred that you connect up a keyboard and display for your first set up. That way it is easier to understand what is going on. This guide assumes you have both the keyboard and display set up. More experienced users can complete this through ssh.

## Install the Webserver

* Type `dietpi-software` at the command prompt. this will bring up a series of options.
* Select `Browse Software`
* Navigate down the page and select `LAMP` (apache + mariadb + php)
* Exit (This will take you to the previous screen)
* Select `install software` and follow any on screen prompts

Whilst we are in this screen it is worth considering an FTP server and NoIP (If you plan on having your own domain or custom domain). Applications like Filezilla can make access and maintenance easier through FTP if you are less familiar

## Installation

Installation is all automatic. Go and have a cup of tea. Once it has finished  it will invariably ask for a reboot. Do as it says and you’ll have your Webserver, Database and PHP installed (plus everything else you asked for).

## Wavelog installation

## Install git

* sudo apt-get install git
* cd /var/www
* git clone --depth 1 <https://github.com/wavelog/wavelog.git> wavelog

## Adjust folder rights

* directory=/var/www/wavelog
* sudo chown -R www-data:www-data $directory

## Change permissions of directories and files

* sudo find $directory -type d -exec chmod 755 {} \;
* sudo find $directory -type f -exec chmod 664 {} \;

## Create mysql user

* sudo mysql -u root
* CREATE USER 'wavelog'@'localhost' IDENTIFIED BY 'password';
* GRANT ALL PRIVILEGES ON wavelog.* TO 'wavelog'@'localhost';
* FLUSH PRIVILEGES;
* EXIT;

Go to the usual [linux installation](../installation/linux.md) and follow point 5 and 6.
