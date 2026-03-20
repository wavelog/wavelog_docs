# Apache2 with mod_auth_openidc

`mod_auth_openidc` allows Apache2 to handle the full OIDC authentication flow directly — no separate proxy container (OAuth2 Proxy, Authentik Outpost) required. Apache authenticates the user against your identity provider and passes the JWT access token to Wavelog via an HTTP header.

## Architecture

```text
Browser  →  Apache2 (mod_auth_openidc)  →  Wavelog (PHP-FPM)
                        ↕
              Identity Provider (OIDC)
```

## Prerequisites

### Install the module

```bash
apt install libapache2-mod-auth-openidc
a2enmod auth_openidc headers
systemctl reload apache2
```

### Configure your identity provider

Create an **OAuth2/OpenID Connect client** in your IdP with:

- **Redirect URI:** `https://wavelog.example.org/redirect_uri`
- **Client type:** Confidential
- Note the **Client ID**, **Client Secret** and **Issuer URL**

For provider-specific setup see:

- [Keycloak](keycloak-configuration-guide.md) — Issuer URL: `https://auth.example.org/realms/example`
- [Authentik](authentik-configuration-guide.md) — Issuer URL: `https://auth.example.org/application/o/wavelog/`

Generate a crypto passphrase for the session cookie:

```bash
openssl rand -base64 32
```

---

## Apache2 VirtualHost

```apache
<VirtualHost *:443>
    ServerName wavelog.example.org

    DocumentRoot /var/www/wavelog

    SSLEngine on
    SSLCertificateFile    /etc/ssl/certs/wavelog.pem
    SSLCertificateKeyFile /etc/ssl/private/wavelog.key

    # --- mod_auth_openidc ---
    OIDCProviderMetadataURL https://auth.example.org/application/o/wavelog/.well-known/openid-configuration
    OIDCClientID            <your-client-id>
    OIDCClientSecret        <your-client-secret>
    OIDCRedirectURI         https://wavelog.example.org/redirect_uri
    OIDCCryptoPassphrase    <your-random-passphrase>
    OIDCScope               "openid email profile wavelog_callsign" # scope depends on your identity provider

    # Make the access token available as Apache environment variable
    OIDCPassAccessToken     On

    # The redirect URI callback must be handled by mod_auth_openidc, not by CodeIgniter.
    # Without this block, CodeIgniter's .htaccess rewrites /redirect_uri to index.php → 404.
    <Location "/redirect_uri">
        AuthType openid-connect
        Require valid-user
    </Location>

    # Protect only the SSO login endpoint — all other paths remain publicly accessible
    <Location "/index.php/header_auth/login">
        AuthType openid-connect
        Require valid-user
        # mod_auth_openidc sets OIDC_access_token as an Apache env var.
        # This directive forwards it as an HTTP request header so PHP can read it.
        RequestHeader set X-Access-Token "%{OIDC_access_token}e" env=OIDC_access_token
    </Location>

    <Directory /var/www/wavelog>
        Options FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    <FilesMatch \.php$>
        SetHandler "proxy:unix:/run/php/php8.4-fpm.sock|fcgi://localhost"
    </FilesMatch>
</VirtualHost>
```

!!! important
    Only `/index.php/header_auth/login` is protected. All other Wavelog paths remain publicly accessible — this is required for the standard login form, API integrations and ADIF imports to work correctly.

!!! note "Why `RequestHeader` is needed"
    `OIDCPassAccessToken On` makes mod_auth_openidc store the access token in the Apache environment variable `OIDC_access_token`. When Wavelog is served via PHP-FPM using `SetHandler`, this env var is not automatically forwarded as an HTTP request header. The `RequestHeader` directive explicitly converts it to the `X-Access-Token` header, which PHP exposes as `HTTP_X_ACCESS_TOKEN`.

!!! note "Why `/redirect_uri` needs its own Location block"
    CodeIgniter's `.htaccess` rewrites all unknown URLs to `index.php`. Without a dedicated `<Location "/redirect_uri">` block, Apache never gives mod_auth_openidc a chance to handle the OIDC callback — it gets caught by the rewrite rule and returns a 404. Adding the Location block with `AuthType openid-connect` tells Apache to hand the request to mod_auth_openidc before the rewrite rules run.

---

## Wavelog `sso.php`

`mod_auth_openidc` forwards the access token as `X-Access-Token`, which PHP exposes as `HTTP_X_ACCESS_TOKEN`:

```php
<?php
// Access token header forwarded by mod_auth_openidc via RequestHeader
$config['auth_header_accesstoken'] = "HTTP_X_ACCESS_TOKEN";

// Logout: redirect to the IdP end-session endpoint
// Keycloak:
// $config['auth_header_url_logout'] = 'https://auth.example.org/realms/example/protocol/openid-connect/logout';
// Authentik:
$config['auth_header_url_logout'] = 'https://auth.example.org/application/o/wavelog/end-session/';

// JWKS endpoint for JWT signature verification
// Keycloak:
// $config['auth_header_jwks_uri'] = 'https://auth.example.org/realms/example/protocol/openid-connect/certs';
// Authentik:
$config['auth_header_jwks_uri'] = 'https://auth.example.org/application/o/wavelog/jwks/';
```

All other `sso.php` settings (claim mapping, auto-create, etc.) are the same as described in the provider-specific guides.

---

## Troubleshooting

**404 on `/redirect_uri`**
: CodeIgniter's rewrite rules are catching the OIDC callback before mod_auth_openidc can handle it. Add the `<Location "/redirect_uri">` block with `AuthType openid-connect` as shown above.

**`SSO Authentication: Missing access token header`**
: The `X-Access-Token` header is not reaching PHP. Make sure `OIDCPassAccessToken On` is set and the `RequestHeader set X-Access-Token "%{OIDC_access_token}e" env=OIDC_access_token` directive is inside the `<Location "/index.php/header_auth/login">` block. Also verify that `mod_headers` is enabled (`a2enmod headers`).

**JWT verification failed**
: Check that `auth_header_jwks_uri` points to the correct JWKS endpoint and that the Apache server can reach it over the network. Enable debug logging in `sso.php` to inspect the raw token.
