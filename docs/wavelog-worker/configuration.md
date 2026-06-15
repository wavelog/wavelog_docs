# Configuration Reference

The Worker is configured through a single YAML file, passed via the `--config` flag (default: `config.yaml` in the working directory).

## Full Example

```yaml
# config.yaml

ws_port: 9000        # WebSocket port — browsers connect here
internal_port: 9001  # Internal API port — Wavelog PHP connects here

# Shared secret — must match the value in Wavelog's worker.php config.
# Minimum 32 characters. Generate with: openssl rand -hex 32
worker_secret: "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

# Optional: Redis URL for multi-instance clustering.
# Omit or leave empty for single-instance mode.
# redis_url: "redis://localhost:6379/2"
```

---

## Options Reference

### `ws_port`

| | |
|---|---|
| **Type** | integer |
| **Default** | `9000` |
| **Required** | No |

The TCP port on which the Worker listens for incoming WebSocket connections from browsers.

Browsers connect to `ws://your-host:9000/ws?topic=<topic>`. When using a reverse proxy for HTTPS, this port does not need to be publicly exposed.

---

### `internal_port`

| | |
|---|---|
| **Type** | integer |
| **Default** | `9001` |
| **Required** | No |

The TCP port for the internal HTTP API. Wavelog's PHP backend uses this port to:

- Register and unregister topics
- Publish broadcast events to connected clients
- Query the Worker's status

This port should **not** be exposed to the internet. Restrict it to your internal network or Docker network.

---

### `ws_bind`

| | |
|---|---|
| **Type** | string |
| **Default** | `0.0.0.0` |
| **Required** | No |

The IP Addres which is the websocket service is bind to. This is the IP which needs to be reachable from the outside world by
using a reverse proxy.

---

### `internal_bind`

| | |
|---|---|
| **Type** | string |
| **Default** | `127.0.0.1` |
| **Required** | No |

The IP address for the internal communication with Wavelog. This port needs ONLY be reachable by Wavelog itself. If the Wavelog Worker
is running on the same host, this IP should be set to 127.0.0.1. Otherwise make sure you set up a proper firewall.

---

### `worker_secret`

| | |
|---|---|
| **Type** | string |
| **Default** | — |
| **Required** | **Yes** |
| **Minimum length** | 32 characters |

A shared secret that authenticates all communication between Wavelog's PHP backend and the Worker. Every request to the internal API must include this value in the `X-Worker-Secret` HTTP header.

The same secret must be configured on the Wavelog side in `application/config/worker.php`.

**Generate a secret:**

```bash
openssl rand -hex 32
```

!!! warning "Keep it secret"
    Treat `worker_secret` like a password. Anyone who knows it can push arbitrary
    messages to all connected clients. Never expose it in logs or version control.

---

### `redis_url`

| | |
|---|---|
| **Type** | string |
| **Default** | *(empty — single-instance mode)* |
| **Required** | No |

A Redis connection URL. When set, the Worker uses Redis Pub/Sub to synchronize broadcast events across multiple Worker instances.

```yaml
redis_url: "redis://localhost:6379/2"
```

The URL format follows the standard Redis URL scheme:

```text
redis://[:password@]host[:port][/db]
rediss://...   # TLS
```

Use a dedicated Redis database (e.g. `/2`) to avoid key collisions with other applications.

When `redis_url` is empty or omitted, the Worker runs in **single-instance mode**: all state is in-memory and lost on restart. Topics are automatically re-registered by Wavelog on the next page load.

See [Clustering](clustering.md) for when and how to use Redis.

---

## Defaults Summary

| Option | Default |
|---|---|
| `ws_port` | `9000` |
| `internal_port` | `9001` |
| `worker_secret` | *(none — required)* |
| `redis_url` | *(empty — single-instance)* |

---

## Ports Overview

```text
┌──────────────────────────────────────────┐
│              Wavelog Worker              │
│                                          │
│  :9000  WebSocket ──► browsers           │
│  :9001  Internal API ──► Wavelog PHP     │
└──────────────────────────────────────────┘
```

| Port | Direction | Who connects |
|---|---|---|
| 9000 (WS) | Inbound | Browsers, via reverse proxy |
| 9001 (Internal) | Inbound | Wavelog PHP only |
