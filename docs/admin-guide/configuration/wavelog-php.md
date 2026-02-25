# Wavelog.php Configuration File

> Information Relating to `application/config/wavelog.php`

# Basics

The configuration file `application/config/wavelog.php` is used to set any fixed-configuration options that Wavelog might require, the small number which are in `config.php` will be shifted to this file over time.

## Configuration Items

* `$config['show_time']` - This controls whether users who are not logged in can see QSO times, the default is set to false.
* `$config['measurement_base']` - This allows you to set unit of measurement used for showing bearings, the default is `M` which is miles, however, you can set `K` for kilometres and `N` for nautic miles.
* `$config['qso_date_format']` - changing this allows you to change the date format displayed this uses the php date() format, see notes in the file for details.
* `$config['qso_auto_qth']` - Setting this to TRUE allows the QTH locator to be pre-filled based on the person's location when creating new QSO. OSM's Nominatim API is being used for that purpose
* `$config['encryption_key']` - We strongly recommend to change the default encryption key to some random value string, since it is needed for certain wavelog functions to work properly, for example "Keep me logged in" feature.

## Remove `index.php` from your URL

Removing `index.php` from URLs requires two changes; one inside wavelog, and one specific to your webserver.

First, change one line in the configuration file `application/config/config.php` to `$config['index_page'] = '';`

| URL | Config | Example URL |
|-----|--------|----------|
| default | `$config['index_page'] = 'index.php';` | [https://wavelog.example.com/index.php/logbook](#) |
| pretty URLs | `$config['index_page'] = '';` | [https://wavelog.example.com/logbook](#) |


### Apache

If using Apache with mod_rewrite you have to rename the example file `htaccess.sample` to `.htaccess` in the root directory of your server. 

### NGINX

If using NGINX you have to insert or modify the root location with a `try_files` block like the example below.  This block goes right above the existing `location ~ \.php` block modified during initial installation.

```
    location / {
            try_files $uri $uri/ /index.php$uri ;
    }

    # existing location block for php files.
    location ~ \.php { 
```