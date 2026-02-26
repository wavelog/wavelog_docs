# Multi-Domain Instance Configuration

Wavelog is able to be accessible from different URL's. If your Wavelog instance should only be accessible by one domain you can use the default configuration which is set in your `config.php`. Special thanks to [@adilinden](https://github.com/adilinden) in this [discussion](https://github.com/wavelog/wavelog/discussions/2930) for the idea starter!

```php
<?php
$config['base_url'] = 'https://wavelog.example.com/';
```

However in some cases you want your Wavelog instance make accessible from different domains you can replace the line with this:

```php
<?php
$config['base_url'] = call_user_func(function () {
    // Whitelist of allowed domains for this Wavelog instance
    // Ignore the port here. It's just about domain/subdomain
    // IPv4 works, IPv6 don't due to the regex
    $url_allowed   = [
        'wavelog.example.org',
        'log.domain2.xyz',
        '192.168.0.123'
    ];

    // Define the redirect URL for invalid/non-whitelisted hosts
    $redirect_url  = 'https://www.wavelog.org/';
    
    // Early fail-fast: reject empty or too long hosts before expensive regex
    $http_host     = strtolower($_SERVER['HTTP_HOST'] ?? '');
    if ($http_host === '' || strlen($http_host) > 259
        || !preg_match('/^([a-z0-9]([a-z0-9\-]{0,61}[a-z0-9])?(\.[a-z0-9]([a-z0-9\-]{0,61}[a-z0-9])?)*)(:([1-9][0-9]{0,4}))?$/', $http_host, $m)
        || (!empty($m[6]) && (int)$m[6] > 65535)
        || !in_array($m[1], $url_allowed, true)
    ) {
        header('Location: ' . $redirect_url, true, 301);
        exit;
    }

    $is_https = (!empty($_SERVER['HTTP_X_FORWARDED_PROTO']) && $_SERVER['HTTP_X_FORWARDED_PROTO'] === 'https')
        || (!empty($_SERVER['HTTP_X_FORWARDED_SSL'])   && $_SERVER['HTTP_X_FORWARDED_SSL'] === 'on')
        || (!empty($_SERVER['HTTPS'])                  && $_SERVER['HTTPS'] === 'on')
        || (!empty($_SERVER['SERVER_PORT'])             && (int)$_SERVER['SERVER_PORT'] === 443);
    
    $port = !empty($m[6]) ? ':' . $m[6] : '';

    return ($is_https ? 'https' : 'http') . '://' . $m[1] . $port . '/';
});
```
