# Cisco DUO Authproxy 6.5.1

- [Repo](https://github.com/oliverl-21/duo-auth-proxy_docker)
- [Issues](https://github.com/oliverl-21/duo-auth-proxy_docker/issues)

Builds Container for DUO Authproxy based on latest version.

- Reference: https://duo.com/docs/authproxy-reference#overview
- DUO Release Notes: https://duo.com/docs/authproxy-notes
- Base Image: `debian:stable-slim`, `almalinux:minimal`

The Container is build weekly with the latest DUO Authproxy version and Container Image updates.

## Usage:

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
---
version: '3'
services:
  duo-auth-proxy:
    image: oliverl21/duo-auth-proxy
    container_name: duo-authproxy
    restart: always
    volumes:
      - /opt/docker/duo-authproxy/log:/opt/duoauthproxy/log
      - /opt/docker/duo-authproxy/conf/authproxy.cfg:/opt/duoauthproxy/conf/authproxy.cfg
    ports:
      - 1812:1812/udp
      - 1813:1813/udp
```

## To-Do:

- [ ] if DUO fixes the dependencies switch to `alpine:3` as Base image.
- [x] publish `aarch64` version
- [x] publish image with `alma:minimal`
