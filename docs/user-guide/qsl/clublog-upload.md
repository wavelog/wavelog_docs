## Uploading Logbook

Wavelog supports uploading your logbook to Clublog, first, you must edit your profile and add your clublog username, password and the callsign for the logbook.

Once this is done if you go to the following URL `http://<website-address>/index.php/clublog/upload`

Wavelog generates a suitable ADIF file which is saved in the /uploads/ folder and then automatically uploaded, your logbook is then marked to say these QSOs have been submitted.

### Crontab Example

`0 */6 * * * curl --silent https://<url-and-path-to-wavelog>/index.php/clublog/upload &>/dev/null`
