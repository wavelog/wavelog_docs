# QSO

The QSO resource lets you read, create, update and delete log contacts. It builds
on the same logbook engine as the web UI, so dupe handling, mode/submode splitting
and teardown on delete all behave exactly as they do in Wavelog itself.

- **Base path:** `/api/v2/qso`
- **Scopes:** `qso:read`, `qso:write`, `qso:delete`
- **Since version:** <span class="wl-since">3.1.0</span>

All operations are scoped to the token owner's station locations. A QSO that does
not belong to one of them is treated as *not found*.

!!! note
    Read the [API v2 overview](index.md) first for authentication, the response
    envelope and error codes. Every request below needs an `Authorization: Bearer`
    header.

## Endpoints

| Verb | Path | Scope | Purpose | Since version |
| --- | --- | --- | --- | --- |
| `GET` | `/api/v2/qso` | `qso:read` | List QSOs (paginated) | <span class="wl-since">3.1.0</span> |
| `GET` | `/api/v2/qso/{id}` | `qso:read` | Fetch a single QSO | <span class="wl-since">3.1.0</span> |
| `POST` | `/api/v2/qso` | `qso:write` | Create a QSO | <span class="wl-since">3.1.0</span> |
| `PATCH` | `/api/v2/qso/{id}` | `qso:write` | Partial update | <span class="wl-since">3.1.0</span> |
| `DELETE` | `/api/v2/qso/{id}` | `qso:delete` | Delete a QSO | <span class="wl-since">3.1.0</span> |

!!! note "There is no `PUT` on QSOs"
    Updates are always partial. Wavelog is the source of truth for your log, and
    a full replace would let a client blank fields it never knew existed — every
    ADIF field added in a future release would silently be wiped by older
    clients. If you want to overwrite a QSO completely, send every field
    explicitly in a `PATCH`.

## Frequencies

Frequencies (`freq`, `freq_rx`) are expressed in **Hz** throughout the JSON API —
in create bodies (single and bulk), in update bodies and in responses. You may
also pass a value with a unit suffix, e.g. `"7.0475M"`, which is parsed to
`7047500` Hz.

!!! note "ADIF payloads are MHz"
    The one exception is an ADIF import (`import_type=adif`). Frequencies inside
    the ADIF payload are read as **MHz**, because that is what the ADIF standard
    prescribes. This applies to the ADIF document only — the surrounding JSON
    fields are unaffected.

## The QSO object

Responses return this shape (from the logbook record):

```json
{
  "id": 4886,
  "station_id": 1,
  "call": "N9EAT",
  "band": "20m",
  "mode": "SSB",
  "submode": null,
  "freq": 14075000,
  "freq_rx": null,
  "qso_date": "2026-06-16 17:06:00",
  "rst_sent": "59",
  "rst_rcvd": "57",
  "gridsquare": "EN42",
  "name": "Marty",
  "comment": "",
  "notes": "",
  "qth": "",
  "prop_mode": "",
  "sat_name": ""
}
```

## List QSOs

`GET /api/v2/qso`

