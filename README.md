# Cisco DUO Authproxy

- [Repo](https://github.com/oliverl-21/duo-auth-proxy_docker)
- [Issues](https://github.com/oliverl-21/duo-auth-proxy_docker/issues)

Builds Container for DUO Auth Proxy based on latest version.
Reference: https://duo.com/docs/authproxy-reference#overview

Base Image: https://hub.docker.com/_/debian `debian:stable-slim`

## Usage:

Mount your `authproxy.cfg` in `/opt/duoauthproxy/conf` otherwise the container fails to start.
For Container logs to work the logging secion in `[main]`has to be setup correctly

### authproxy.cfg
```ini
[main]
debug=true # true for debugging, otherwise set to false
log_max_files=10
log_max_size=20971520
log_stdout=true # has to be true for container logs

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
