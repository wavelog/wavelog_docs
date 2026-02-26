# eQSL

The eQSL functions synchronizes your log with the actual state in eQSL.cc. This means Wavelog can handle all your eQSL tasks without you needing to login.

# Important (for all 3rd party services)

Wavelog WON'T Download your full log.
You need to have the QSO already in your log. Wavelog ONLY uses the 3rd party-services for QSL (confirmations).
Once a confirmation (for a logged entry) is fetched from eQSL, you can view the picture of the card

# Read (Common Pitfalls with eQSL)

* eQSL treats every location (called "Nickname" in their universe) as an OWN Account with OWN Credential-Set. This means: if you change the password for your "default-qth" at eQSL, all other "QTHs / Nicknames" will still have the old password. Make sure to change EVERY password.
* Wavelog automatically removes your credentials from wavelog, if eQSL returns "Wrong password / User not found". this is for security reasons, to prevent eQSL from blocking your account or the whole instance. Details can be found at the application-log of wavelog (see `./application/logs` and `./application/config/config.php` for correct loglevel)
* eQSL doesn't support "overlapping" QTHs. Every QTH/Nick at eQSL needs a own "validity". If you try to upload QSOs to a QTH/Nickname which is out of the daterange, eQSL answers with an error, which may cause removing the credentials.
* Don't use special-characters in your password. Even if they are working at the frontend, the eQSL-Backend doesn't accept them!
* Another one regarding Passwords: Even if you can provide - e.g. - 25character long passwords for eQSL, their API won't aceept them. Keep it simple, change the PW to something with 8 characters (and no special chars)
* to be continued...

## Basic Setup

* You must have provided your eQSL login details within your user profile; your eQSL.cc username is your callsign for that account.
* You must have provided an eQSL QTH Nickname for each station profile you use, using the station locator on both Wavelog and eQSL.cc is a useful way to distinguish it.
* The QSOs you want to upload to eQSL MUST be within the start/end-ranges and your Call which was setup by you at eQSL.

## Upload QSOs

When you select **Upload QSOs** you will be presented a list of QSOs that haven't been sent to the eQSL system, check the list and then press **Upload QSOs** once this is successful, the QSO will be marked as sent within the database.

### Debugging issues

If you're having problems uploading, you can enable debugging inside Wavelog by turning it on in `/application/config/config.php` (look for `log_threshold`) and then checking the log files within `/application/logs`.

## Importing

Go to the Usermenu at the right, and navigate to eQSL.

The import-functionality can work in two different ways:

* You can import an exported "inbox-ADIF-file" from eqsl.cc
* **Pull eQSL for me** Button this automatically downloads all your latest matches from eQSL and marks them as received in your logbook.

## View Digital Cards

One of the biggest things we heard from users was that eQSLs interface was old and dated and all they really wanted todo was quickly see the card reply, this is why when you click on the received arrow in the logbook area it will download the card and cache it locally on your server.

## Tools

* _**Mark All QSOs as Sent to eQSL**_ - Use this to mark QSOs as sent to eQSL when you are manually uploading the exported ADIF file (You might need to do this on a fresh install when you have 1000s of QSOs.

## Cron Job

```bash
# Upload/download QSOs to/from Eqsl (ignore cron job if this integration is not required)
9 */6 * * * curl --silent https://<URL-To-Wavelog>/index.php/eqsl/sync &>/dev/null
```
