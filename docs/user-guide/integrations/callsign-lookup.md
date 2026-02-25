# Callsign Lookup

Callsign lookup is supported using the HamQTH (Free) or QRZ XML Subscription service (Paid).

## Setup

### QRZ
If you have purchased a QRZ XML Subscription you can configure Wavelog to use it by doing the following

In `/application/config/config.php` update the following

```php
$config['callbook'] = "qrz";
$config['qrz_username'] = "";
$config['qrz_password'] = "";
$config['use_fullname'] = true;
```

The username and password are the ones you use to login to QRZ.

!!! tip
    Do NOT use the sign '#' in your password, when use remove it .. to give good search result !

!!! note
    If you want to fetch the full name (first and surname) and store it in your database, set `$config['use_fullname'} = true`, as displayed above.

**NOTE:** even if you haven't purchased a subscription, QRZ will return the following fields via the XML interface ...

* First name ``<fname>``
* Last name ``<name>``
* Town/City ``<addr2>``
* State (USA only) ``<state>``
* Country ``<country>``

... sufficient to populate a few fields in the log!  There may, however, be a limit to the number of lookups you can do, although this may apply to the web pages only and not the XML interface (unconfirmed - at the time of writing I'm up to 246 lookups in the last 24 hrs without a subscription!)

### HamQTH (currently not modifiable in the UI - manually configured)
If you want to use HamQTH you must configure the following items:

In `/application/config/config.php` update the following

```php
$config['callbook'] = "hamqth";
$config['hamqth_username'] = "";
$config['hamqth_password'] = "";
$config['use_fullname'] = true;
```

The username and password are the ones you use to login to HamQTH.

!!! note
    If you want to fetch the full name (first and surname) and store it in your database, set `$config['use_fullname'} = true`, as displayed above.