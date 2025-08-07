FROM alpine:latest AS parallel
RUN apk add --no-cache parallel

FROM caddy:latest AS caddy
COPY Caddyfile ./
RUN caddy fmt --overwrite Caddyfile

FROM typesense/typesense:29.0

COPY --from=caddy /srv/Caddyfile ./

COPY --from=caddy /usr/bin/caddy /usr/bin/caddy
COPY --from=parallel /usr/bin/parallel /usr/bin/parallel

COPY --chmod=755 scripts/* ./

ENTRYPOINT ["/bin/sh"]

CMD ["start.sh"]
