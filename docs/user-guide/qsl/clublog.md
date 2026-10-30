# Club Log

Wavelog uploads your QSOs to Club Log, either in batches or in real time, and imports the confirmations Club Log has for you.

The page lives at `User menu -> Third-Party Services -> Clublog Import / Export`.

!!! warning "Wavelog does not download your log"
    Only **confirmations** are fetched from Club Log. The QSO itself must already be in your Wavelog logbook — see the [overview](index.md).

## Credentials

Club Log credentials are stored **per user account**. Go to `User menu -> Edit profile -> Third Party Services` and fill in:

* **Club Log Email/Callsign**
* **Club Log Password**

!!! note
    If you have two-factor authentication enabled at Club Log, generate an **application password** there and use that instead of your normal password.

## Station location options

Two settings per station location (`Station Setup -> edit location`) control what happens with that location:

| Option | Effect |
|---|---|
| **Ignore Clublog Upload** | When set to *Yes*, QSOs from this location are never uploaded |
| **ClubLog Realtime Upload** | When set to *Yes*, each QSO is pushed to Club Log immediately after logging |

The batch upload walks through every station location that is not ignored.

## Uploading

Open the export page and upload manually per station location, or let the `clublog_upload` job in the Cronmanager (`Admin -> Cron Jobs`) do it — by default every 6 hours.

Wavelog generates an ADIF file in the `uploads/` folder and sends it to Club Log, then marks the QSOs as submitted.

!!! note
    The web server needs write access to the `uploads/` folder.

## Importing confirmations

The same page offers a manual import per station location. It fetches the confirmations Club Log holds for your callsign and marks the matching QSOs in your log.

## Importing OQRS requests

If you offer OQRS through Club Log, Wavelog can pull in the QSL requests made there. This runs alongside [Wavelog's own OQRS](oqrs.md) — you can offer both at the same time; each has its own queue.

Enable **Fetch Club Log OQRS requests** in `User menu -> Edit profile -> Third Party Services` (off by default). It is a user-level setting because it applies to all of your station locations at once. Club Log OQRS must be enabled on the Club Log side, and your Club Log credentials must be filled in as described above.

The requests are fetched along with the regular Club Log sync — both the manual import and the `clublog_upload` cron job. Each matching QSO in your log is then marked as **requested** and appears in the [QSL Queue](qsl-queue.md) like any manually requested QSO, including the delivery method (direct or bureau) taken from the request.

!!! note
    The two OQRS flavors fill different queues: requests made through Wavelog's own OQRS pages land under `User menu -> OQRS Requests`. Club Log requests skip that page — the matching QSO goes straight to the normal [QSL Queue](qsl-queue.md).

Details worth knowing:

* The first run backfills the full request history from Club Log; every later run only fetches new requests. If a fetch fails, it is retried on the next run.
* QSOs that are already marked as sent or requested are never touched, so manual marks survive.
* Station callsigns without a single QSO in your log are skipped — Wavelog only fetches requests it could match.
* The manual import honors the *last date* you select on the import page.

## Club Log SCP file

Independently of the log sync, Wavelog can use Club Log's **SCP file** (Super Check Partial) to suggest likely callsigns while you are logging.

The `update_update_clublog_scp` job in the Cronmanager keeps that file current and is **enabled by default**, running weekly. No Club Log account is needed for this.
