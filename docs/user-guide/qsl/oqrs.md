# OQRS — Online QSL Request System

The Online QSL Request System lets other operators request a QSL card for a confirmed contact through a public web page, instead of sending a paper card or an email. It:

* accepts QSL requests electronically,
* offers direct or bureau delivery,
* and saves time, postage and transcription errors.

OQRS is mostly used by DXpeditions, contest stations and operators with high QSO volumes, but it works just as well for a normal station.

!!! note
    This page covers Wavelog's own OQRS. You can also run [Club Log's OQRS](clublog.md#importing-oqrs-requests) in parallel — those requests never appear here; they are fetched during the Club Log sync and go straight into the [QSL Queue](qsl-queue.md) as *requested*.

Requests you receive land under `User menu -> OQRS Requests`, with a badge showing how many are still open. From there they flow into the [QSL Queue](qsl-queue.md) for printing.

## Enabling OQRS

1. Go to **Station Setup**.
2. Edit the **visitor site** and set a slug to be used in the URL — your callsign is a good choice. Save.
3. Edit your station locations and enable **OQRS** for each location you want to offer it for.

Your public page is then reachable at `[WAVELOG URL]/oqrs/[SLUG]`.

!!! note
    OQRS can be switched off instance-wide with `$config['disable_oqrs'] = true;` in `config.php`.

## User options

These apply to your account as a whole.

**Global text** — shown at the top of your public OQRS page.

**Grouped search** — when enabled, a visitor searches all your enabled locations at once. When disabled, they must first pick a location.

**Show station location name in grouped search results** — adds the location name to the result table.

**Automatic OQRS matching** — see [What is automatch?](#what-is-automatch) below. If disabled, you have to look up each request in your log by hand.

## Station location options

These are set per location under `Station Setup -> edit location`.

| Option | Effect |
|---|---|
| **OQRS Enabled** | Offer OQRS for this location |
| **OQRS Email alert** | Send you an email when a request arrives. Requires email to be configured under Admin -> Global Options; the mail goes to the address in your user preferences |
| **OQRS Text** | QSL information shown to visitors who select this location |

## The OQRS widget

The public request form can be embedded in a QRZ.com bio or any other page that allows iframes:

```html
<iframe name="iframe" src="[WAVELOG URL]/widgets/oqrs/[SLUG]" height="220" width="670" frameborder="0"></iframe>
```

!!! note
    The widget is not responsive yet. Stick close to `height="220" width="670"` and adjust carefully.

Options are passed as GET parameters. Currently available:

* `theme` — render the widget in one of Wavelog's themes, e.g. `[WAVELOG URL]/widgets/oqrs/[SLUG]?theme=darkly`

The widget logo links to the <a href="https://github.com/wavelog/wavelog" target="_blank" rel="noopener noreferrer">Wavelog repository</a> by default.

## Processing requests

`User menu -> OQRS Requests` is where incoming requests are handled. Filter by location, callsign and status.

Each request needs to be **matched to a QSO** in your log — that is the link that allows a label to be printed and the QSL to be marked as sent. Matched requests are added to the [QSL Queue](qsl-queue.md).

For unmatched requests, use the check-log buttons:

* **Call** — show all QSOs in your log for that callsign
* **Date / Time** — show all QSOs on that date within ±3000 seconds

When you find the right QSO, click **Match QSO**.

Once the label is printed and the QSL is marked as sent, the request is set to *Done*. You can also set a request to done manually, or reject it.

### Statuses

| Status | Meaning |
|---|---|
| Open request | Needs review by you |
| Not in log request | The visitor reported a QSO that was not found — check your log |
| Pending | Matched and waiting to be printed and sent |
| Done / sent | Processed, QSL sent |
| Rejected | Will not be processed |

## Typical flow

A visitor opens your OQRS page and is presented with either a location drop-down, or a single search box across all locations if grouped search is enabled.

After searching and filling in the form, the request is stored. With automatch enabled, Wavelog looks for the matching QSO, sets the status to *Pending* and adds a label to the print queue. Once printed and marked as sent, the request becomes *Done*. If no match is found — or automatch is off — the status is *Open request* and you match it manually as described above.

## FAQ

### What is automatch?

With automatch enabled, an incoming request is automatically linked to a QSO in your log if one is found within 30 minutes of the given time. Without it, you match every request by hand.

### Why do I need a QSO match on a request?

Without a match there is no connection between the request and a QSO, so Wavelog cannot print a label for it or mark the QSL as sent.

### Why is no email sent?

Check that email is configured under Admin -> Global Options, that **OQRS Email alert** is enabled for the location, and that the address in your user settings is correct.

### A request never shows up

There is a duplicate check: a second request for the same date, band and mode cannot be submitted.

### What about "not in log" requests?

Treat them like any other request. Check whether you can find the QSO at all — it may be a busted call, or the wrong band, mode, date or time. The check-log buttons are the fastest way to look.
