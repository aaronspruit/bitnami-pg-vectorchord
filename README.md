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
