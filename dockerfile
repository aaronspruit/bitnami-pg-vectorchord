FROM tensorchord/vchord-postgres:pg16-v0.3.0 AS builder
FROM tensorchord/pgvecto-rs:pg16-v0.2.1 AS builder2

FROM bitnami/postgresql:16.4.0

COPY --from=builder /usr/lib/postgresql/17/lib/vchord.so /opt/bitnami/postgresql/lib/
COPY --from=builder /usr/share/postgresql/17/extension/vchord* /opt/bitnami/postgresql/share/extension/
COPY --from=builder2 /usr/lib/postgresql/17/lib/vector.so /opt/bitnami/postgresql/lib/
COPY --from=builder2 /usr/share/postgresql/17/extension/vector* /opt/bitnami/postgresql/share/extension/
