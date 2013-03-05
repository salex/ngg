#!/bin/bash
#backup.sh
logfile=~/Public/backups/logfile.log
# Location to place backups.
backup_dir=~/Public/backups
touch $logfile
timeslot=`date +%Y%m%d`
databases=("ngg_development" "ngg_production")
# get length of an array
tLen=${#databases[@]}
for (( i=0; i<${tLen}; i++ )); do
echo "Vacuum Starting at `date` for database: ${databases[$i]} " >> $logfile
psql -c "vacuum verbose analyze" -d ${databases[$i]} -U postgres >> $logfile
echo "Vacuum completed. Backup Starting at `date` for database: ${databases[$i]} " >> $logfile
pg_dump ${databases[$i]} -h 127.0.0.1  -U postgres | gzip > "$backup_dir/${databases[$i]}-$timeslot-backup.gz"
echo "Backup and Vacuum complete at `date` for database: ${databases[$i]} " >> $logfile
done
# -h 127.0.0.1  -U postgres