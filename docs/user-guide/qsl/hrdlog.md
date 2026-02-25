# HRDLOG.net Integration

Wavelog allows HRDOG.net QSO push, this allows you to send any QSOs logged to the third party service. Setup of this feature is simple.

When creating or editing the Station Profile there is a field for the HRDLOG.net code. Once this is provided when you Add/Edit a QSO this information will be forwarded to HRDLOG.net's API

Tips

* If you don't know your HRDLOG.net code, it can be found at [http://www.hrdlog.net/EditUser.aspx](http://www.hrdlog.net/EditUser.aspx)


## Batch Uploading

You can run batch uploading to HRDLOG.net, this is useful in case of instances where HRDLOG.net is down, or you have edited a QSO these are uploaded with this process. 

```bash
*/2 * * * * curl --silent https://<url-and-path-to-wavelog>/index.php/hrdlog/upload/  &>/dev/null
```

## Mark QSOs as uploaded
Under HRDLog Logbook and Mark QSOs, you can mark your QSOs uploaded if they are already uploaded to the HRDLOG.net Logbook.