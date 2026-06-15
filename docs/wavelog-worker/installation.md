# Installation

The Wavelog Worker is distributed as a Docker image. This is the recommended way to run it — no build toolchain required.

A pre-compiled binary and instructions for building from source are also available for setups without Docker.

## Docker (Recommended)

The image is published to the GitHub Container Registry and supports **amd64**, **arm64**, and **arm/v7** (Raspberry Pi).

### 1. Create a config file

Create `config.yaml` based on `config.sample.yaml` in a directory of your choice, for example `/opt/wavelog-worker/config.yaml`:

```yaml
ws_port: 9000        # browsers connect here
internal_port: 9001  # Wavelog PHP calls this port

# Optional: bind addresses. Empty/omitted = listen on all interfaces (0.0.0.0 + ::).
# Tip: restrict the internal API (carries worker_secret) to localhost.
# ws_bind: "0.0.0.0"
# internal_bind: "127.0.0.1"

worker_secret: "your-secret-here-minimum-32-characters"
```

Generate a strong secret with:

```bash
openssl rand -hex 32
```

See [Configuration](configuration.md) for all available options.

### 2. Run the container

```bash
docker run -d \
  --name wavelog-worker \
  --restart unless-stopped \
  -p 9000:9000 \
  -p 9001:9001 \
  -v /opt/wavelog-worker/config.yaml:/app/config.yaml:ro \
  ghcr.io/wavelog/wavelog_worker:latest
```

!!! warning "Internal port"
    Port **9001** (internal API) only needs to be reachable by Wavelog's PHP server.
    If both services run on the same host or Docker network, you can omit `-p 9001:9001`
    and use Docker networking instead.

### 3. Verify it's running

```bash
curl -s -H "X-Worker-Secret: your-secret-here-minimum-32-characters" \
  http://localhost:9001/internal/status | python3 -m json.tool
```

A healthy response looks like this:

```json
{
  "status": "ok",
  "version": "1.0.0",
  "uptime": "2m30s",
  "registered_topics": 0,
  "active_topics": 0,
  "connected_clients": 0,
  "topic_list": [],
  "cluster_nodes": -1
}
```

`cluster_nodes: -1` means single-instance mode (no Redis). That is expected.

---

## Docker Compose

If you run Wavelog with Docker Compose, add the Worker as a service in the same stack:

```yaml
services:
  wavelog:
    image: ghcr.io/wavelog/wavelog:latest
    # ... your existing Wavelog config ...

  wavelog-worker:
    image: ghcr.io/wavelog/wavelog_worker:latest
    restart: unless-stopped
    ports:
      - "9000:9000"   # exposed to browsers
      # 9001 stays internal — Wavelog reaches it via Docker network
    volumes:
      - ./worker/config.yaml:/app/config.yaml:ro
```

With this setup Wavelog's PHP can reach the Worker at `http://wavelog-worker:9001` — use that as the internal URL in the [Wavelog configuration](wavelog-integration.md).

---

## Reverse Proxy (HTTPS / WSS)

Browsers connecting over HTTPS must use a **secure WebSocket** (`wss://`). Set up your reverse proxy to forward WebSocket connections to port 9000.

### Nginx

```nginx
location /worker/ {
    proxy_pass http://127.0.0.1:9000/;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";
    proxy_set_header Host $host;
    proxy_read_timeout 3600s;
}
```

### Apache

```apache
ProxyPass /worker/ ws://127.0.0.1:9000/
ProxyPassReverse /worker/ ws://127.0.0.1:9000/
RewriteEngine on
RewriteCond %{HTTP:Upgrade} websocket [NC]
RewriteRule /worker/(.*) ws://127.0.0.1:9000/$1 [P,L]
```

---

## Binary (Without Docker)

Pre-compiled binaries are attached to each [GitHub release](https://github.com/wavelog/wavelog_worker/releases).

Download the binary for your platform, place `config.yaml` next to it, and run:

```bash
wavelog_worker --config config.yaml
```

### Build from Source

Requires Go 1.24 or later.

```bash
git clone https://github.com/wavelog/wavelog_worker.git
cd wavelog_worker
make
./dist/wavelog_worker --config config.yaml
```

### systemd Service

Create `/etc/systemd/system/wavelog-worker.service`:

```ini
[Unit]
Description=Wavelog Worker
After=network.target

[Service]
User=wavelog-worker
WorkingDirectory=/opt/wavelog_worker
ExecStart=/opt/wavelog_worker/dist/wavelog_worker --config /opt/wavelog_worker/config.yaml
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
```

Enable and start:

```bash
systemctl daemon-reload
systemctl enable --now wavelog-worker
```

---

## Next Step

Continue with [Wavelog Integration](wavelog-integration.md) to point your Wavelog instance at the running Worker.
