# Authentik

!!! tip "Already running Apache2? Use mod_auth_openidc instead"
    If Apache2 is your webserver, `mod_auth_openidc` is the recommended approach — it handles the OIDC flow natively without a separate OAuth2 Proxy container. See [Apache2 with mod_auth_openidc](apache2-mod-auth-openidc.md).

This guide walks through configuring <a href="https://goauthentik.io/" target="_blank">Authentik</a> as the identity provider for Wavelog using <a href="https://oauth2-proxy.github.io/oauth2-proxy/" target="_blank">OAuth2 Proxy</a> as the authenticating reverse proxy.

## Architecture

```text
Browser  →  Webserver (nginx / Apache2)  →  OAuth2 Proxy  →  Wavelog
                                                  ↕
                                          Authentik (JWKS)
```

OAuth2 Proxy handles the OIDC flow with Authentik and forwards the JWT access token to Wavelog as an HTTP header. Wavelog verifies the token using Authentik's JWKS endpoint.

---

## Step 1: Create an OAuth2 Provider

In the Authentik Admin Interface:

1. Go to **Applications** → **Providers** → **Create**
2. Select **OAuth2/OpenID Provider**
3. Configure:
    - **Name:** `wavelog`
    - **Authorization flow:** select your default authorization flow
    - **Client type:** `Confidential`
    - **Redirect URIs:** `https://wavelog.example.org/oauth2/callback`
4. **Save**

After saving, copy the **Client ID** and **Client Secret** from the provider detail page.

---

## Step 2: Create an Application

1. Go to **Applications** → **Applications** → **Create**
2. Configure:
    - **Name:** `Wavelog`
    - **Slug:** `wavelog`
    - **Provider:** select the OAuth2 Provider created in Step 1
3. **Save**

---

## Step 3: Add the Callsign Claim

Authentik does not include custom user attributes in tokens by default. You need to store the callsign as a user attribute and create a Scope Mapping to include it in the JWT.

### 3a. Add a user attribute

1. Go to **Directory** → **Users** → select a user → **Edit**
2. In the **Attributes** field (JSON editor), add:

    ```json
    {
      "callsign": "N0CALL"
    }
    ```

3. **Save**

!!! note
    Authentik stores custom attributes as a JSON blob. There is no dedicated form field for custom attributes in the admin UI — this is the standard Authentik behavior. The attribute is stored correctly and will appear in the JWT as configured in the Scope Mapping below.

### 3b. Create a Scope Mapping

1. Go to **Customization** → **Property Mappings** → **Create**
2. Select **Scope Mapping**
3. Configure:
    - **Name:** `Wavelog Callsign`
    - **Scope name:** `wavelog_callsign`
    - **Expression:**

        ```python
        return {
            "callsign": request.user.attributes.get("callsign", None)
        }
        ```

4. **Save**

!!! tip
    Use the same approach to map other user attributes (e.g. `locator`) to JWT claims by creating additional Scope Mappings.

### 3c. Add the Scope Mapping to the provider

1. Go back to your OAuth2 Provider (`Applications` → `Providers` → select `wavelog`)
2. **Edit** → **Advanced protocol settings** → **Scopes**
3. Add `Wavelog Callsign` to the list
4. **Save**

---

## Step 4: Configure OAuth2 Proxy

OAuth2 Proxy acts as the authenticating reverse proxy. It handles the OIDC login flow with Authentik and forwards the JWT access token to Wavelog.

!!! important
    OAuth2 Proxy must protect **only** `/index.php/header_auth/login`. All other Wavelog paths must be passed through without requiring authentication.

### Docker Compose

```yaml
services:
  oauth2-proxy:
    container_name: oauth2-proxy
    image: quay.io/oauth2-proxy/oauth2-proxy:latest
    command: --config /oauth2-proxy.cfg
    hostname: oauth2-proxy
    volumes:
      - "./oauth2-proxy.cfg:/oauth2-proxy.cfg"
    restart: unless-stopped
    networks:
      - proxy-net

  nginx:
    container_name: nginx-proxy
    image: nginx:alpine
    volumes:
      - "./nginx.conf:/etc/nginx/conf.d/default.conf:ro"
      - "./ssl:/etc/nginx/ssl:ro"
    ports:
      - "80:80"
      - "443:443"
    depends_on:
      - oauth2-proxy
    restart: unless-stopped
    networks:
      - proxy-net

networks:
  proxy-net:
    driver: bridge
```

### `oauth2-proxy.cfg`

For detailed explanations refer to <a href="https://oauth2-proxy.github.io/oauth2-proxy/configuration/overview" target="_blank">OAuth2 Proxy's official documentation</a>.

```conf
http_address = "0.0.0.0:4180"

cookie_secret = "your-random-cookie-secret" # see below how to generate

provider = "oidc"
email_domains = ["*"]
client_id = "your-client-id"
client_secret = "your-client-secret"
redirect_url = "https://wavelog.example.org/oauth2/callback"
oidc_issuer_url = "https://authentik.example.org/application/o/wavelog/"
scope = "openid email profile wavelog_callsign"
insecure_oidc_allow_unverified_email = true
code_challenge_method = "S256"
pass_user_headers = true
set_xauthrequest = true
pass_access_token = true

# See https://oauth2-proxy.github.io/oauth2-proxy/configuration/session_storage
cookie_refresh = "4m"
cookie_expire = "30m"

skip_provider_button = true
whitelist_domains = "authentik.example.org"
```

Generate a cookie secret with:

```bash
openssl rand -base64 32 | tr -- '+/' '-_'
```

