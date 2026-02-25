# Important (for all 3rd party services)
Wavelog WON'T Download your full log.
You need to have the QSO already in your log. Wavelog ONLY uses the 3rd party-services for QSL (confirmations).
Once a confirmation (for a logged entry) is fetched you'll see a "green downpointing arrow" indicating the QSO has been confirmed.

# LoTW
Wavelog allows interaction with the ARRL Logbook of the World system, both for uploading QSOs and downloading confirmations. This is accessed via _**Admin -> Third Party Services -> Logbook of the World via the main menu and you will see something similar to the screenshot below.

<img width="1346" alt="image" src="https://github.com/wavelog/wavelog/assets/1410708/6fbbb426-ecef-4fd7-a3df-70e1b28cc5c4">


If you haven't uploaded any certificates you will get a notification to upload once this is done you will get a table with some basic fields

* Callsign
* DXCC
* Date Created (Date the certificate was created)
* Date Expires (Date your certificate expires)
* Status - This has multiple items, from badges to tell you that the cert is valid to when an upload happened, this is likely to be expanded over time.

## Downloading QSO Matches

There are two methods of importing data from LOTW, the first requires an ADIF file to exported from the LOTW website then uploaded to Wavelog for checking. Follow the instructions on the import page to generate the correct file and import it.

The second method pulls data directly from the LOTW website. **To enable this mode, the account must have a username and password set on the account settings page (`<domain>/user/edit/<number>`), under third-party services.** The `.p12` certificate is used for uploading logs, but not for downloading matches. (For US-based 1x1 callsign stations, the username and password should be for the primary account that requested the LOTW certificate for the 1x1, since you will not have a LOTW login for the 1x1 itself.)

The automatic pull from the website is run via the `lotw_lotw_upload` cron job in Cronmanager; it cannot be run manually. (The screenshot showing a button above is out of date.) 

## P12 File Uploading

You must upload the certificate .p12 file, this is exported from TQSL

* Open TQSL & go to the Callsign Certificates Tab
* Right-click on the desired Callsign
* Click "Save Callsign Certificate File" and do not add a password

## QSO Uploading

Wavelog builds the TQ8 file based on data you provide with the **Station Location** area, so if you are operating from a new area, just create the profile and when the script is run to upload to LoTW it will check that the Station Location has a valid certificate and upload, all on the fly no messing around.

## Background Processes

Uploading to (using certificates) and downloading from (using a username and password) LOTW is handled by the `lotw_lotw_upload` cron job in Cronmanager. This should run no more frequently than every hour or two.

## Notes for certain regions

### United States of America Users

* Station Location County must be exactly as LoTW would set it for example state **OR** and county **Deschutes**

### Canada 

* Canadian Provinces is now supported, make sure you select your province via the state drop-down in the Station Location area.

## Known issues

### Missing feedback in case of LotW Import Errors

If ARRL does not accept the exported ADIF file, the QSOs are still set to "LotW Sent". This issue can not be fixed, as the LoTW does not provide any feedback, if any, or whch QSO has not been accepted via the automatic upload.
You can check the uploads manually, by going to the LoTW Website, log into your account. Go to "Your account" and "Your Activity".
If you want to trigger a new upload of the (corrected) QSOs to LoTW, you have to manually edit the "LotW Sent" field.