# QRZ Logbook Synchronisation

> Note this feature requires a paid subscription to QRZ.
> NOTE2: This does not download QSOs from QRZ, it only downloads confirmations.

Wavelog allows QRZ Logbook QSO push, this allows you to send any QSOs logged to the third party service. Setup of this feature is simple.

When creating or editing the Station Profile there is a field for the QRZ Logbook API once this is provided when you Add/Edit a QSO this information will be forwarded to QRZ Logbooks API

Tips

* If you don't know your QRZ Logbook API it can be found at [https://logbook.qrz.com/logbook](https://logbook.qrz.com/logbook)

Wavelog also supports pulling "confirmations" out of QRZ.com since Version 1.0

## Batch Down-/Uploading

You can run batch down-/uploading to QRZ, this is useful in case of instances where QRZ.com is down or you have edited a QSO these are uploaded with this process. If you have enabled "Realtime-Upload" at Station-Locations, the upload-one isn't needed. If not enabled, please set it to:

```bash
12 */6 * * * curl --silent https://<url-and-path-to-wavelog>/index.php/qrz/upload/  &>/dev/null
18 */6 * * * curl --silent https://<url-and-path-to-wavelog>/index.php/qrz/download/  &>/dev/null
```

## Mark QSOs as uploaded

Under ADIF Import / Export you can mark your QSOs uploaded if they are already uploaded to the QRZ Logbook.

# Important information about sync-logic

Wavelog asks QRZ for **new** QSLs after the last one which was received at Wavelog. This means - e.g.:

* you have a QSO which was confirmed on 2023-01-01. Either because it was really confirmed or you marked it as confirmed (via UI or ADIF)
* Wavelog will now ask QRZ for "QSLs" **after** 2023-01-01

If there's a QSL which was sent to QSL **before** 2023-01-01 it'll never reach Wavelog.
If you think this is wrong, there's a simple Workaround: Mark ALL your QSOs as "no QRZ-QSL" received. According to the above logic a new sync happens. This can be done in several ways:

* Use the Logbook-Advanced with its mass-edit mode (recommended way)
* Edit the QSOs in a single-way
* Export them, empty your Log, edit them with a editor of choice and reupload them

Reasons for this behaviour:

* Save data and computing power.
* An already confirmed QSO doesn't need to be confirmed again
* QRZ processes its QSLs in a straight way. they own no time-machine. Means: Either you got NOW a QSL for a QSO which happened in the past or you'll get the QSL in the future. You'll never(!) receive a QSL which QSL-Date was in the past. Remember: They own no time-machine

The same logic is used at LoTW-Confirms
