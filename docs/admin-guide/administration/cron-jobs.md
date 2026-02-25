# Cron Jobs & Cron Manager

Some Wavelog tasks are best performed on a regular schedule to keep things running smoothly. To avoid having an administrator do these tasks repeatedly you can set up cron jobs to do so automatically. There are two ways to set up these recurring jobs.

### Using the Cron Manager

Since Version 1.6 Wavelog comes with a handy WebUI Cron Manager. An administrator can see information about the recurring jobs in the 'Admin' menu within the submenu 'Cron Manager'. The Cronmanager needs at least PHP Version 8.1 to work. 

!!! warning
    To get the Cron Manager working you need to set up one real cronjob which is running every minute. In a Docker Installation this is already done!

```bash
# Wavelog Master Cron
* * * * * curl --silent https://<URL-To-Wavelog>/index.php/cron/run &>/dev/null

```

After setting up this master cronjob you have to wait at least one minute before you see more details in the Cron Manager. Reload the page after waiting 60 seconds. Now you can edit the interval of the job using the common cron format ([more Info here](https://en.wikipedia.org/wiki/Cron)) or disable/enable jobs with just one click.  

!!! warning
    Currently, adding/removing jobs via the WebUI is not supported.
#### Note for plain IP adresses without valid ssl certificate (self-signed certificates)
!!! tip
    The cronmanager currently needs plain HTTP **or** HTTPS with a **valid** SSL certificate. If you use HTTPS with a self-signed certificate you need to set `$config['cron_allow_insecure'] = true;` in your `config.php`. This adds the `-k` (`--insecure`) to the curl logic. You also need to add this flag to the mastercron.

#### Important Tip for Docker Installs
!!! tip
    By default, the cronmanager uses the url configured as `$config['base_url']` within config.php when making internal calls. If this url is not reachable from the host where wavelog is installed (this could happen especially when using a [docker setup](https://github.com/wavelog/wavelog/wiki/Installation-via-Docker)) the cronmanager will fail. For such cases it is possible to configure a url which should be used for local, internal calls using `$config['local_url']` within the config.php. For a setup within a docker container this snippet would do the job:
```php
$config['local_url'] = 'http://localhost/';
```

### Manual Cronjobs (strongly not recommended)

If you don't want to use the Cron Manager you can use regular server cronjobs. A list of recommended cronjobs are below.

```bash
# Upload QSOs to Club Log (ignore cron job if this integration is not required)
3 */6 * * * curl --silent https://<URL-To-Wavelog>/index.php/clublog/upload &>/dev/null

# Upload QSOs to LoTW if certs have been provided every hour. (Does Up- AND Download)
0 */1 * * * curl --silent https://<URL-To-Wavelog>/index.php/lotw/lotw_upload &>/dev/null

# Upload QSOs to QRZ Logbook (ignore cron job if this integration is not required)
6 */6 * * * curl --silent https://<URL-To-Wavelog>/index.php/qrz/upload &>/dev/null

# Download QSOs from QRZ Logbook (ignore cron job if this integration is not required)
18 */6 * * * curl --silent https://<URL-To-Wavelog>/index.php/qrz/download &>/dev/null

# Upload QSOs to HRD Logbook (ignore cron job if this integration is not required)
12 */6 * * * curl --silent https://<URL-To-Wavelog>/index.php/hrdlog/upload &>/dev/null

# Upload/download QSOs to/from Eqsl (ignore cron job if this integration is not required)
9 */6 * * * curl --silent https://<URL-To-Wavelog>/index.php/eqsl/sync &>/dev/null

# Update LOTW Users Activity
# Update only once a week as data is only provided weekly at ~ 1000z Sundays
10 1 * * 1 curl --silent https://<URL-To-Wavelog>/index.php/update/lotw_users &>/dev/null

# Update Clublog SCP Database File
@weekly curl --silent https://<URL-To-Wavelog>/index.php/update/update_clublog_scp &>/dev/null

# Update DOK File for autocomplete
@monthly curl --silent https://<URL-To-Wavelog>/index.php/update/update_dok &>/dev/null

# Update SOTA File for autocomplete
@monthly curl --silent https://<URL-To-Wavelog>/index.php/update/update_sota &>/dev/null

# Update WWFF File for autocomplete
@monthly curl --silent https://<URL-To-Wavelog>/index.php/update/update_wwff &>/dev/null

# Update POTA File for autocomplete
@monthly curl --silent https://<URL-To-Wavelog>/index.php/update/update_pota &>/dev/null

# Update DXCC entities every two months
20 0 1 */2 * curl --silent https://<URL-To-Wavelog>/index.php/update/dxcc &>/dev/null

# Check for newer release of Wavelog once a day and display banner on dashboard if found.
# You can remove the pipe to /dev/null to receive a notification/email by cron if an update was found.
45 4 * * * curl --silent https://<URL-To-Wavelog>/index.php/update/version_check &>/dev/null
```
