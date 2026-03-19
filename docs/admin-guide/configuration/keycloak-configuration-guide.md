# Keycloak

!!! tip "Already running Apache2? Use mod_auth_openidc instead"
    If Apache2 is your webserver, `mod_auth_openidc` is the recommended approach — it handles the OIDC flow natively without a separate OAuth2 Proxy container. See [Apache2 with mod_auth_openidc](apache2-mod-auth-openidc.md).

This guide walks through configuring <a href="https://www.keycloak.org/" target="_blank">Keycloak</a> as the identity provider for Wavelog. Two setups are covered:

- **OAuth2 Proxy** (Steps 3–5): a dedicated proxy container handles the OIDC flow and forwards the JWT to Wavelog
- **Apache2 with mod_auth_openidc** (alternative in Step 4): Apache handles OIDC directly without a separate proxy

## Architecture (OAuth2 Proxy)

```text
Browser  →  Webserver (nginx / Apache2)  →  OAuth2 Proxy  →  Wavelog
                                                  ↕
                                            Keycloak (JWKS)
```

OAuth2 Proxy handles the OIDC flow with Keycloak and forwards the JWT access token to Wavelog as an HTTP header. Wavelog verifies the token using Keycloak's JWKS endpoint.

---

## Step 1: Create a Keycloak Client

In the Keycloak Admin Console:

1. Go to **Clients** → **Create client**
2. Set **Client ID** (e.g. `wavelog`)
3. Click **Next**
4. Enable **Client authentication**
5. Click **Next**, then configure redirect URIs:
    - **Root URL:** `https://wavelog.example.org/`
    - **Home URL:** `https://wavelog.example.org/`
    - **Valid redirect URIs:** `https://wavelog.example.org/*`
    - **Valid post logout redirect URIs:** `https://wavelog.example.org/*`
6. **Save**

After saving, go to the **Credentials** tab to copy the **Client Secret**.

---

## Step 2: Add the Callsign Claim

Wavelog requires a callsign in the JWT. Keycloak does not include custom user attributes in tokens by default.

### 2a. Add a user attribute

1. Go to **Realm Settings** → **User profile** → create Attribute:
    - **Name:** `callsign`
    - **Display name:** `Callsign`
    - **Required:** optional (depends on your use case)

2. Go to **Users** → select a user and add the callsign attribute with a value (e.g. `4W7EST`)

### 2b. Create a Protocol Mapper

1. Go to **Clients** → select your client → **Client scopes** → click the dedicated scope (e.g. `wavelog-dedicated`)
2. Click **Add mapper** → **By configuration** → **User Attribute**
3. Configure:
    - **Name:** `callsign`
    - **User Attribute:** `callsign`
    - **Token Claim Name:** `callsign`
    - **Claim JSON Type:** `String`
    - Enable **Add to access token**
4. **Save**

!!! tip
    You can also use an existing attribute like `nickname` or map from a group if your setup uses groups for callsign assignment.

---

## Step 3: Configure OAuth2 Proxy

OAuth2 Proxy acts as the authenticating reverse proxy. It handles the OIDC login flow with Keycloak and forwards the JWT access token to Wavelog.

!!! important
    OAuth2 Proxy must protect **only** `/index.php/header_auth/login`. All other Wavelog paths must be passed through without requiring authentication. 

### Docker Compose

```yaml
services:
  oauth2-proxy:
    image: quay.io/oauth2-proxy/oauth2-proxy:latest
    command: --config /oauth2-proxy.cfg
    volumes:
      - "./oauth2-proxy.cfg:/oauth2-proxy.cfg"
    restart: unless-stopped
    ports:
      - "4180:4180"
```

### `oauth2-proxy.cfg`

For detailed explainations refer to <a href="https://oauth2-proxy.github.io/oauth2-proxy/configuration/overview" target="_blank">OAuth2 Proxy's official documentation</a>.

```conf
http_address = "0.0.0.0:4180"

cookie_secret = "your-random-cookie-secret" # see below how to generate

provider = "keycloak-oidc"
email_domains = ["*"]
client_id = "your-client-id"
client_secret = "your-client-secret"
redirect_url = "https://your-wavelog-domain/oauth2/callback"
oidc_issuer_url= "https://your-keycloak-domain/realms/your-realm"
code_challenge_method="S256"
pass_user_headers=true
set_xauthrequest = true
pass_access_token = true

# See https://oauth2-proxy.github.io/oauth2-proxy/configuration/session_storage
cookie_refresh = "4m"
cookie_expire = "30m"

skip_provider_button = true
whitelist_domains = "your-keycloak-domain"
```

Generate a cookie secret with:

```bash
openssl rand -base64 32 | tr -- '+/' '-_'
```

!!! note
    `pass_access_token = true` makes OAuth2 Proxy forward the JWT as `X-Forwarded-Access-Token`, which is what Wavelog reads by default.

---

## Step 4: Configure Your Webserver

OAuth2 Proxy listens on port `4180` and acts as the upstream for your webserver. The webserver terminates TLS and proxies everything.

!!! tip "Examples"
    All these configurations are examples. You have to adjust all of them to your needs. There is no Copy & Paste solution for this.

### nginx

