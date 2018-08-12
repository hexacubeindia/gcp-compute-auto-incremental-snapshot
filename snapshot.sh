#!/bin/bash
# Author: L. Anantha Raman
# Script Name: Do Snapshot
# Script Description: Take live snapshots of all disks under a project. Gcloud init should be run for default account and project before execution.
# Company: hexacube India
# Website: www.hexacube.in
# Phone: +91 9003314466
# Email: info@hexacube.in
# Last Updated: 2018-01-11
#
# Snapshot Creation Starts
#
starttime=$(date -d @$(( $(date +"%s") + 19800)) +"%Y-%m-%d-%H-%M")
echo "Snapshot Creation Process started on $starttime"
echo " "
datetimestamp=$(date -d @$(( $(date +"%s") + 19800)) +"%Y-%m-%d---%H-%M-%S")
gcloud compute disks list --format='value(name,zone)'| while read DISK_NAME ZONE; do
  gcloud compute disks snapshot $DISK_NAME --snapshot-names ${DISK_NAME:0:31}---$datetimestamp --zone $ZONE
done
#
# Snapshot Creation Ends
# Old Snapshot Deletion Starts
#
gcloud compute snapshots list --filter="creationTimestamp<$(date -d "-31 days" "+%Y-%m-%d")" --uri | while read -r SNAPSHOT_URI; do
   gcloud compute snapshots delete "$SNAPSHOT_URI" --quiet
done
echo " "
endtime=$(date -d @$(( $(date +"%s") + 19800)) +"%Y-%m-%d-%H-%M")
echo "Snapshot Creation Process completed on $endtime"
echo " "
echo "List of available snapshots"
echo " "
gcloud compute snapshots list
echo " "
#
# Old Snapshot Deletion Ends
#
