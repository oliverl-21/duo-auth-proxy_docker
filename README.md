# Cisco DUO Authproxy 6.5.1

- [Repo](https://github.com/oliverl-21/duo-auth-proxy_docker)
- [Issues](https://github.com/oliverl-21/duo-auth-proxy_docker/issues)

Builds Container for DUO Authproxy based on latest version.

- Reference: https://duo.com/docs/authproxy-reference#overview
- DUO Release Notes: https://duo.com/docs/authproxy-notes
- Base Image: `debian:stable-slim`, `almalinux:minimal`

The Container is build weekly with the latest DUO Authproxy version and Container Image updates.

## Usage:
To register your Duo Authenticaton Proxy, create `duo_enrollment.key` in your docker compose directory. Add your enrollment key on the first line of that file, from the Duo Admin authentication proxy section.

Create the following directories in your docker compose directory:
- `./log`
- `./conf`
- `./etc/duoauthproxy`
- `./entrypoint`

Create the entrypoint.sh script in `.entrypoint`
```
#!/bin/bash
set -e

if [ ! -f /etc/duoauthproxy/secrets ]; then
  echo "Running Duo SSO enrollment..."
  key=$(cat /run/secrets/duo_enrollment_key)
  /opt/duoauthproxy/bin/authproxy_update_sso_enrollment_code "$key" \
    && /opt/duoauthproxy/bin/authproxyctl restart
else
        echo "Skipping Enrollment as already enrolled."
fi

# Run cmd
exec /opt/duoauthproxy/bin/authproxy
```

Mount your `authproxy.cfg` in `/opt/duoauthproxy/conf` otherwise the container fails to start.
For Container logs to work the logging secion in `[main]`has to be setup correctly

### authproxy.cfg

```ini
[main]
# true for debugging, otherwise set to false
debug=true
log_max_files=10
log_max_size=20971520
# has to be true for container logs
log_stdout=true

```

### Docker-compose

```
services:
  duo-auth-proxy:
    image: oliverl21/duo-auth-proxy
    container_name: duo-authproxy
    restart: always
    volumes:
      - ./log:/opt/duoauthproxy/log
      - ./conf/authproxy.cfg:/opt/duoauthproxy/conf/authproxy.cfg
      - ./entrypoint:/opt/duoauthproxy/entrypoint
      - ./etc/duoauthproxy:/etc/duoauthproxy
    ports:
      - 1812:1812/udp
      - 1813:1813/udp
    networks:
      - duoproxy
    entrypoint: /opt/duoauthproxy/entrypoint/entrypoint.sh
    secrets:
      - duo_enrollment_key

secrets:
  duo_enrollment_key:
    file: ./duo_enrollment.key

networks:
  duoproxy:
```

The directory structure should look like:
```
duoproxy/                              # Root directory
├── docker-compose.yml                 # Main Compose file
├── duo_enrollment.key                 # 🔐 Docker secret (enrollment token)
├── entrypoint/                        # Entrypoint script logic
│   └── entrypoint.sh
├── conf/                              # Contains authproxy.cfg
│   └── authproxy.cfg
├── log/                               # Duo Auth Proxy logs
└── etc/
    └── duoauthproxy/                  # Location for secret key storage (secrets)
```

## To-Do:

- [ ] if DUO fixes the dependencies switch to `alpine:3` as Base image.
- [x] publish `aarch64` version
- [x] publish image with `alma:minimal`
