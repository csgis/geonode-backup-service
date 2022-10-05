# geonode-backup-service

This service takes Backups of a GeoNode Instance

> Warning: Needs to be tested with geonode 4

An example to run this service via `docker-compose`

```
  backup_service:
    container_name: geonode_backup-service
    # Place of Dockerfile
    build: ./service-backups/
    links:
     - "db"
    volumes:
      - ./backups:/backups/
      - statics:/geonode_statics/
      - geoserver-data-dir:/geoserver-data-dir/
    restart: on-failure
    env_file:
      - .env_production
    environment:
      - DAYS_TO_KEEP=21
      - DATABASE=${GEONODE_DATABASE}
      - DATABASE_GEO=${GEONODE_GEODATABASE}
      - HOSTNAME=example.com
 ```
