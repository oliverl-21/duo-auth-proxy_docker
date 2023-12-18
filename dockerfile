FROM debian:stable-slim as base
RUN apt update && apt upgrade -y && apt-get clean

FROM base AS builder
RUN apt update && apt install wget python3-pip build-essential libssl-dev libffi-dev -y && apt-get clean
RUN mkdir /src && wget https://dl.duosecurity.com/duoauthproxy-latest-src.tgz
RUN tar xvf duoauthproxy-latest-src.tgz -C /src/
RUN cd /src/duoauthproxy-* && make && mv duoauthproxy-build /src/duoauthproxy-build

FROM base as app
RUN --mount=type=cache,from=builder,source=/src/duoauthproxy-build,target=/src/duoauthproxy-build ./src/duoauthproxy-build/install --install-dir /opt/duoauthproxy --service-user duo_authproxy_svc --log-group duo_authproxy_grp --create-init-script yes

ENTRYPOINT ["/opt/duoauthproxy/bin/authproxy"]
