FROM tensorchord/vchord-postgres:pg17-v0.5.2 AS builder

FROM bitnamilegacy/postgresql:17.6.0-debian-12-r4

COPY --from=builder /usr/lib/postgresql/17/lib/vchord.so /opt/bitnami/postgresql/lib/
COPY --from=builder /usr/share/postgresql/17/extension/vchord* /opt/bitnami/postgresql/share/extension/
