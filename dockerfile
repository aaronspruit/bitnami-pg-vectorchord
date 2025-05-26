FROM tensorchord/vchord-postgres:pg17-v0.4.1 AS builder

FROM bitnami/postgresql:17.5.0

COPY --from=builder /usr/lib/postgresql/17/lib/vchord.so /opt/bitnami/postgresql/lib/
COPY --from=builder /usr/share/postgresql/17/extension/vchord* /opt/bitnami/postgresql/share/extension/
