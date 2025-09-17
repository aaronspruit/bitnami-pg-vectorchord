FROM tensorchord/vchord-postgres:pg17-v0.4.3 AS builder

FROM bitnami/postgresql:17.6.0-debian-12-r0

COPY --from=builder /usr/lib/postgresql/17/lib/vchord.so /opt/bitnami/postgresql/lib/
COPY --from=builder /usr/share/postgresql/17/extension/vchord* /opt/bitnami/postgresql/share/extension/