The list endpoint takes a **common set of filters** and renders the result either
as JSON (default) or as ADIF — the data is fetched once and only the `format`
differs (see [Export QSOs as ADIF](#export-qsos-as-adif)).

Filters (all optional):

| Parameter | Default | Notes |
| --- | --- | --- |
| `station_id` | all owned | Comma-separated station-location ids; ids you do not own return `403 forbidden` |
| `callsign` | — | Exact match on the worked callsign, e.g. `4W7EST` (case-insensitive); invalid input returns `400 validation_error` |
| `dxcc_id` | — | DXCC filter, uses the DXCC ID e.g. `176` for `Fiji Islands` (available in Wavelog versions > 3.2.5) |
| `band` | — | Band filter, e.g. `20m` or `SAT` |
| `mode` | — | Mode/submode filter, e.g. `SSB` or `FT8` (matches the main mode or the submode) |
| `qsl_filter` | — | Comma list of `lotw`, `qsl`, `eqsl`, `qrz`, `clublog` (OR-combined) |
| `since_id` | `0` | Only QSOs whose primary key is greater than this |
| `qso_since` | — | `YYYY-MM-DD`, oldest QSO date to include (the whole day counts) |
| `qso_until` | — | `YYYY-MM-DD`, newest QSO date to include (the whole day counts) |

`qso_since` and `qso_until` filter on the **QSO date**, are inclusive on both ends
and can be used on their own or as a pair. They are independent of `since_id`, which
walks the database primary key for incremental syncing. A malformed date returns
`400 validation_error`.

!!! note "Clubstation tokens see only their own QSOs"
    For a [clubstation](clubstation.md) token below officer level the list is
    restricted to QSOs the acting member logged themselves, and `meta.total`
    counts only those. The ADIF export runs the same query, so `format=adif`
    returns exactly the same set. An officer sees every operator's QSO.

Pagination and rendering:

| Parameter | Default | Notes |
| --- | --- | --- |
| `page` | `1` | 1-based page number |
| `per_page` | `50` (JSON) / `1000` (ADIF) | Maximum `5000` for both formats |
| `limit` | — | Shortcut for the **newest N** QSOs (e.g. `limit=1` = your last QSO). Overrides `page`/`per_page` |
| `format` | `json` | `json` for the object list, `adif` for an ADIF export |

`per_page` is the batch-size knob for both formats. Only the default differs — small
for JSON browsing, larger for ADIF bulk sync — while the maximum is the same `5000`.

Use `limit` when you just want the latest few contacts: it returns the newest `N`
QSOs (newest first, after any filters), ignoring `page`/`per_page`. It is capped like
`per_page` (`5000`).

```bash
# Your most recent QSO
curl "https://<WAVELOG_URL>/index.php/api/v2/qso?limit=1" \
     -H "Authorization: Bearer wl2_your_token_here"
```

```bash
curl "https://<WAVELOG_URL>/index.php/api/v2/qso?band=20m&station_id=1&per_page=100" \
     -H "Authorization: Bearer wl2_your_token_here"
```

```bash
# Everything logged in June 2026
curl "https://<WAVELOG_URL>/index.php/api/v2/qso?qso_since=2026-06-01&qso_until=2026-06-30" \
     -H "Authorization: Bearer wl2_your_token_here"
```

```json
{
  "data": [ { "id": 4886, "call": "N9EAT" } ],
  "meta": { "page": 1, "per_page": 100, "count": 1, "total": 1, "total_pages": 1, "has_more": false }
}
```

The JSON list is ordered **newest first**. The `meta` block carries the full
pagination state — `total`, `total_pages` and `has_more` — so you can page until
`has_more` is `false` without probing for an empty page. See
[Pagination](index.md#pagination) for the field reference.

## Export QSOs as ADIF

`GET /api/v2/qso?format=adif`

Renders the **same filtered result set** as the list above, but as ADIF instead of
JSON — so all the [list filters](#list-qsos) (`station_id`, `callsign`, `band`,
`mode`, `qsl_filter`, `since_id`, `qso_since`, `qso_until`) apply. This is the v2 equivalent of the v1
`get_contacts_adif` endpoint.

The batch size is `per_page` — for ADIF it defaults to `1000` (up to the shared
`5000` maximum). For ADIF the rows are ordered **ascending by id**, and the response
reports `lastfetchedid` (the highest id in this page).
Feed it back as the next request's `since_id` for an incremental sync that only ever
pulls new contacts — or page with `page`/`per_page` and the `meta.has_more` flag.

```bash
curl "https://<WAVELOG_URL>/index.php/api/v2/qso?format=adif&since_id=0&station_id=1&per_page=1000" \
     -H "Authorization: Bearer wl2_your_token_here"
```

```json
{
  "data": {
    "exported": 3,
    "lastfetchedid": 3218,
    "adif": "Wavelog ADIF export\n<ADIF_VER:5>3.1.7\n…<EOH>\n…<EOR>\n"
  },
  "meta": { "page": 1, "per_page": 500, "count": 3, "total": 3, "total_pages": 1, "has_more": false }
}
```

When there is nothing new, `exported` is `0` and `adif` is `null`.

## Fetch a single QSO

`GET /api/v2/qso/{id}`

```bash
curl https://<WAVELOG_URL>/index.php/api/v2/qso/4886 \
     -H "Authorization: Bearer wl2_your_token_here"
```

Returns `404 not_found` if the QSO does not exist or is not owned by the token —
and, for a [clubstation](clubstation.md) token below officer level, if it was
logged by a different operator.

## Create a QSO

`POST /api/v2/qso`

The optional body field `import_type` selects the payload format:

| `import_type` | Meaning |
| --- | --- |
| `json` (default) | A single QSO from JSON fields (below), or several at once via a [`qsos` array](#import-multiple-qsos-json) |
| `adif` | A bulk [ADIF import](#import-multiple-qsos-adif) |

An unknown `import_type` returns `400 validation_error`.

For a single `json` QSO, send the fields at the top level (not an ADIF string).

**Required fields:**

| Field | Format | Example |
| --- | --- | --- |
| `station_profile_id` | integer, must belong to the token owner | `1` |
| `call` | string | `"N9EAT"` |
| `band` | string | `"20m"` |
| `mode` | string (mode or submode) | `"SSB"` |
| `qso_date` | `YYYY-MM-DD` | `"2026-06-16"` |
| `time_on` | `HHMM`, `HHMMSS` or `HH:MM[:SS]` | `"1706"` |

Common optional fields include `freq`, `freq_rx`, `time_off`, `rst_sent`,
`rst_rcvd`, `gridsquare`, `name`, `comment`, and any other valid ADIF field name
(lowercase). See [Editable fields](#editable-fields) for the fields that `PATCH`
recognises explicitly.

```bash
curl -X POST https://<WAVELOG_URL>/index.php/api/v2/qso \
     -H "Authorization: Bearer wl2_your_token_here" \
     -H "Content-Type: application/json" \
     -d '{
           "station_profile_id": 1,
           "call": "N9EAT",
           "band": "20m",
           "mode": "SSB",
           "freq": 14075000,
           "qso_date": "2026-06-16",
           "time_on": "1706",
           "rst_sent": "59",
           "rst_rcvd": "57",
           "gridsquare": "EN42",
           "name": "Marty"
         }'
```

On success the API responds with `201 Created`, a `Location` header pointing at the
new QSO, and the created object in `data`. Duplicate detection follows the normal
logbook rules.

!!! note
    Like all API-based QSO imports, creating a QSO here does **not** trigger a live
    upload to QRZ and does **not** perform a callbook lookup, for performance and
    error-handling reasons.

## Import multiple QSOs (JSON)

`POST /api/v2/qso` with a `qsos` array (still `import_type: "json"`).

To create several QSOs in one request, send a `qsos` array instead of top-level QSO
fields. Each element is a QSO object with the same fields as a single create; they
are all imported into the shared, top-level `station_profile_id`.

**Body fields:**

| Field | Notes |
| --- | --- |
| `station_profile_id` | Integer, must belong to the token owner (shared by all rows) |
| `qsos` | Non-empty array of QSO objects (each needs `call`, `band`, `mode`, `qso_date`, `time_on`) |
| `dryrun` | Optional `true` to validate only, importing nothing |

```bash
curl -X POST https://<WAVELOG_URL>/index.php/api/v2/qso \
     -H "Authorization: Bearer wl2_your_token_here" \
     -H "Content-Type: application/json" \
     -d '{
           "station_profile_id": 1,
           "qsos": [
             { "call": "N9EAT", "band": "20m", "mode": "FT8", "qso_date": "2026-06-16", "time_on": "1706" },
             { "call": "W1AW",  "band": "40m", "mode": "CW",  "qso_date": "2026-06-16", "time_on": "1712" }
           ]
         }'
```

The response is a bulk-import summary — the same shape as the ADIF import:

```json
{ "data": { "parsed": 2, "imported": 2, "skipped": 0, "messages": [] } }
```

| Field | Meaning |
| --- | --- |
| `parsed` | QSO objects received |
| `imported` | Rows actually stored |
| `skipped` | Rows skipped as duplicates |
| `messages` | Any validation/error messages |

A missing required field in one row fails the request with `400 validation_error`,
and `details.index` points at the offending array element.

## Import multiple QSOs (ADIF)

`POST /api/v2/qso` with `import_type: "adif"`

Bulk-imports an ADIF payload through the same engine the web UI and the v1 API use.

**Body fields:**

| Field | Notes |
| --- | --- |
| `import_type` | Must be `"adif"` |
| `station_profile_id` | Integer, must belong to the token owner |
| `adif` | The ADIF document as a string |
| `dryrun` | Optional `true` to parse only, importing nothing |

```bash
curl -X POST https://<WAVELOG_URL>/index.php/api/v2/qso \
     -H "Authorization: Bearer wl2_your_token_here" \
     -H "Content-Type: application/json" \
     -d '{
           "import_type": "adif",
           "station_profile_id": 1,
           "adif": "<CALL:5>N9EAT<QSO_DATE:8>20260102<TIME_ON:4>1300<BAND:3>20m<MODE:3>FT8<EOR>"
         }'
```

A real import returns `201 Created` with a summary; a `dryrun` returns `200 OK` with
the parsed count:

```json
{ "data": { "parsed": 1, "imported": 1, "skipped": 0, "messages": [] } }
```

```json
{ "data": { "dryrun": true, "parsed": 1 } }
```

| Field | Meaning |
| --- | --- |
| `parsed` | Records found in the ADIF payload |
| `imported` | Records actually stored |
| `skipped` | Records skipped as duplicates |
| `messages` | Any validation/error messages |

If nothing could be imported and only hard errors occurred, the API returns
`400 validation_error` with the details.

!!! tip "Clubstation tokens"
    A clubstation token logs under the acting member's callsign rather than the
    shared club call. Below officer level the `operator` field is **overwritten**,
    not just filled in, and the QSO list, the ADIF export and every per-QSO
    operation are restricted to that member's own contacts. See
    [Clubstations](clubstation.md).

## Update a QSO

`PATCH /api/v2/qso/{id}` — partial update, only the fields you send are changed.
Anything you omit keeps its stored value.

```bash
curl -X PATCH https://<WAVELOG_URL>/index.php/api/v2/qso/4886 \
     -H "Authorization: Bearer wl2_your_token_here" \
     -H "Content-Type: application/json" \
     -d '{ "comment": "Nice ragchew", "rst_rcvd": "59" }'
```

The response returns the fresh state of the QSO in `data`.

Notes:

- `qso_date` and `time_on` must be supplied **together**. `time_off` defaults to
  `time_on` and is never earlier than it.
- Passing `station_profile_id` moves the QSO to another of your station locations
  (ownership is verified).
- With a [clubstation](clubstation.md) token below officer level you may only
  edit QSOs you logged yourself; another operator's QSO returns `404 not_found`.

### Editable fields

`PATCH` accepts the following fields (in addition to `qso_date`/`time_on`,
`time_off`, `mode`, `freq`/`freq_rx` and `station_profile_id`, which are handled
specially):

```text
call, band, band_rx, rst_sent, rst_rcvd, gridsquare, name, comment, notes, qth,
tx_pwr, prop_mode, sat_name, sat_mode, sota_ref, pota_ref, wwff_ref, iota, sig,
sig_info, darc_dok, state, cnty, cqz, ituz, qsl_via, srx, stx, srx_string, stx_string
```

<span class="wl-since">3.2.5</span> The QSL sent status and the contact's e-mail can
be set too, e.g. by a tool that sends QSL cards:

| Field | Values |
| --- | --- |
| `qsl_sent` | `Y`, `N`, `R`, `Q` or `I` (case-insensitive) |
| `qsl_sent_via` | `B` (bureau), `D` (direct), `E` (electronic) or `M` (manager) |
| `qslsdate` | Date the QSL was sent, `YYYY-MM-DD`; `null` or `""` clears it |
| `email` | A valid e-mail address |

`qsl_sent: "Y"` without `qslsdate` stores the current date, like marking a QSL as
sent in the web UI. An invalid value returns `400 validation_error` with the
field name in `details`.

```bash
curl -X PATCH https://<WAVELOG_URL>/index.php/api/v2/qso/4886      -H "Authorization: Bearer wl2_your_token_here"      -H "Content-Type: application/json"      -d '{ "qsl_sent": "Y", "qsl_sent_via": "B" }'
```

!!! warning
    These are the same fields the web UI uses for paper QSLs, so a `PATCH`
    overwrites a status that was set there.

!!! note
    QSL received, LoTW / eQSL confirmation bookkeeping and DXCC / country
    recalculation fields are intentionally **not** editable through the API.

## Delete a QSO

`DELETE /api/v2/qso/{id}`

```bash
curl -X DELETE https://<WAVELOG_URL>/index.php/api/v2/qso/4886 \
     -H "Authorization: Bearer wl2_your_token_here"
```

Deletion runs the full teardown (OQRS entries, QSL/eQSL images, caches), exactly
like deleting from the web UI. On success the API returns `204 No Content`.

As with `PATCH`, a [clubstation](clubstation.md) token below officer level may
only delete its own QSOs; another operator's returns `404 not_found`.
