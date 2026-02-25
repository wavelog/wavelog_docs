# DARC-DCL-Connector
This feature is disabled by default. To enable it, edit your `config.php` and add the following line to it:

`$config['enable_dcl_interface']=true;`

Once this is done, you see a new Menuitem on the right at Third-Party-Services, called "DCL Export".

<img width="482" height="731" alt="image" src="https://github.com/user-attachments/assets/73862335-3941-4d5d-833b-e10ccf271659" />

You're now able to request a Key from DARC by clicking on "Request DCL Key". You're headed to the DARC-SingleSignOn-Page, where you have to authenticate yourself at DARC to obtain that key. When finished you can upload the QSOs to DCL by pressing "Manual Sync".
Autosync is also available. Please enable it in Master-Cron.

## Important
- at the moment ONLY Uploading to DCL is supported.
- Only QSOs which have not been already "marked as sent to DCL" will be uploaded. So take care at ADIF-Import and check "mark already uploaded to DCL" ONLY if you've done that before. (BTW / ProTip: The same way is valid fort all other 3rd-party-services)
- DARC has announced to implement Download as well in future
- If you're facing problems with the DCL/DARC-Login, or the data which is returned (validity of callsigns, DOKs, etc.) please raise a ticket at DARC. Wavelog "only" interfaces DARCs DCL and is not responsible for the data on their pages.