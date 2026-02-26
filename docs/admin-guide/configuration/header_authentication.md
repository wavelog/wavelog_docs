# Header Authentication - OAuth2-Proxy & Keycloak

This guide explains how Wavelog can be configured to use [Keycloak](https://www.keycloak.org/) for authentication.

When using [OAuth2-Proxy](https://github.com/oauth2-proxy/oauth2-proxy) with Keycloak, **only Username and Email** is available by default.

## Configure Keycloak Client

Create a client in Keycloak with standard flow and client authentication:

1. In the Admin console select `Clients`
1. Click `Create Client`
1. Enter a `Client ID` (eg wavelog-proxy), click next
1. Toggle `Client authentication` to ON
1. Enter your wavelog URL to secure against open redirects
    1. `Root URL`: `https://wavelog.example.com/`
    1. `Home URL`: `https://wavelog.example.com/`
    1. `Valid redirect URIs`: `https://wavelog.example.com/*`
    1. `Valid post logout redirect URIs`: `https://wavelog.example.com/*`
1. Save

## Configure OAuth2-Proxy

OAuth2-Proxy can be configured to handle web traffic directly or handle `proxy_pass`, see [OAuth2-Proxy docs](https://github.com/oauth2-proxy/oauth2-proxy) for details.

An example OAuth2-Proxy docker-compose is below:

```yaml
  oauth2-proxy:
    container_name: oauth2-proxy
    image: quay.io/oauth2-proxy/oauth2-proxy:v<Check_Releases_For_Latest>
    command: --config /oauth2-proxy.cfg
    hostname: oauth2-proxy
    volumes:
      - "./oauth2-proxy.cfg:/oauth2-proxy.cfg"
    restart: unless-stopped
    ports:
      - "8080:4180"
```

And an example `oauth2-proxy.cfg`:

```conf
http_address = "0.0.0.0:4180"
upstreams = http://wavelog:80

cookie_secret =
provider = "keycloak-oidc"
email_domains = ["*"]
client_id = "wavelog"
client_secret =
redirect_url = "http://wavelog.example.com/oauth2/callback"
oidc_issuer_url= "http://sso.example.com/"
code_challenge_method="S256"
pass_user_headers=true
set_xauthrequest = true
```

To configure:

- The `cookie_secret` should be 32 byte random, see [Proxy Config](https://oauth2-proxy.github.io/oauth2-proxy/configuration/overview).
- `client_id` must match the Client ID in Keycloak`
- `client_secret` can be found under Keycloak Admin > Clients > Wavelog > Credentials

## Configure Wavelog

Modify your `config.php` to enable authentication with headers:

1. Set `$config['auth_header_enable']` to `true`
1. If users should be automatically created set `$config['auth_header_create']` to `true`

OAuth2-Proxy prefixes headers with `X-Forwarded` and Wavelog adds `HTTP-` prefix. Header names are in all caps.

1. Username is `$config['auth_headers_username'] = "HTTP_X_FORWARDED_PREFERRED_USERNAME";`
1. Email is `$config['auth_headers_email'] = "HTTP_X_FORWARDED_EMAIL";`
1. The login page display text is controlled by `$config['auth_header_text']`

## Callsign from OIDC

OAuth2-Proxy does not support custom OpenID Connect claims in headers as a stable feature. However standard claims like `groups` can be used.