```text


upstream app {
    server wavelog:80;
}

upstream oauth2_proxy {
    server oauth2-proxy:4180;
}

server {
    listen 80;
    server_name wavelog.example.org;
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl;
    server_name wavelog.example.org;

    ssl_certificate     /etc/nginx/ssl/fullchain.pem;
    ssl_certificate_key /etc/nginx/ssl/privkey.key;

    # oauth2-proxy endpoints — OIDC-Flow (Callback, Sign-in, etc.)
    location /oauth2/ {
        proxy_pass       http://oauth2-proxy:4180;
        proxy_set_header Host                    $host;
        proxy_set_header X-Real-IP               $remote_addr;
        proxy_set_header X-Scheme                $scheme;
        proxy_set_header X-Auth-Request-Redirect $request_uri;

        # These buffer settings are recommended for larger JWTs to prevent 502 errors from nginx
        proxy_buffer_size          16k;
        proxy_buffers              4 16k;
        proxy_busy_buffers_size    16k;
    }

    # SSO-Login via header_auth: oauth2-proxy authenticates, JWT is forwarded to Wavelog
    location = /oauth2/auth {
        proxy_pass             http://oauth2-proxy:4180;
        proxy_pass_request_body off;
        proxy_set_header Content-Length   "";
        proxy_set_header X-Original-URI  $request_uri;
        proxy_set_header X-Real-IP       $remote_addr;
        proxy_set_header X-Scheme        $scheme;
        proxy_buffer_size          16k;
        proxy_buffers              4 16k;
        proxy_busy_buffers_size    16k;
    }

    # All other requests go directly to Wavelog, which manages sessions itself (no auth_request)
    location ^~ /index.php/header_auth/ {
        auth_request /oauth2/auth;

        # Not authenticated → directly start Keycloak login (no splash screen)
        error_page 401 = @sso_start;

        # Forward JWT access token from oauth2-proxy to Wavelog as a header
        auth_request_set $access_token $upstream_http_x_auth_request_access_token;
        proxy_set_header X-Forwarded-Access-Token $access_token;

        proxy_pass http://app:8084;
        proxy_set_header Host              $host;
        proxy_set_header X-Real-IP         $remote_addr;
        proxy_set_header X-Forwarded-For   $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # Start Keycloak flow (triggered by @sso_start)
    location @sso_start {
        return 302 /oauth2/start?rd=/index.php/header_auth/login;
    }

    # All other routes — no auth_request, Wavelog manages sessions itself
    location / {
        proxy_pass http://app:8084;
        proxy_set_header Host              $host;
        proxy_set_header X-Real-IP         $remote_addr;
        proxy_set_header X-Forwarded-For   $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}

```

### Apache2

```apache
<VirtualHost *:443>
    ServerName wavelog.example.org

    # Proxy the SSO login endpoint to OAuth2 Proxy for authentication
    <Location "/index.php/header_auth">
        ProxyPass http://oauth2-proxy:4180
        ProxyPassReverse http://oauth2-proxy:4180
        RequestHeader unset Authorization
    </Location>

    # All other requests go directly to Wavelog, which manages sessions itself (no auth_request)
    ProxyPass        / http://wavelog-app:8084/
    ProxyPassReverse / http://wavelog-app:8084/
</VirtualHost>
```

---

---

## Step 5: Configure Wavelog

**`application/config/config.php`:**

```php
<?php
$config['auth_header_enable'] = true;
```

**`application/config/sso.php`** (copy from `sso.sample.php`):

```php
<?php
$config['auth_header_create']             = true;
$config['auth_header_allow_direct_login'] = false;
$config['auth_header_hide_password_field']= true;
$config['auth_header_accesstoken']        = "HTTP_X_FORWARDED_ACCESS_TOKEN";
$config['auth_header_text']               = "Login with SSO";

// Keycloak logout via OAuth2 Proxy
$config['auth_header_url_logout'] = 'https://wavelog.example.org/oauth2/sign_out'
    . '?rd=https://auth.example.org/realms/example/protocol/openid-connect/logout';

// Keycloak JWKS endpoint — enables cryptographic JWT verification
// You can get all necessary URL values from the Keycloak Admin Console → Realm Settings → Endpoints
$config['auth_header_jwks_uri'] = 'https://auth.example.org/realms/example/protocol/openid-connect/certs';

$config['auth_headers_claim_config'] = [
    'user_name'      => [
        'claim'               => 'preferred_username',
        'override_on_update'  => true,
        'allow_manual_change' => false,
    ],
    'user_email'     => [
        'claim'               => 'email',
        'override_on_update'  => true,
        'allow_manual_change' => false,
    ],
    'user_callsign'  => [
        'claim'               => 'callsign',
        'override_on_update'  => true,
        'allow_manual_change' => false,
    ],
    'user_firstname' => [
        'claim'               => 'given_name',
        'override_on_update'  => true,
        'allow_manual_change' => true,
    ],
    'user_lastname'  => [
        'claim'               => 'family_name',
        'override_on_update'  => true,
        'allow_manual_change' => true,
    ],
];
```

Replace `auth.example.org` and `/realms/example` with your actual Keycloak domain and realm name.

---

## Step 5: Verify

1. Open Wavelog in the browser — the SSO login button should appear
2. Click the button and complete the Keycloak login
3. You should be redirected to the Wavelog dashboard

If something is not working, enable debug logging in `sso.php` and `config.php` to inspect the JWT claims:

```php
<?php
// sso.php
$config['auth_header_debug_jwt'] = true;

// config.php
$config['log_threshold'] = 2;
```

Check `application/logs/log-YYYY-MM-DD.php` for the decoded JWT payload. Verify that `callsign`, `email` and `preferred_username` are present and match what you configured in the claim map.

!!! warning
    Disable `auth_header_debug_jwt` again after troubleshooting.
