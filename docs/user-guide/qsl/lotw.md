## Why does the upload of my LoTW certificate fail?

The LoTW certificate has to be exported from tqsl application at least version 2.7 or later. During the export *no password* must be set in order to be able to import the certificate into Wavelog.

## Why does the LoTW confirmation badge in logbook overview and logbook advanced show outdated data?

Information regarding the last upload to LoTW for the DX station is based on so called "lotw-user-activity.csv" file. This file is provided by LoTW and contains the last upload date for every call.

Apparently this file is only updated once a week around 1000z on Sundays. The Wavelog cron job for this is set to import the file once a week on Sundays This results in a time difference of up to a week. Last LoTW upload date and time for a specific callsign can be looked up on [Logbook Find Call](https://lotw.arrl.org/lotwuser/act?awg_id=&ac_acct=) or using the link "Last Upload" on the QSO details modal. This requires a valid and logged in LoTW account.

## The upload to LoTW was successful but the import failed according to LoTW status. Why are my QSOs sent as marked anyway?

LoTW upload and processing of the log happen asynchronously. The log is uploaded and processed independently by the LoTW queue. Therefore Wavelog cannot process the results of the import. QSOs are marked as uploaded as soon as the upload of the file itself is successful.

## Uploads to LoTW work fine but LoTW download seems broken. Why?

Check the credentials for your LoTW account. Uploads of logs are just using the LoTW certificate without username/password. The download instead uses username and password. If you changed your password on LoTW but not in Wavelog this results in failed downloads of matches from LoTW.

## Why do LoTW uploads fail even if my LoTW certificate is valid?

LoTW certificates have two date period fields:

- The first is the validity of the certificate itself. This marks the time during which the certificate can be used to sign logs.
- The second date information is called QSO start and end time and is independent of the certificate validity.

You can actively restrict the time for QSOs for which the certificate can be used (e.g. only specific times of a DXpedidition or end times for deleted DXCCs).

Example: LoTW certificate with validity from `Jan 1st 2025` to `Dec 31th 2030` but the certificate QSO time is between `Feb 23th 2025` and `Aug 28th 2026`. This certificate cannot be used to sign QSOs before `Feb 23th 2025` or after `Aug 28th 2026` although the certificate itself is valid until 2030.

For common usage you may want to leave the field for QSO end time empty during LoTW certificate request. See screenshot:

<img width="698" height="514" alt="QSOendtime" src="https://github.com/user-attachments/assets/797399ea-c96d-4553-8439-3b1407cb5234" />

Another reason might be that the certificate was renewed before it expired. In this case the old certificate is replaced by a new one. Uploads with the old one (which is still valid in Wavelog) are denied with an error message saying that the certificate has been superseded in LoTW. To solve this replace the certificate by the new one in Wavelog.

## Why will some QSOs (still) not upload?

### Check QSOs and certificates validity

Check that the QSO date is within QSO start and QSO end date for the LoTW certificate. QSOs made before the QSO start date of the certificate cannot be signed and thus not uploaded to LoTW. In this case you will have to request a new certificate with proper QSO start and QSO end dates.

### Check account settings

The username and password used by Wavelog to access LoTW are globally defined per each user account, so the same credentials are used to validate all QSOs for all callsigns under the same account. If you have multiple LoTW accounts to handle different callsigns, you should [contact the LoTW Helpdesk](https://www.arrl.org/lotw-help-ticket) and ask them to merge your accounts. A single LoTW account can handle multiple accounts.

This problem should usually be diagnosed by an error during manual LoTW account syncs stating: `Downloaded LoTW report contains no matches`
