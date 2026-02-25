# Dear Cloudlog Users

!!! info "READ THIS BEFORE YOU START"

Since early 2024 we offered a tutorial here on how to migrate an existing Cloudlog installation to Wavelog. This worked well for a long time. However, as both projects have evolved independently, the codebases have diverged to a point **where a clean migration can no longer be guaranteed.**

We therefore strongly recommend against using this tutorial and instead suggest performing a fresh Wavelog installation using one of the guides in this Wiki, then manually importing your QSOs, settings and station setups. Yes, it requires a bit more effort — but you'll end up with a clean, performant Wavelog setup from day one.

If you still want to try the old migration path, the deprecated tutorial is available here: [How to migrate Cloudlog to Wavelog (deprecated)](https://github.com/wavelog/wavelog/wiki/How-to-migrate-Cloudlog-to-Wavelog-(DEPRECATED))

Vy 73 de Wavelog Dev Team

!!! danger "STOP"
    Only continue here if you know what you are doing. We do not longer provide support for this migration path.

---

!!! warning
    Backup everything (Files and Database) before you make any changes !!

    Follow each step precise and READ everything!

A migration from Cloudlog to Wavelog is easily possible if your existing Cloudlog installation is version `2.6.7` or earlier. You don't have to make any database changes! Migration is possible at all times. **But don't worry. Even with later versions you can migrate to Wavelog!**
Keep in mind, that you'll lose Features which were implemented after CloudLog `2.6.7`. On the other hand you'll gain much more stability, performance and way more other stuff....

!!! note
    After the migration, you should clear your browser cache or perform a hard reload in your browser:  
    Windows: `Ctrl + F5`  
    Mac: `Cmd + Shift + R`

Don't forget the "Post-Migration" Steps at the end of this page.

### Preparation

In order to successfully migrate your existing Cloudlog Installation to Wavelog, you first have to set the correct migration version. 

Edit the file `application/config/migration.php` with your favorite editor. In this example, we use `nano` in the command line.


```
cd /var/www/html
nano -l application/config/migration.php
```

We assume that Cloudlog was installed in the folder `/var/www/html`. If your installation is in some other folder, change this command accordingly.

Now, while editing the file `migration.php`, make sure the value of the migration version on `Line 25` is `170`.


```
$config['migration_version'] = 170;
```

!!! danger
    If your migration version is any number BELOW 170, first update your Cloudlog Installation to the latest version.

Save the file with `Ctrl + X`, `Y`, and `Enter` 

After changing the migration version to `170`, go back to your browser and reload Cloudlog. You can verify the correct version number in the Admin menu at `ADMIN -> Debug Information`. You can ignore messages like `Not possible, sorry.`!

![debug_migration](https://github.com/wavelog/wavelog/assets/80885850/b335325f-2379-4094-a5b1-2a5f796d300a)

You have successfully downgraded your Cloudlog Installation to Version 2.6.3.

**Now shut down your webserver to avoid issues while changing the configurations**  
For Example:
```bash
systemctl stop apache2
```

### If you installed Cloudlog with `git clone`

If Cloudlog was installed with `git clone`, the migration process is quite easy. As we set important data in `.gitignore`, your specific userdata is not affected by this.
You first have to change the remote URL where `git` is pulling the data from.


```
git remote set-url origin https://www.github.com/wavelog/wavelog
```

Fetch the new git information for the newly set URL.

```
git fetch origin
```

If you now just would do a `git pull`, you would get a warning that you have uncommitted changes. To pull Wavelog now from GitHub, you can just "stash" the changes which differ from your existing Cloudlog installation.

```
git stash
```

Now we can pull Wavelog from GitHub.

```
git pull --rebase
```

**Optional:** If you don't want to "stash" that stuff (needs a few bytes of storage), you can also do a hard reset, which just ignores any changes and gets the files for Wavelog. But please be aware that this is a very hard way. 
 

```
git reset --hard origin/master
```

### If you installed Cloudlog with a ZIP File or have a hosted Webspace

If your Cloudlog instance is installed by a bare ZIP File or you are using a hosted webspace, the migration process is the same as updating your instance.

**Remember to do a Backup of the Cloudlog folder and the database!!**

1. Download the latest release of Wavelog as a ZIP File and unzip it.

	[https://github.com/wavelog/wavelog/releases](https://github.com/wavelog/wavelog/releases)

2. Now download the following files and folders from your existing installation:
	- File: `application/config/config.php`
	- File: `application/config/database.php`
	- File: `application/config/cloudlog.php`
	- Folder: `uploads/`
	- Folder: `images/eqsl_card_images/`
	- Folder: `assets/qslcard/`
	- **IF EXISTS:**
		- File: `assets/js/sections/custom.js`
3. Now copy these files and folders into the newly downloaded Wavelog data. You can just replace them **except cloudlog.php**. This file you need to rename to **wavelog.php**.  
Another way would be to just log in with (S)FTP and upload the Wavelog folder and accept "Overwrite?"-Messages. But don't forget to rename the cloudlog.php file to wavelog.php.
4. Once this is done, you can replace the complete **Cloudlog folder** with the prepared **Wavelog folder**.
5. Now reload the webpage. You should now see Wavelog running.

### Post-Migration Steps

After successfully migrating your Cloudlog Installation to Wavelog, you should check some things. 

You may want to start your webserver again, after you shut it down earlier

```bash
systemctl restart apache2
```

!!! warning
    The first pageload after restarting apache2 can take quite a while due to database migrations and changes which are necessary and triggered by the first page load. So don't worry and be patient :)

!!! note
    After the migration, you should clear your browser cache or perform a hard reload in your browser:  
    Windows: `Ctrl + F5`  
    Mac: `Cmd + Shift + R`

* Check your current configuration `application/config/config.php` and compare it against the sample config `application/config/config.sample.php`. You should make sure that your current configuration contains the same stuff as the sample config. For example you want to set `$config['app_name']` to "Wavelog".

* Make sure all folders and files have the correct ownership for the web server:

   For Example:

```
sudo chown -R www-data:www-data /var/www/html
```

Thanks for choosing Wavelog. If you run into any problems or if you still have questions, please use the [discussions area](https://github.com/wavelog/wavelog/discussions).
