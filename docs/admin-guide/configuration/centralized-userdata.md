# Centralized User Data

With Wavelog Version 1.2 is now the feature "Userdata" default on for new installations. This means that following saved files have a new location in the folder structure:

* Uploaded QSL cards are not longer stored in `assets/qslcard` -> New location is `userdata/[user_id]/qsl_card`

* From eQSL downloaded eQSL cards are not longer stored in `images/eqsl_card_images` -> New location is `userdata/[user_id]/eqsl_card`

If you update from a previous Wavelog version to version 1.2 and the config option is not enabled this won't affect you! It only applies if you enable this feature or you do a fresh install.

## Enabling centralized userdata

To enable this feature simply go to `application/config/config.php` and decomment

`config['userdata'] = 'userdata'`

If you can't find this option you may updated an existing installation. The check `config.sample.php` for reference and add this line to your `config.php`

### Migrating data

#### For new installations

You don't have to do anything. New files will be saved in the new folder structure automatically.

#### After updating an existing installation

#### If you enabled the option in Version 1.1

 1. If you have other 'non-admin' users first enable the maintenance mode ([wiki how to](../administration/maintenance-mode.md))
 2. Copy ALL files from `userdata/qsl_card/...` to `assets/qslcard` manually
 3. Delete `userdata/qsl_card`. You don't need it anymore as they are deprecated.
 4. Copy ALL files from `userdata/eqsl_card/...` to `images/eqsl_card_images` manually
 5. Delete `userdata/eqsl_card`. You don't need it anymore as they are deprecated.
 6. Make sure all folders are accessible by the webserver user (usually `www-data`)
 7. Go to 'Admin > Debug' and click on "Migrate data now"
 8. Now all files from the old folders will be scanned, sorted and copied to the new `userdata` folder
 9. Check manually if you can open qsl and eqsl cards in the Web UI. If everything seems right you can delete the folders `assets/qslcard` and `images/eqsl_card_images`

#### If you enabled the option now in version 1.2 or later

 1. If you have other 'non-admin' users first enable the maintenance mode ([wiki how to](../administration/maintenance-mode.md))
 2. Perform only the steps 6-9 from the list above.
