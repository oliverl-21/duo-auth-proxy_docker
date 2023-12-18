# Cisco DUO Authproxy
Builds Container for DUO Auth Proxy based on latest version.
Reference: https://duo.com/docs/authproxy-reference#overview

Base Image: https://hub.docker.com/_/debian `debian:stable-slim`

## Usage:

Mount your `authproxy.cfg` in `/opt/duoauthproxy/conf` otherwise the container fails to start
for Container logs to work the logging secion in `[main]`has to be setup correctly

```
[main]
debug=true # true for debugging, otherwise set to false
log_max_files=10
log_max_size=20971520
log_stdout=true # has to be true for container logs

```
