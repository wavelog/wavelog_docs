# API

<img width="1307" alt="image" src="https://github.com/wavelog/wavelog/assets/1410708/aaf91999-a2e9-4aba-9f34-d9cb3f16dde9">

The Wavelog API allows you to interact with Wavelog via third-party tools, this might be radios, external logging applications or programs, you can generate two types of keys read-only or read/write depending on your requirements.

At any time you can come to this section and delete keys to remove access.

!!! note
    Make sure not to include comments in your JSON request body. Comments in this page are only provided to help you understanding the payload syntax

## General workflow

1. Add a new API key to your account using the dedicated option in the user menu 
   - Depending on the API request, a read or read+write key is required
2. Perform a `POST` request to the API endpoint
   - The request should specify both the `Content-Type` which should be set to `application/json` and `Accept` which should be also set to `application/json`
   - The API KEY should be provided as part of the JSON payload

### API endpoint

The API URL is composed of the base url of the application (example: `https://log.example.com/`) plus the API endpoint (example: `api/qso`). The final URL should be something like: `https://log.example.com/api/qso`.

## Available APIs

### `api/qso/`

The QSO function allows you to send ADIF QSO strings via JSON to be imported into Wavelog, dupe checking is handled on the fly and you can send more than one QSO at a time.

```json
{
    "key":"YOUR_API_KEY",
    "station_profile_id":"Station Profile ID Number",
    "type":"adif",
    "string":"<call:5>N9EAT<band:4>70cm<mode:3>SSB<freq:10>432.166976<qso_date:8>20190616<time_on:6>170600<time_off:6>170600<rst_rcvd:2>59<rst_sent:2>55<qsl_rcvd:1>N<qsl_sent:1>N<country:24>United States Of America<gridsquare:4>EN42<sat_mode:3>U/V<sat_name:4>AO-7<prop_mode:3>SAT<name:5>Marty<eor>"
}
```

Example Linux shell command:

```bash
curl -X POST https://<WAVELOG_URL>/index.php/api/qso -H "Content-Type: application/json" -H "Accept: application/json" -d "{\"key\":\"<API_KEY>\",\"station_profile_id\":\"<STATION_PROFILE_ID>\",\"type\":\"adif\",\"string\":\"<call:5>N9EAT<band:4>70cm<mode:3>SSB<freq:10>432.166976<qso_date:8>20190616<time_on:6>170600<time_off:6>170600<rst_rcvd:2>59<rst_sent:2>55<qsl_rcvd:1>N<qsl_sent:1>N<country:24>United States Of America<gridsquare:4>EN42<sat_mode:3>U/V<sat_name:4>AO-7<prop_mode:3>SAT<name:5>Marty<eor>\"}"
```

**Note:** the `station_profile_id` field can be found when editing a station profile, the relevant ID its a number and can be retrieved by looking at the URL string.

#### Important
Whenever you post QSOs to the API (via WavelogGate, via WSJT-X Improved, via $tool):
- it doesn't live post the QSO to QRZ (even if enabled), because of performance/errrorhandling/etc.
- it doesn't lookup the QSO-Partner at $callbook, because of performance/errrorhandling/etc.


### `api/get_contacts_adif`

This function allows you to stream json-embedded ADIF Exports from Wavelog for integration with 3rd-party software.

Payload to be sent to the API endpoint:

```javascript
{
    "key": "YOUR_API_KEY",   // API-Key, read-only at least
    "station_id": "Station Profile ID Number",  // Station ID for the station that we want to pull QSOs from
    "fetchfromid": 0  // Internal database primary inside Wavelog of the last pulled QSO. Start at 0 to get all QSOs.
}
```

Example of API response:

```javascript
{
    "exported_qsos":5,   // The number of exported QSOs
    "lastfetchedid":4886,  // The internal primary key of the last exported QSO for you to use in your next input
    "message":"Export successful",  // A message containing success or reason for failure
    "adif": "ADIF STRING"  // ADIF file with all qsos since your last pull
}
```

### `api/radio`

#### Standard Radio API Call

