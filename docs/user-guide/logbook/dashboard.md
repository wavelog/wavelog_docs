# Dashboard

<img width="1328" alt="image" src="https://github.com/wavelog/wavelog/assets/1410708/d1ff14aa-90ea-4b9d-800e-57dc4d49389b">

The Dashboard is the first page shown after login. It displays the top bar menu, a map and a list of the most recently logged QSOs, along with summary statistics for QSOs, countries worked and QSL cards.

The map plots contacts from the QSO list below it. By default the list shows the 20 most recent contacts, but this number can be adjusted in your account settings.

!!! note
    The number of map plots may not exactly match the number of QSOs in the list. If multiple contacts share the same location (e.g. the same DXCC without a precise gridsquare), they appear as a single overlapping plot on the map.

## Menu options

**Logbook** opens the full logbook view. Unlike the Dashboard, it shows more detail in the QSO list, allows you to page through all logged contacts and omits the QSL and DXCC statistics shown on the Dashboard.

**QSO** dropdown has the following:

* **Live QSO** – uses data from your radio to pre-fill frequency, with a real-time clock.
* **Post QSO** – all fields are entered manually.

**Notes** is a free-text area for frequently referenced information such as frequency plans and skeds. Notes are not accessible while the QSO entry form is open.

**Analytics** dropdown has the following:

* **Statistics** – QSO counts by year, mode and band, plus a list of satellites used.
* **Gridsquares** – worked gridsquares by band or satellite; the map starts at the high level and zooms through sub and extended squares.
* **Distances** – contacts filtered by band or satellite, shown as a graph of distance versus number of QSOs with callsigns at each range. The furthest contact is highlighted with full details.
* **Days with QSOs** – contact activity broken down by year and plotted as a graph.
* **DXCC Timeline** – DXCC contacts listed by date and prefix, with a link to each contact's full details.

**Awards** breaks QSOs down by award program: DXCC, VUCC, WAS, CQ, IOTA, WAB, SOTA and DOK. Detailed listings are available under each award section.

**Admin** dropdown has the following:

* [Accounts](../../admin-guide/administration/user-accounts.md) – add and manage users; useful for club and contest stations.
* [API](../../developer/api.md)
* [Station Profiles](../../admin-guide/administration/station-profiles.md)
* [Radio Interface](../integrations/radio-interface.md)
* [ADIF Import/Export](../qsl/adif-import-export.md)
* [LoTW Import/Export](../qsl/lotw-import-export.md)
* [eQSL Import/Export](../qsl/eqsl.md)
* [Print Requested QSLs](../qsl/print-requested-qsls.md)
* [Backup](../../admin-guide/administration/backup.md)
* [Update Country Files](../../admin-guide/administration/update-country-files.md)
