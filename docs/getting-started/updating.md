## Before Updating

Before doing an update on your Wavelog-installation please make a backup of your existing installation. During the update-process some configuration-files could be reset to defaults so you have a backup to reenter your settings into the new configuration-file.

This is **NOT** how to Migrate from Cloudlog to Wavelog. If you're still using Cloudlog go to [this Wiki Page](../getting-started/migration/cloudlog-to-wavelog.md)

## Update Process

### Updating via docker

To update Wavelog to the latest version, run the following from your `docker-compose.yml` folder:

```bash
docker compose pull
docker compose down
docker compose up -d
```

This downloads the new image, stops the stack and restarts everything. Your data in the volumes is not affected.

#### Updating via Portainer

If you are using Portainer to manage your docker containers:  
Go to **Stacks**, select the Wavelog stack, click **Editor** → **Deploy** and enable "Pull latest image" in the dialog.

### Updating via `git pull`

When you installed Wavelog with `git clone` on a linux server you can use the `git` mechanism to update your existing installation. You should always prefer this way, as it's way faster and more secure.

1. Enter the webdirectory where Wavelog is installed (e.g. `/var/www/html`)

```bash
cd /var/www/html
```

1. Enter the git command

```bash
git pull
```

1. You may have to reset your file ownerships

```bash
chown -R www-data:www-data /var/www/html
```

1. Reload the Page in Webbrowser
    - You should see the Version Dialog which shows you the Release Notes of the latest release.
    - Check the Version in `ADMIN > DEBUG`. You should now see the correct version here aswell.

### Updating via `zip`-File

When using Wavelog on a Hosted Webspace you may have no access to a command line. Then you need to update your Wavelog-Installation with a downloaded `zip`-File. Follow this Step by Step to do a proper update.

1. Create a FULL Backup of your whole Installation. This includes the whole webroot folder and the database.
2. If you not downloaded already the existing webroot folder in step 1, do this now (and may rename it to `Wavelog-OLD`. You will need to copy some files to the new folder.
3. Download the latest Release of Wavelog as a `zip` file: [https://github.com/wavelog/wavelog/releases](https://github.com/wavelog/wavelog/releases)
4. Unzip the downloaded `zip` file on your computer. You'll need to replace some files from the downloaded folder in step 2.
5. Copy the following files and folders from the existing installation to the new folder.
    - File: `application/config/config.php`
    - File: `application/config/database.php`

    - if `$config['userdata'] = "userdata";` was **DISABLED** in your old installation ([more info](../admin-guide/configuration/centralized-userdata.md)
      - Folder: `assets/qslcard/`
      - Folder: `images/eqsl_card_images/`
    - if `$config['userdata'] = "userdata";` was **ENABLED** in your old installation
      - Folder: `userdata/`   (or the folder which was configured and where the userdata is stored)

    - if exists:
      - File: `assets/js/sections/custom.js`  

6. Delete the folder `install/` in the new folder.
7. Now you can upload the new folder which contains all necessary files and folders mentioned above to your webspace.
8. Reload the Page in Webbrowser
    - You should see the Version Dialog which shows you the Release Notes of the Version you've downloaded in Step 3
    - Check the Version in `ADMIN > DEBUG`. You should now see the correct version here aswell.