!!! tip
    An example of a Python code to send radio data to Wavelog can be found [here](https://github.com/wavelog/wavelog/wiki/Radio-Interface)

```javascript
{
   "key":"YOUR_API_KEY", 
   "radio":"FT-950",
   "frequency":14075000, // Frequency in Hz
   "mode":"SSB",
   "power": '', // Optional field defined in watts
   "timestamp":"2012/04/07 16:47"
}
```

#### Extended Radio API Call

```javascript
{
    "key": "YOUR_API_KEY",          // API-Key
    "radio": "QO-100 Station",      // Name of the radio (used for assigning received data)
    "frequency": "2400170000",      // Frequency in Hz
    "mode": "SSB",                  // Mode
    "frequency_rx": "10489670000",  // Optional Rx frequency in Hz
    "mode_rx": "SSB",               // Optional Rx mode (not logged)
    "prop_mode": "SAT",             // Optional propagation mode
    "sat_name": "QO-100",           // Optional satellite name
    "power": "5",                   // Optional transmit power in Watts
}
```

#### Satellite Data

```javascript
{
   "key":"YOUR_API_KEY",
   "radio":"SATPC32",
   "uplink_freq": "2400210000",
   "downlink_freq": "10489710000", 
   "uplink_mode": "SSB", 
   "downlink_mode": "SSB", 
   "sat_mode": "S/X", // Not required
   "sat_name": "QO-100", 
   "power": '', // Optional field defined in watts
   "timestamp":"2012/04/07 16:47" 
}
```

#### Radio data with custom callback URL

!!! note
    This feature was introduced in Wavelog v2.1.1

!!! warning
    Changing the callback URL for a radio might disrupt normal work of other application (like WavelogGate). Read more about callback URLs [here](https://github.com/wavelog/Wavelog/wiki/Radio-Interface).

```javascript
{
  "key": "your_api_key_here",                 // Read+write API key
  "radio": "FT-950",                          // Arbitrary name to identify this device
  "frequency": 14075000,                      // Frequency in Hz
  "mode": "SSB",                              // Radio mode
  "power": 100,                               // Power in Watt
  "timestamp": "2025-09-14 16:47:00",         // Timestamp of the CAT data
  "cat_url": "https://log.example.com:54321"  // Custom callback URL for this radio
}
```

### `api/logbook_check_callsign`

This endpoint allows you to check if a callsign is in the logbook

```javascript
{
    "key":"", // Wavelog API Key
    "logbook_public_slug":"", // This is the Station Logbook Public Slug
    "band":"2m", // This is optional if you want to search satellite qsos only set the band as SAT
    "callsign":""
}
```

### `api/logbook_check_grid`

This allows you to check if a grid is in the logbook

```javascript
{
    "key":"", // Wavelog API Key
    "logbook_public_slug":"", // This is the Station Logbook Public Slug
    "band":"2m", // This is optional if you want to search satellite qsos only set the band as SAT
    "grid":""
}
```

### `api/statistics`

Returns the active profile stats that would show on the dashboard

* Todays QSOs
* Months QSOs
* Years QSOs
* Total QSOs

!!! note
    For this to work via V2 of Wavelog and public access (i.e. not logged in) you need to provide a valid (e.g. read-only) API key in the URL. That simply needs to be set on the URL like: `https://your.wavelog.url/index.php/api/statistics/clPutYourApiKeyHere`

### `api/station_info`

Returns information about stations (logbook locations) belonging to the user who has the corresponding API key:

```javascript
[
  {
    station_id: "1",
    station_profile_name: "JO30oo / DJ7NT",
    station_gridsquare: "JO30OO",
    station_callsign: "DJ7NT",
    station_active: "1"
  },
  {
    station_id: "2",
    station_profile_name: "JO30oo / DO7INT",
    station_gridsquare: "JO30OO",
    station_callsign: "DO7INT",
    station_active: null
  }
]
```

!!! note
    For this to work via V2 of Wavelog and public access (i.e. not logged in) you need to provide a valid (e.g. read-only) API key in the URL. That simply needs to be set on the URL like: `https://your.wavelog.url/index.php/api/station_info/clPutYourApiKeyHere`

### `api/private_lookup`

!!! note
    This feature requires Wavelog version 1.8.6 or later

This api checks the (API-)owners logbook for confirmations.

Request to be sent to the API endpoint:

```javascript
{
  "key":"[key]",
  "callsign":"VK4XY",
  "band":"20m",
  "mode":"SSB"
}
```

You may add the key `callbook` and set it to `true` if you also want to retrieve callbook-information. This feature comes with Wavelog 2.2.3. e.g.:
```
{
  "key":"[key]",
  "callsign":"VK4XY",
  "band":"20m",
  "mode":"SSB",
  "callbook": true
}
```

CLI example:

```bash
curl https://[URL]/api/private_lookup -X POST -d '{"key":"[key]","callsign":"VK4XY","band":"20m","mode":"SSB"}'
```

returns:

```javascript
{
    "callsign": "VK4XY",
    "dxcc": "AUSTRALIA",
    "dxcc_id": "150",
    "dxcc_lat": "-22",
    "dxcc_long": "135",
    "dxcc_cqz": "30",
    "dxcc_flag": "\ud83c\udde6\ud83c\uddfa",
    "cont": "OC",
    "name": "",
    "gridsquare": "",
    "location": "",
    "iota_ref": "",
    "state": "",
    "us_county": "",
    "qsl_manager": "",
    "bearing": "",
    "call_worked": true,
    "call_worked_band": true,
    "call_worked_band_mode": true,
    "lotw_member": false,
    "dxcc_confirmed_on_band": true,
    "dxcc_confirmed_on_band_mode": true,
    "dxcc_confirmed": true,
    "call_confirmed": true,
    "call_confirmed_band": true,
    "call_confirmed_band_mode": true,
    "suffix_slash": ""
}
```

Mandatory Fields within payload:

* key (your API-Key from AccountSettings --> API)
* callsign (the Call you want to check)

Optional Fields:

band:
* if given: api checks if the DXCC of the call was confirmed for this band
* if not given: dxcc_confirmed_on_band and dxcc_confirmed_on_band_mode will be false as well as call_confirmed_band and call_confirmed_band_mode

mode:
* if given: api checks if the DXCC of the call was confirmed for this band/mode combination
* if not given: dxcc_confirmed_on_band_mode will be false as well as call_confirmed_band_mode

station_ids (array!):
* if given: api checks QSOs within those station_profiles. If ommited: Every station_id of the key-owner will be checked.
* if given but no given ID was granted: Every station_id of the key-owner will be checked.
* if given but only a few IDs were granted: The granted IDs will be checked
* if given as string and not array: Every station_id of the key-owner will be checked.

### `api/version`

!!! note
    This feature requires Wavelog version 2.0 or later

This Endpoint reports the current version of Wavelog running. A valid API-Key is required.

Input format:

```javascript
{
    "key":"YOUR_API_KEY",
}
```

Example response:

```javascript
{
  "status": "ok",
  "version": "2.0"
}
```

Example shell command:

```bash
curl -X "POST" "https://<WAVELOG_URL>/api/version" \
     -H 'Content-Type: application/json; charset=utf-8' \
     -d "{\"key\":\"<YOUR_API_KEY>\"}"
```

### `api/get_wp_stats`

!!! note
    This feature requires Wavelog version 2.0.1

This Endpoint reports statistics about number of total QSOs, for the current year and per mode.

Input format:

```javascript
{
    "key":"YOUR_API_KEY",
    "station_id":"YOUR_STATION_ID",
}
```

Example response:

```javascript
{
  "status": "successful",
  "message": "Export successful",
  "statistics": {
    "totalalltime": [
      {
        "count": "28"
      }
    ],
    "totalthisyear": [
      {
        "count": "7"
      }
    ],
    "totalgroupedmodes": [
      {
        "count": "7",
        "col_mode": "CW",
        "col_submode": null
      },
      {
        "count": "6",
        "col_mode": "FM",
        "col_submode": null
      },
      {
        "count": "5",
        "col_mode": "FSK441",
        "col_submode": null
      },
      {
        "count": "4",
        "col_mode": "FT8",
        "col_submode": null
      },
      {
        "count": "3",
        "col_mode": "JT65",
        "col_submode": null
      },
      {
        "count": "2",
        "col_mode": "JT65",
        "col_submode": "JT65A"
      },
      {
        "count": "1",
        "col_mode": "SSB",
        "col_submode": null
      }
    ]
  }
}
```

Example shell command:

```bash
curl -X "POST" "https://<WAVELOG_URL>/api/get_wp_stats" \
     -H 'Content-Type: application/json; charset=utf-8' \
     -d "{\"key\":\"<YOUR_API_KEY>\", \"station_id\":\"<YOUR_STATION_ID>\"}"
```

### `api/create_station`

!!! note
    This feature requires Wavelog version >2.1.2

This Endpoint creates a new station_location within wavelog and tries to take care of dupes.

"link_active_logbook" optional field can be included as of version 2.3.1 to link the newly created station location to the (API-)owner's active logbook, if one exists. Any non-falsey value will trigger automatic linking. The newly created station location will not be linked to a logbook automatically if this field is not included, or evaluates to a falsey value ("0","").

Example Payload:
```
[
	{
		"station_profile_name": "DJ7NT at Home",
		"hrdlog_username": "DJ7NT",
		"station_gridsquare": "JO30",
		"station_city": "Unkel",
		"station_iota": "",
		"station_sota": "",
		"station_callsign": "DJ7NT",
		"station_power": "100",
		"station_dxcc": "230",
		"dxccname": "FEDERAL REPUBLIC OF GERMANY",
		"dxccprefix": "DL",
		"station_cnty": "",
		"station_cq": "14",
		"station_itu": "28",
		"station_active": "1",
		"eqslqthnickname": "at Home",
		"state": "RP",
		"county": null,
		"station_sig": "",
		"station_sig_info": "",
		"qrzrealtime": "-1",
		"station_wwff": "",
		"station_pota": "",
		"oqrs": "1",
		"oqrs_text": "",
		"oqrs_email": "0",
		"webadifrealtime": "0",
		"clublogrealtime": "0",
		"clublogignore": "0",
		"hrdlogrealtime": "0",
		"station_uuid": "12345678-1234-1234-1234-123456789012",
		"eqsl_default_qslmsg": "Testing --&gt; Good signal & nice QSO",
		"link_active_logbook": "1"
	}
]
```

Example curl-call for creating a location:
`curl "https://[your wavelog_instance]/api/create_station/[your_api_key]" -X POST -d @[File with payload]`

Possible Results:
* onSuccess with no dupes: 201 / {"status":"success","message":"1 locations imported."}
* onSuccess with a dupe: 200 / {"status":"dupe","message":"0 locations imported."}
* onError (Wrong key): 401 / {"status":"error","message":"Auth Error, invalid key"}
* onError (Malformed JSON): 400 / {"status":"error","message":"Invalid JSON file"}
* onError (other Errors): 500 / {"status":"error","message":"Hopefully helpful errormessage"}

Logic behind it:
* It checks if there's already a station_location for the User with EXACT the same References, Call, etc.
* It checks if there's already a station_location for the User with the same UUID (if provided in payload)
If one of both is true, this API won't create the location.

### `api/list_clubmembers`

!!! note
    This feature requires Wavelog version >2.3.1

Returns information about members of the clubstation associated with the API key.

!!! warning
    API key associated with a "Club Officer" user must be used

Input format

```json
{
  "key":"YOUR_API_KEY"
}
```

Example response if clubstation has members:

```json
{
  "status": "successful",
  "members": [
    {
      "callsign": "KD9WWC",
      "user_name": "anthony",
      "p_level": "9"
    },
    {
      "callsign": "KC9UHI",
      "user_name": "matt",
      "p_level": "6"
    }
  ]
}
```

Response if clubstation has no members:

```json
{
  "status": "failed",
  "reason": "No club members found",
  "members": ""
}