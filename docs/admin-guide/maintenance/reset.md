# Reset your Wavelog Installation

!!! danger "Hold on a second!"
    This action is irreversible. Make sure you have a backup of your data if you want to keep it before proceeding.
    This will delete all your data and reset your Wavelog installation to a clean state. Make sure to back up any important data before proceeding.

## Docker

To reset your Wavelog installation in a docker environment, you can simply remove the existing containers and volumes. This will delete all your data and configurations, so make sure to back up anything important before proceeding. You can do this with the following commands:

```bash
# Stop and remove the containers
docker compose down --volumes
```

This command will stop the running containers and remove them along with the associated volumes, effectively resetting your Wavelog installation to a clean state. After running this command, you can start fresh by running `docker compose up` again.

## Manual Installation

To reset a manual installation of Wavelog, you need to delete the following folders and files from your server:

```bash
# Drop the database (replace 'wavelog' with your actual database name)
mysql -u [username] -p -e "DROP DATABASE wavelog; CREATE DATABASE wavelog;"

# Remove configuration files and installation lock
cd /path/to/wavelog
rm -rf application/config/config.php
rm -rf application/config/database.php
rm -f install/.lock
```

This will remove your configuration files and the installation lock, allowing you to run the installer again and set up Wavelog from scratch. Make sure to back up any important data before deleting these files, as this action cannot be undone. This won't delete things like debug logs, updated source files or images in ./userdata (QSL Cards and eQSL card). If you want to completely reset everything, we suggest to delete the whole Wavelog folder and start with a fresh copy of the source code like you did during the initial [installation](../installation/).