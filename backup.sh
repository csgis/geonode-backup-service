#!/bin/sh

NOW=$( date '+%d-%m-%y' )

# Create directories
BPTH=/backups/backup_${NOW}
mkdir -p ${BPTH}

DPTH=${BPTH}/databases
mkdir -p ${DPTH}

SPTH=${BPTH}/statics
mkdir -p ${SPTH}

GPTH=${BPTH}/geoserver-data-dir
mkdir -p ${GPTH}

# Dump databases
pg_dump -h db -U geonode -C -d ${DATABASE} > ${DPTH}/${DATABASE}_daily.pgdump && echo "${DATABASE} dump successful"
pg_dump -h db -U geonode -C -d ${DATABASE_GEO} > ${DPTH}/${DATABASE_GEO}_daily.pgdump && echo "${DATABASE_GEO} dump successful"

# Backup files
rclone copy /geonode_statics ${SPTH} --log-level ERROR && echo "geonode_statics copied successfully"
rclone copy /geoserver-data-dir ${GPTH} --log-level ERROR && echo "geoserver-data-dir copied successfully"

# create archive
tar cvfj /backups/bba-geonode.tar.bz2 ${BPTH} && rm -R ${BPTH}

# Delete old
find /backups -maxdepth 1  -mtime +${DAYS_TO_KEEP} -exec rm -rf {} \; && echo "Clean of /backups dir done"