!!! note "Key differences from Keycloak"
    - `provider = "oidc"` instead of `keycloak-oidc` — Authentik uses the generic OIDC provider
    - `scope` must explicitly include `wavelog_callsign` to request the custom scope
    - `insecure_oidc_allow_unverified_email = true` is required because Authentik does not mark user emails as verified by default. To remove this setting, go to **Directory → Users**, edit the user and enable **Email verified** manually.
    - `oidc_issuer_url` follows the Authentik pattern: `https://<authentik-domain>/application/o/<application-slug>/`

---

## Step 5: Configure Your Webserver

### nginx

```nginx
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

    # oauth2-proxy endpoints — OIDC flow (callback, sign-in, etc.)
    location /oauth2/ {
        proxy_pass       http://oauth2-proxy:4180;
        proxy_set_header Host                    $host;
        proxy_set_header X-Real-IP               $remote_addr;
        proxy_set_header X-Scheme                $scheme;
        proxy_set_header X-Auth-Request-Redirect $request_uri;

        # Recommended buffer settings for larger JWTs to prevent 502 errors
        proxy_buffer_size          16k;
        proxy_buffers              4 16k;
        proxy_busy_buffers_size    16k;
    }

    # Auth subrequest endpoint (internal, used by auth_request only)
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

    # SSO login endpoint — oauth2-proxy authenticates, JWT is forwarded to Wavelog
    location ^~ /index.php/header_auth/ {
        auth_request /oauth2/auth;

        # Not authenticated → start Authentik login directly (no splash screen)
        error_page 401 = @sso_start;

        # Forward JWT access token from oauth2-proxy to Wavelog
        auth_request_set $access_token $upstream_http_x_auth_request_access_token;
        proxy_set_header X-Authentik-Jwt $access_token;

        proxy_pass http://wavelog:80;
        proxy_set_header Host              $host;
        proxy_set_header X-Real-IP         $remote_addr;
        proxy_set_header X-Forwarded-For   $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # Trigger Authentik login flow
    location @sso_start {
        return 302 /oauth2/start?rd=/index.php/header_auth/login;
    }

    # All other routes — no authentication required, Wavelog manages sessions itself
    location / {
        proxy_pass http://wavelog:80;
        proxy_set_header Host              $host;
        proxy_set_header X-Real-IP         $remote_addr;
        proxy_set_header X-Forwarded-For   $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

!!! important
    The header forwarded to Wavelog is `X-Authentik-Jwt` (not `X-Forwarded-Access-Token` as used with Keycloak). This must match `auth_header_accesstoken` in `sso.php` (see Step 6).

---

## Step 6: Configure Wavelog

**`application/config/config.php`:**

```php
<?php
$config['auth_header_enable'] = true;
```

**`application/config/sso.php`** (copy from `sso.sample.php`):

```php
<?php
$config['auth_header_create']              = true;
$config['auth_header_allow_direct_login']  = false;
$config['auth_header_hide_password_field'] = true;

// Authentik JWT is forwarded by nginx as X-Authentik-Jwt
$config['auth_header_accesstoken']         = "HTTP_X_AUTHENTIK_JWT";
$config['auth_header_text']                = "Login with SSO";

// Redirect to Authentik end-session on logout
$config['auth_header_url_logout'] = 'https://authentik.example.org/application/o/wavelog/end-session/';

// Authentik JWKS endpoint — enables cryptographic JWT verification
$config['auth_header_jwks_uri'] = 'https://authentik.example.org/application/o/wavelog/jwks/';

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
    'user_locator'   => [
        'claim'               => 'locator',
        'override_on_update'  => true,
        'allow_manual_change' => true,
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

Replace `authentik.example.org` and `wavelog` (the application slug) with your actual values.

---

## Step 7: Verify

1. Open Wavelog in the browser — the SSO login button should appear
2. Click the button and complete the Authentik login
3. You should be redirected to the Wavelog dashboard

If something is not working, enable debug logging in `sso.php` and `config.php` to inspect the JWT claims:

```php
<?php
// sso.php
$config['auth_header_debug_jwt'] = true;

// config.php
$config['log_threshold'] = 2;
```

Check `application/logs/log-YYYY-MM-DD.php` for the decoded JWT payload. Verify that `callsign`, `email` and `preferred_username` are present and match your claim map.

!!! warning
    Disable `auth_header_debug_jwt` again after troubleshooting.

---

## Troubleshooting

**`email in id_token isn't verified`**
: Authentik does not mark emails as verified by default. Either add `insecure_oidc_allow_unverified_email = true` to `oauth2-proxy.cfg` (already included in the example above), or go to **Directory → Users**, edit the user and enable **Email verified**.

**`callsign` claim missing from JWT**
: The `wavelog_callsign` scope was not included in the token. Verify that:

1. The Scope Mapping `Wavelog Callsign` exists under **Customization → Property Mappings**
2. The scope is assigned to the provider under **Advanced protocol settings → Scopes**
3. `scope` in `oauth2-proxy.cfg` explicitly includes `wavelog_callsign`
4. The user has a `callsign` attribute set under **Directory → Users → Attributes**

**`SSO Authentication: Missing access token header`**
: nginx is not forwarding the token header. Verify that:

1. `auth_request_set $access_token $upstream_http_x_auth_request_access_token;` is present in the `/index.php/header_auth/` block
2. `proxy_set_header X-Authentik-Jwt $access_token;` is set in the same block
3. `auth_header_accesstoken = "HTTP_X_AUTHENTIK_JWT"` is set in `sso.php`
