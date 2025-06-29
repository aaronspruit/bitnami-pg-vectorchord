# Bitnami Postgres images w/ VectorChord

I'm using the [Bitnami postgres helm](https://github.com/bitnami/charts/blob/main/bitnami/postgresql/README.md) chart as my backing store for immich.  I'm not using the immich helm chart.  [Immich requires](https://immich.app/docs/administration/postgres-standalone/) [Vectorchord](https://docs.vectorchord.ai/) installed, which isn't part of the bitnami image.  The images built in this repo and the subseqent configs are how I get immich working.

## Usage

The images in this repo are a drop in replacement for bitnami postgres debian container for the bitnami postgres helm chart. Just swap the image with mine.  To get this to work with immich, you'll need to have at least the following config in you `values.yaml`.

```yaml
image:
  registry: ghcr.io
  repository: aaronspruit/bitnami-pg-vectorchord
  tag: pg17.5.0-v0.3.0
  pullPolicy: Always
  debug: true
global:
  security:
    allowInsecureImages: true
primary:
  # this adds the libraries
  extendedConfiguration: |-
    shared_preload_libraries = 'vchord.so'
  initdb:
    user: postgres
    scripts: 
      # need to restart the server FIRST for the share libraries to load
      # https://stackoverflow.com/questions/48069718/creating-pg-cron-extension-within-docker-entrypoint-initdb-d-fails/51797554#51797554
      00-restart.sh: |
        #!/bin/sh
        pg_ctl restart
      # this script installs the extension & prints running extensions in app DB
      01-create-extensions.sql: |
        CREATE EXTENSION IF NOT EXISTS "vchord" CASCADE;
        CREATE EXTENSION IF NOT EXISTS "earthdistance" CASCADE;
        SELECT * FROM pg_extension;
```

## Upgrading

As per [Immich](https://immich.app/docs/administration/postgres-standalone#updating-vectorchord), if you're not running as superuser (by default this image will not) you need to manually run the upgrade with the following commands

```sql
ALTER EXTENSION vchord UPDATE;
REINDEX INDEX face_index;
REINDEX INDEX clip_index;
```



## Additional Info
Tag [pg16.4.0-v0.3.0](https://github.com/aaronspruit/bitnami-pg-vectorchord/tree/pg16.4.0-v0.3.0) and the subsequent [image with the same name](https://github.com/aaronspruit/bitnami-pg-vectorchord/pkgs/container/bitnami-pg-vectorchord/422950542?tag=pg16.4.0-v0.3.0) includes pgvecto.rs, pgvecto, and vectorchord which will help with migrations to 1.133.0.  Once I finished the migration, I removed pgvector.rs from the image for pg17.  However, via that tag, you can see how I was adding the required pieces.
