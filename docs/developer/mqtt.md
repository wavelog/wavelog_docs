# MQTT Integration in Wavelog

Wavelog can publish real-time events to an MQTT broker whenever a QSO is logged or the CAT (radio control) status changes. This allows external applications — dashboards, home automation systems, displays, scripts — to react to hamradio activity without polling the Wavelog API.

MQTT support is **optional**. The application runs normally without it. Publishing is fire-and-forget with QoS 0; if the broker is unreachable, Wavelog logs the error and continues without interruption.

---

## Configuration

All MQTT settings live in `application/config/config.php`. None of the options are present by default — add only what you need.

| Config key | Type | Default | Description |
|---|---|---|---|
| `mqtt_server` | string | *(empty)* | Hostname or IP of the MQTT broker. **Setting this enables MQTT.** |
| `mqtt_port` | int | `1883` | TCP port of the broker. |
| `mqtt_username` | string\|null | `null` | Username for broker authentication. |
| `mqtt_password` | string\|null | `null` | Password for broker authentication. |
| `mqtt_prefix` | string | `wavelog/` | Prefix prepended to every topic. |

### Minimal example

```php
$config['mqtt_server'] = 'broker.example.com';
```

### Full example with authentication and custom prefix

```php
$config['mqtt_server']   = 'broker.example.com';
$config['mqtt_port']     = 1883;
$config['mqtt_username'] = 'wavelog';
$config['mqtt_password'] = 'secret';
$config['mqtt_prefix']   = 'wavelog/';
```

> **TLS/SSL:** The underlying phpMQTT library supports TLS. Standard plain TCP is used by default. To use TLS, adjust the port (typically 8883) and configure your broker accordingly.

---

## Topics

All topics are prefixed with the value of `mqtt_prefix` (default `wavelog/`). The full topic seen by subscribers is therefore `{prefix}{topic}`.

### QSO logged via the UI

```text
wavelog/qso/logged/{user_id}
```

Published each time a new contact is saved through the Wavelog web interface.

### QSO logged via the REST API

```text
wavelog/qso/logged/api/{user_id}
```

Published each time a new contact is saved through the Wavelog REST API (e.g., from a logging application like Log4OM, WSJT-X via a bridge, etc.).

### CAT (radio control) status update

```text
wavelog/cat/{user_id}
```

Published each time Wavelog receives a CAT update (frequency, mode, power, satellite data) from a connected radio control application.

---

## Payloads

All payloads are **JSON-encoded UTF-8 strings**.

### QSO event payload

The payload mirrors the ADIF field names used internally. Fields that were not set for a given QSO may be absent or `null`.

```json
{
  "COL_CALL": "DL1ABC",
  "COL_BAND": "40m",
  "COL_FREQ": "7.074",
  "COL_MODE": "FT8",
  "COL_RST_SENT": "599",
  "COL_RST_RCVD": "599",
  "COL_TIME_ON": "2026-03-14 14:23:00",
  "COL_TIME_OFF": "2026-03-14 14:23:30",
  "COL_NAME": "Hans",
  "COL_COUNTRY": "GERMANY",
  "COL_DXCC": "230",
  "COL_CQZ": "14",
  "COL_ITUZ": "28",
  "COL_PROP_MODE": null,
  "COL_SAT_NAME": null,
  "COL_TX_PWR": "50",
  "COL_ANT_PATH": null,
  "COL_GRIDSQUARE": "JN48",
  "COL_MY_GRIDSQUARE": "JN49",
  "COL_STATION_CALLSIGN": "DK0TU",
  "COL_MY_DXCC": "230",
  "COL_MY_COUNTRY": "GERMANY",
  "COL_MY_CQ_ZONE": "14",
  "COL_MY_ITU_ZONE": "28",
  "COL_COMMENT": "",
  "COL_NOTES": "",
  "user_name": "admin",
  "user_id": "1"
}
```

All standard ADIF fields populated during logging are included. The two non-ADIF additions are:

| Field | Description |
|---|---|
| `user_name` | Wavelog username of the station owner |
| `user_id` | Numeric Wavelog user ID of the station owner |

### CAT event payload

```json
{
  "prop_mode": null,
  "sat_name": null,
  "timestamp": "2026-03-14 14:25:00",
  "power": "100",
  "frequency": "14074000",
  "mode": "FT8",
  "frequency_rx": null,
  "mode_rx": null,
  "radio": "IC-7300",
  "user_id": "1",
  "operator": "DK0TU",
  "user_name": "admin"
}
```

| Field | Description |
|---|---|
| `frequency` | TX frequency in Hz |
| `mode` | TX mode (e.g. `FT8`, `SSB`, `CW`) |
| `frequency_rx` | RX/downlink frequency in Hz (satellites); `null` for simplex |
| `mode_rx` | RX/downlink mode (satellites); `null` for simplex |
| `power` | TX power in Watts |
| `prop_mode` | Propagation mode (e.g. `SAT`, `EME`); `null` if unset |
| `sat_name` | Satellite name; `null` if not a satellite QSO |
| `timestamp` | UTC timestamp of the update (`Y-m-d H:i:s`) |
| `radio` | Radio identifier string as sent by the CAT application |
| `operator` | Operator callsign |
| `user_id` | Numeric Wavelog user ID |
| `user_name` | Wavelog username |

> **Frequency format:** Frequencies in CAT events are in **Hz** (integer string). Frequencies in QSO events (`COL_FREQ`) follow the ADIF convention and are in **MHz** (decimal string, e.g. `"14.074"`).

---

## Subscribing — quick examples

### mosquitto_sub (command line)

```bash
# All Wavelog events
mosquitto_sub -h broker.example.com -t 'wavelog/#' -v

# Only newly logged QSOs (all users)
mosquitto_sub -h broker.example.com -t 'wavelog/qso/logged/#' -v

# CAT updates for user 1 only
mosquitto_sub -h broker.example.com -t 'wavelog/cat/1' -v
```

---

## Troubleshooting

| Symptom | Likely cause |
|---|---|
| No events published despite config set | Broker hostname not reachable from the web server; check firewall and DNS |
| `Error while trying to connect to MQTT` in logs | Wrong host/port, or credentials rejected by the broker |
| Events arrive but payload is empty / malformed | Verify `mqtt_prefix` does not contain invalid topic characters |
| Only some users' events appear | Check the `user_id` in the topic — each user publishes to their own sub-topic |

Enable CodeIgniter debug logging to see each published message:

```php
// application/config/config.php
$config['log_threshold'] = 2;  // 1 = errors only, 2 = errors + debug
```

Published messages appear as:

```text
DEBUG - published wavelog/qso/logged/1 -> {...} to MQTT broker
```
