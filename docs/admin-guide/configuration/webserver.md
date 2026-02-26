# Some Example Configs

Be aware that this are example configurations. You may have to adjust these configs to fit your needs. All examples are for installations where Wavelog is _**NOT**_ installed in a subfolder.

!!! tip
    We only enable HTTP (Port 80) configs here by default. We highly suggest you to configure your webserver with HTTPS (Port 443) and a valid certificate. One benefit next to encrypted communication (way more safe!) is that the 'KEEP LOGIN' feature, which remembers your login for 30 days is only available when using Wavelog with HTTPS. For more Information about HTTPS in Wavelog check out this page ["HTTPS Support"](../../admin-guide/configuration/https.md)

## Apache2

### Dependencies

Make sure you enable the `rewrite` module

```bash
a2enmod rewrite
```

Copy the htaccess file

```bash
cp /var/www/html/htaccess.sample /var/www/html/.htaccess
```

### Configuration

```apache
<VirtualHost *:80>

        ServerAdmin webmaster@localhost

        DocumentRoot /var/www/html

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined

        <Directory /var/www/html>
                Options Indexes FollowSymLinks MultiViews
                AllowOverride All
                Require all granted
        </Directory>

</VirtualHost>
```

### Remove `index.php` from the URL with Apache2 (Pretty URL)

Just set `$config['index_page']` in your `application/config/config.php` to `''`

!!! warning
    Do not edit any file before Wavelog is successfully installed. The final editable file `aplication/config/config.php` is generated during the installation.

```php
$config['index_page'] = '';
```

And restart Apache2

```bash
systemctl restart apache2
```

## Nginx

### Configuration

```nginx
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    # TLS
    # this configuration works if the key is not encrypted, if it is encrypted, you need an additional keyfile
    # listen [::]:443 ssl ipv6only=on default;
    # listen *:443 default ssl;
    # ssl_certificate_key /path/to/key.pem;
    # ssl_certificate /path/to/fullchain.pem;
    # ssl_protocols TLSv1.2 TLSv1.3;
    # generate that file with openssl dhparam -out xxx.pem 4096
    # ssl_dhparam /path/to/dhparam.pem;

    # enable H2 - makes connections faster, also allows server push; needs TLS to work
    http2 on;

    # it assumes that Wavelog is installed in /var/www/html. Change accordingly
    root /var/www/html;

    index index.php index.html;

    server_name wavelog.example.com _;
    server_tokens off;

    # index.php fallback
    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    # deny access to hidden files
    location ~ /\. {
        deny all;
        return 403;
    }

    # deny access to application/
    location ~ /application {
        deny all;
        return 403;
    }

    # favicon.ico
    location = /favicon.ico {
        log_not_found off;
    }

    # robots.txt
    location = /robots.txt {
        log_not_found off;
    }

    # assets
    location ~* \.(?:css(\.map)?|js(\.map)?|jpe?g|png|gif|ico|cur|heic|webp|tiff?|mp3|m4a|aac|ogg|midi?|wav|mp4|mov|webm|mpe?g|avi|ogv|flv|wmv)$ {
        expires 7d;
    }

    # svg, fonts
    location ~* \.(?:svgz?|ttf|ttc|otf|eot|woff2?)$ {
        add_header Access-Control-Allow-Origin "*";
        expires 7d;
    }

    ## gzip (optional)
    # gzip            on;
    # gzip_vary       on;
    # gzip_proxied    any;
    # gzip_comp_level 6;
    # gzip_types      text/plain text/css text/xml application/json application/javascript application/rss+xml application/atom+xml image/svg+xml;

    # handle .php
    location ~ \.php(/|$) {
        # on arch linux, the default path is /run/php-fpm/php-fpm.sock
        fastcgi_pass unix:/var/run/php/php-fpm.sock;

        # 404
        try_files $fastcgi_script_name =404;

        # default fastcgi_params
        include fastcgi_params;

        # fastcgi settings
        fastcgi_index index.php;
        fastcgi_buffers 8 16k;
        fastcgi_buffer_size 32k;

        # fastcgi params
        fastcgi_split_path_info ^(.+\.php)(/.*)$;
        fastcgi_param DOCUMENT_ROOT $realpath_root;
        fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
        fastcgi_param PATH_INFO $fastcgi_path_info;
    }
}
```

### Remove `index.php` from the URL with Nginx (Pretty URL)

Just set `$config['index_page']` in your `application/config/config.php` to `''`

```php
$config['index_page'] = '';
```

You may need to restart the webserver and php-fpm. Change the php version number if you have another version then 8.2.

```bash
systemctl restart nginx php8.2-fpm
# on manjaro / arch linux
systemctl restart nginx php-fpm
```
