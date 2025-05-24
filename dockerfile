FROM tensorchord/vchord-postgres:pg16-v0.3.0 AS builder
FROM tensorchord/pgvecto-rs:pg16-v0.4.0 AS builder2
FROM pgvector/pgvector:pg16 as builder3

FROM bitnami/postgresql:16.4.0

COPY --from=builder /usr/lib/postgresql/16/lib/vchord.so /opt/bitnami/postgresql/lib/
COPY --from=builder /usr/share/postgresql/16/extension/vchord* /opt/bitnami/postgresql/share/extension/
COPY --from=builder2 --chown=root:root /usr/lib/postgresql/16/lib/vectors.so /opt/bitnami/postgresql/lib/
COPY --from=builder2 --chown=root:root /usr/share/postgresql/16/extension/vector* /opt/bitnami/postgresql/share/extension/
COPY --from=builder3 --chown=root:root /usr/lib/postgresql/16/lib/vector.so /opt/bitnami/postgresql/lib/
COPY --from=builder3 --chown=root:root /usr/share/postgresql/16/extension/vector* /opt/bitnami/postgresql/share/extension/
