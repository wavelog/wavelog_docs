# config.php Configuration File

> Information Relating to application/config/wavelog.php

!!! tip
    For Docker-based setup, this file is located at `application/config/docker/wavelog.php`

## Wavelog configuration file

This file contains most of the configuration parameters used by Wavelog for almost every operation, from looking up callsigns from external sources to application behaviors (logging, enabling club mode, etc.)

### Basic configuration example

A sample `config.php` file can be located at [this link](https://github.com/wavelog/wavelog/blob/master/application/config/config.sample.php), this file should be renamed to `config.php` and customized based on user need.

### Callbooks configuration

Wavelog supports fetching callsigns data from external sources (QRZ.com, QRZCQ, HamQTH and QRZRU), allowing to gather additional details like locators, names and QSL info.

Each instance of Wavelog can be customized to retrieve data from a specific source, which is configured in the `callbook` variable.

Options are:

- `qrz`
- `qrzcq`
- `hamqth`
- `qrzru`

Additional details are available at: [Callbooks integration](https://github.com/wavelog/Wavelog/wiki/Callsign-Lookup)

Examples:

```php
$config['callbook'] = 'hamqth'; // Will retrieve callsigns data from HamQTH
(or)
$config['callbook'] = 'qrz'; // Will retrieve callsigns data from QRZ.com
```

#### Callbooks failover

Starting from release 2.2.2 (to be confirmed), this callbook variable can be set to an array of values indicating the sequence of callbooks to be tested until a valid result is returned. Callbooks are tested using the same sequence as configured in the callbook configuration variable. If no data is returned from the first source, the second one is tested, and so on.

!!! note
    This does not always fetch all sources, the sequence is only respected if no data is returned at all (e.g: callsign is not registered on that service, of if the service is unreachable. 

!!! note
    If an user is registered on a given service, but some details were not available, it is still considered as a "valid" result and no additional sources will be tested.

Examples:

```php
$config['callbook'] = ['qrz', 'qrzcq']; // Will retrieve data first from QRZ.com, if QRZ.com fails, will test QRZCQ
(or)
$config['callbook'] = ['qrz', 'qrzcq', 'hamqth']; // QRZ.com => QRZCQ => HamQTH
(or)
$config['callbook'] = ['hamqth', 'qrzcq', 'qrz']; // HamQTH => QRZCQ => QRZ.com
```

#### Callbooks full name lookup

If the API of the configured service returns the full name for a given callsign, this is only stored if the use_fullname option is set to `true`. 

!!! warning
    As people's full name is considered a sensitive information, make sure data is secured as per GDPR regulations

```php
$config['use_fullname'] = false;
```

#### Callbooks login

Each callbok must be configured with a valid username and password to retrieve data.

!!! note
    Some services (like QRZ.com) requires a paid subscription to enable callsign lookups

```php
$config['qrz_username'] = '';
$config['qrz_password'] = '';

$config['hamqth_username'] = '';
$config['hamqth_password'] = '';

$config['qrzcq_username'] = '';
$config['qrzcq_password'] = '';

$config['qrzru_username'] = '';
$config['qrzru_password'] = '';
```

### Application configuration

Several settings of the Wavelog instance can be configured to match different use cases

#### Base URL

This is the base URL for your Wavelog instance, all paths are based on this URL.

Examples:

```php
$config['base_url'] = 'http://localhost/logbook/';
(or)
$config['base_url'] = 'https://wavelog.example.com/';
```

#### Index page

Unless you renamed the main page for each folder (and you probably should not), this variable allows configuring names for that page:

```php
$config['index_page'] = 'index.php';
```

#### Logging level

If anything happens on the instance and some logging is required to troubleshoot, this variable can be changed to enable specific configuration lines.

Valid configurations are:

- `0`: Disables logging, Error logging TURNED OFF
- `1`: Error Messages (including PHP errors)
- `2`: Debug Messages
- `3`: Informational Messages
- `4`: All Messages

Example:

```php
$config['log_threshold'] = 0;
```

### Reverse proxy

If your server is behind a reverse proxy, you must whitelist the proxy IP addresses from which CodeIgniter should trust headers such as HTTP_X_FORWARDED_FOR and HTTP_CLIENT_IP in order to properly identify the visitor's IP address.

You can use both an array or a comma-separated list of proxy addresses, as well as specifying whole subnets. 

Here are a few examples:
```php
$config['proxy_ips'] = '10.0.1.200,192.168.5.0/24';
$config['proxy_ips'] = 'array('10.0.1.200', '192.168.5.0/24')';
```

### QSL services

Per each user, in the account settings, an username and password should be configured to send and received eletronic QSLs. 

#### Manual QSL synchronization

Electronic QSLs can be synched either automatically (based on scheduled cron operations) or manually. Manual operations can be disabled in the configuration file to only sync data based on the system scheduler.

For big instances, or congested networks, it might be better to disable manual synchronization and only run the scheduler on less busy hours.

```php
$config['disable_manual_lotw'] = false;
$config['disable_manual_eqsl'] = false;
$config['disable_manual_hrdlog'] = false;
$config['disable_manual_qrz'] = false;
```

#### QSL upload feature

Paper QSLs can be uploaded by users, this might consume a lot of disk space on shared instances, if you want to disable this feature, set the following option to `true`:

```php
$config['disable_qsl'] = false;
```

#### Online QSL requests

For each user, a dedicated page can be used for DXs to request QSL, this feature can be disabled by setting the following option.

Additional details are available here: [OQRS Widget](https://github.com/wavelog/wavelog/wiki/OQRS-(Online-Qsl-Request-System)#add-iframe-of-oqrs-request)

```php
$config['disable_oqrs'] = false;
```