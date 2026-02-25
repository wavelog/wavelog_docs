# HTTPS Support

Wavelog does not directly come with https built in (Why you can read [here](https://github.com/wavelog/wavelog/discussions/2131)). But we offer some ways how you can Wavelog with https enabled. 

---

Content:  
- [Docker Installations](https://github.com/wavelog/wavelog/wiki/HTTPS-Support#docker-installations)  
- [File Based Installs / git](https://github.com/wavelog/wavelog/wiki/HTTPS-Support#normal-file-based-installs-or-git-based-installations)  

For a solution with public available SSL certificates google for "certbot" or use the [Nginx Proxy Manager](https://github.com/NginxProxyManager/nginx-proxy-manager). For latter you will need some advanced config parameters - a hint for that can be found here: https://github.com/wavelog/wavelog/discussions/1231#discussioncomment-13698583

---

!!! warning
    Please note that this is just an IDEA how you could enabled https for your docker installation. We do not offer any personal support for that. Help yourself please

# Docker Installations

Docker installations are easy. Simply add an reverse proxy to your docker compose file. But let us prepare some other files:
Create a local folder (same path where the docker-compose.yml is)
```bash
mkdir -p nginx

### Should now look like this
# some_folder
# | 
# |- docker-compose.yml
# |- nginx
###
```
And create the nginx configuration in there
```
nano nginx/nginx.conf
```
## nginx/nginx.conf
```
events {
    worker_connections 1024;
}

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    # Logging
    log_format main '$remote_addr - $remote_user [$time_local] "$request" '
                    '$status $body_bytes_sent "$http_referer" '
                    '"$http_user_agent" "$http_x_forwarded_for"';

    access_log /var/log/nginx/access.log main;
    error_log /var/log/nginx/error.log warn;

    # Basic settings
    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 65;
    types_hash_max_size 2048;
    server_tokens off;

    # SSL Configuration
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES128-SHA256:ECDHE-RSA-AES256-SHA384;
    ssl_prefer_server_ciphers off;
    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 10m;

    # Security headers
    add_header X-Frame-Options DENY always;
    add_header X-Content-Type-Options nosniff always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header Referrer-Policy "strict-origin-when-cross-origin" always;

    # HTTP to HTTPS redirect
    server {
        listen 80;
        server_name _;
        return 301 https://$host$request_uri;
    }

    # HTTPS server
    server {
        listen 443 ssl http2;
        server_name _;

        # SSL certificates
        ssl_certificate /etc/nginx/ssl/wavelog.crt;
        ssl_certificate_key /etc/nginx/ssl/wavelog.key;

        # Security headers for HTTPS
        add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;

        # Client max body size (for file uploads)
        client_max_body_size 100M;

        location / {
            proxy_pass http://wavelog-main:80;
            
            # Proxy headers
            proxy_set_header Host $host;
            proxy_set_header X-Forwarded-Proto https;
            proxy_set_header X-Forwarded-SSL on;
            
            # FastCGI params für PHP
            proxy_set_header HTTP_X_FORWARDED_PROTO https;
            proxy_set_header HTTP_X_FORWARDED_SSL on;
        }

        # Optional: Static file caching
        location ~* \.(jpg|jpeg|png|gif|ico|css|js)$ {
            proxy_pass http://wavelog-main:80;
            proxy_set_header Host $host;
            proxy_set_header X-Forwarded-Proto https;
            expires 1y;
            add_header Cache-Control "public, immutable";
        }
    }
}
```
If you don't have any ssl certificate you can create a self-signed one like with these commands. Adjust your path if you have any. You have to copy the to nginx/ssl folder.
```
openssl genrsa -out nginx/ssl/wavelog.key 4096
openssl req -new -key nginx/ssl/wavelog.key -out nginx/ssl/wavelog.csr
openssl x509 -req -days 3650 -in nginx/ssl/wavelog.csr -signkey nginx/ssl/wavelog.key -out nginx/ssl/wavelog.crt
rm nginx/ssl/wavelog.csr
``` 
!!! warning
    These certificates are only selfsigned certificates. For valid certs you have to use LetsEncrypt. Check out the internet.

## docker-compose.yml
```
services:
  wavelog-db:
    image: mariadb:11.3
    container_name: wavelog-db
    environment:
      MARIADB_RANDOM_ROOT_PASSWORD: yes
      MARIADB_DATABASE: wavelog
      MARIADB_USER: wavelog
      MARIADB_PASSWORD: wavelog # <- Insert a strong password here
    volumes:
      - wavelog-dbdata:/var/lib/mysql
    restart: unless-stopped
    networks:
      - wavelog-network

  wavelog-main:
    container_name: wavelog-main
    image: ghcr.io/wavelog/wavelog:latest
    depends_on:
      - wavelog-db
    environment:
      CI_ENV: docker
    volumes:
      - wavelog-config:/var/www/html/application/config/docker
      - wavelog-uploads:/var/www/html/uploads
      - wavelog-userdata:/var/www/html/userdata
    restart: unless-stopped
    networks:
      - wavelog-network
    # Notice that we don't expose the port of Wavelog itself anymore!

  nginx-proxy:
    image: nginx:latest  # Debian-basiert
    container_name: wavelog-nginx
    depends_on:
      - wavelog-main
    ports:
      - "80:80"
      - "443:443"
    restart: unless-stopped
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf:ro
      - ./nginx/ssl:/etc/nginx/ssl:ro
    networks:
      - wavelog-network

volumes:
  wavelog-dbdata:
  wavelog-uploads:
  wavelog-userdata:
  wavelog-config:

networks:
  wavelog-network:
```

## config.php

### Base Site URL

When using a Docker installation and Nginx Reverse Proxy you must also configure the base-url in config.php to be the reverse proxy URL address using the https protocol. If using the standard docker-compose.yml from above this can be found in `/var/lib/docker/volumes/wavelog_wavelog-config/_data`.

```
/*
|--------------------------------------------------------------------------
| Base Site URL
|--------------------------------------------------------------------------
|
| URL to your CodeIgniter root. Typically this will be your base URL,
| WITH a trailing slash:
|
|       http://example.com/
|
| WARNING: You MUST set this value!
|
| If it is not set, then CodeIgniter will try guess the protocol and path
| your installation, but due to security concerns the hostname will be set
| to $_SERVER['SERVER_ADDR'] if available, or localhost otherwise.
| The auto-detection mechanism exists only for convenience during
| development and MUST NOT be used in production!
|
| If you need to allow multiple domains, remember that this file is still
| a PHP script and you can easily do that on your own.
|
*/
$config['base_url']     = 'https://wavelog.example.com/';

/*
```

# Normal file-based installs or `git` based installations

In the case of a normal installation you also have a webserver running. So you already use Apache2 or Nginx which can simply be reconfigured to use HTTPS instead normal HTTP.

!!! note
    We assume your installation is placed in `/var/www/html`. Change the path accordingly if you have a different location.

!!! warning
    Make sure you created the `.htaccess` file: `cp /var/www/html/htaccess.sample /var/www/html/.htaccess`

## Apache2

```
# Optional: Redirect all HTTP to HTTPS
<VirtualHost *:80>
    ServerName wavelog.example.com                             # <-- EDIT
    Redirect permanent / https://wavelog.example.com/          # <-- EDIT
</VirtualHost>

<VirtualHost *:443>
	ServerAdmin webmaster@localhost
        ServerName wavelog.example.com                         # <-- EDIT

	DocumentRoot /var/www/html                             # <-- EDIT

        ServerSignature Off

	ErrorLog ${APACHE_LOG_DIR}/error.log
	CustomLog ${APACHE_LOG_DIR}/access.log combined

	SSLEngine on

        # These are only self-signed certificates. They will produce an error in your browser, even the traffic is still encrypted
        # For valid SSL Certificates you have to use LetsEncrypt or commercial certificates. Check the internet for tutorials
	SSLCertificateFile      /etc/ssl/certs/ssl-cert-snakeoil.pem
	SSLCertificateKeyFile   /etc/ssl/private/ssl-cert-snakeoil.key

	<FilesMatch "\.(?:cgi|shtml|phtml|php)$">
		SSLOptions +StdEnvVars
	</FilesMatch>
	<Directory /usr/lib/cgi-bin>
		SSLOptions +StdEnvVars
	</Directory>

        <Directory /var/www/html>
                Options Indexes FollowSymLinks MultiViews
                AllowOverride All
                Require all granted
        </Directory>

</VirtualHost>
```

Make sure the correct modules are enabled and restart apache2

```shell
a2enmod ssl rewrite
systemctl restart apache2
```

## Nginx

```
# HTTP -> HTTPS Redirect
server {
    listen 80 default_server;                           
    server_name wavelog.example.com _;                             # <-- EDIT
    server_tokens off;
    
    # Redirect all HTTP traffic to HTTPS
    return 301 https://wavelog.example.com;                        # <-- EDIT
}

# HTTPS Server
server {
    listen 443 ssl http2 default_server;
    
    # SSL Configuration
    ssl_certificate /etc/ssl/certs/ssl-cert-snakeoil.pem;
    ssl_certificate_key /etc/ssl/private/ssl-cert-snakeoil.key;
    ssl_dhparam /etc/ssl/certs/dhparam.pem;
    
    # SSL Protocols and Ciphers
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384;
    ssl_prefer_server_ciphers off;
    
    # SSL Session Settings
    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 10m;
    ssl_session_tickets off;
    
    # Security Headers
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header Referrer-Policy "strict-origin-when-cross-origin" always;
    
    # Basic Settings
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
        access_log off;
    }
    
    # robots.txt
    location = /robots.txt {
        log_not_found off;
        access_log off;
    }
    
    # assets with longer cache
    location ~* \.(?:css(\.map)?|js(\.map)?|jpe?g|png|gif|ico|cur|heic|webp|tiff?|mp3|m4a|aac|ogg|midi?|wav|mp4|mov|webm|mpe?g|avi|ogv|flv|wmv)$ {
        expires 30d;
        add_header Cache-Control "public, immutable";
        access_log off;
    }
    
    # svg, fonts
    location ~* \.(?:svgz?|ttf|ttc|otf|eot|woff2?)$ {
        add_header Access-Control-Allow-Origin "*";
        expires 30d;
        add_header Cache-Control "public, immutable";
        access_log off;
    }
    
    # gzip compression
    gzip on;
    gzip_vary on;
    gzip_proxied any;
    gzip_comp_level 6;
    gzip_types text/plain text/css text/xml application/json application/javascript application/rss+xml application/atom+xml image/svg+xml text/javascript application/xml+rss;
    
    # handle .php
    location ~ \.php(/|$) {
        # Adjust socket path based on your system
        fastcgi_pass unix:/var/run/php/php-fpm.sock;
        
        # 404 for non-existent PHP files
        try_files $fastcgi_script_name =404;
        
        # default fastcgi_params
        include fastcgi_params;
        
        # fastcgi settings
        fastcgi_index index.php;
        fastcgi_buffers 8 16k;
        fastcgi_buffer_size 32k;
        fastcgi_read_timeout 300;
        
        # fastcgi params
        fastcgi_split_path_info ^(.+\.php)(/.*)$;
        fastcgi_param DOCUMENT_ROOT $realpath_root;
        fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
        fastcgi_param PATH_INFO $fastcgi_path_info;
        fastcgi_param HTTPS on;
    }
}
``` 


