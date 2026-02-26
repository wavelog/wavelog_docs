# Docker (recommended)

Docker is a tool that runs applications in isolated containers. Instead of installing Wavelog and a database directly on your server, Docker manages both for you — packaged, portable and easy to update. It is our recommended installation method, as it reduces maintenance effort and makes future updates straightforward.

This guide sets up two containers:

- **`wavelog-db`** — the MariaDB database that stores all your QSOs and settings
- **`wavelog-main`** — the Wavelog web application itself

Both containers are defined in a single `docker-compose.yml` file and started with one command. Your data is stored in Docker volumes, so it survives container restarts and updates.

## Prerequisites

Before you start, make sure Docker is installed on your machine. You can verify this with:

```bash
docker --version
docker compose version
```

If either command is not found, install them first:

- [Docker Engine](https://docs.docker.com/engine/install/) (Linux) or [Docker Desktop](https://docs.docker.com/desktop/) (Windows/macOS)
- Docker Compose is included in Docker Desktop and available as a plugin for Linux

## Step 1 — Create the compose file

Create a new folder for Wavelog and save the following as `docker-compose.yml` inside it:

```bash
mkdir ~/wavelog && cd ~/wavelog
```

```yaml
services:
  wavelog-db:
    image: mariadb:11.8
    container_name: wavelog-db
    environment:
      MARIADB_RANDOM_ROOT_PASSWORD: yes
      MARIADB_DATABASE: wavelog
      MARIADB_USER: wavelog
      MARIADB_PASSWORD: wavelog # <- Insert a strong password here
    volumes:
      - wavelog-dbdata:/var/lib/mysql
    restart: unless-stopped

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
    ports:
      - "8086:80"
    restart: unless-stopped

volumes:
  wavelog-dbdata:
  wavelog-uploads:
  wavelog-userdata:
  wavelog-config:
```

!!! danger "Change the password"
    Replace `wavelog` in `MARIADB_PASSWORD` with a strong password **before** starting the stack. You will need it during setup. MariaDB configures itself at the first start with this password. Therefore it has to be set before you start the container.

## Step 2 — Start the stack

Run the following command from the folder where your `docker-compose.yml` is located:

```bash
docker compose up -d
```

The `-d` flag runs the containers in the background. Docker will download the images on first run, which may take a minute. Once complete, check that both containers are running:

```bash
docker ps -a
```

You should see `wavelog-db` and `wavelog-main` listed with status `Up`.

## Step 3 — Run the installer

Open your browser and navigate to this URL:

!!! note "Reverse Proxy in place?"
    If you have an reverse proxy in place you might want to directly call the final URL since Wavelog will configure itself to the URL you are calling the installer. Although it can be changed later you have save the extra work and call the final URL diretcly.

```text
http://[your-server-ip]:8086/install
```

Go through the installer. Everything important is explained there. Make sure you read the stuff and understand.

!!! info
    The DB Hostname is `wavelog-db` — the name of the database container in your stack, not `localhost`.

Reaching the last step in the installer click **Install**. Wavelog will create its database tables and redirect you to the login page. This process can take a few minutes on slow systems!

## Reverse proxy

By default, Wavelog is accessible on port `8086`. If you want to serve it on a proper domain (e.g. `wavelog.example.com`) you need a reverse proxy. Here is a minimal nginx configuration:

```nginx
server {
    listen 80;
    server_name wavelog.example.com;

    location / {
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_pass http://127.0.0.1:8086;
    }

    error_page 500 502 503 504 /50x.html;
    location = /50x.html {
        root /usr/share/nginx/html;
    }
}
```

!!! tip
    It is strongly recommended to serve Wavelog over HTTPS. See [webserver configuration](../../admin-guide/configuration/webserver.md) for a full example with SSL.

## Next steps

### Tweaking config.php

Check out the [configuration guide](../../admin-guide/configuration/config-php.md) to find out how to tweak `config.php` for your needs.
In a docker setup you will find the config file **after** the installation in the `wavelog-config` volume. You can edit it there. A restart of the `wavelog-main` container is not required, changes are applied immediately.

This file must not exist before the installation, otherwise the installer will not run. During the installation, it is copied to the right place and can be edited there. If you want to reset the installation, see the guide here: [Resetting the installation](../../admin-guide/maintenance/reset.md).

### Debugging

If something is not working, check the container logs first:

```bash
# Stream live logs from the Wavelog container
docker logs --follow wavelog-main
```

For more detail, raise the `log_threshold` value in `config.php` (see above). Application logs are then written to `/var/www/html/application/logs` inside the container.

### Cronjobs

The cron manager is enabled by default in the Docker image. Jobs can be managed in the web UI under **Admin → Cron Manager** — no manual crontab setup required.
