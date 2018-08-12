#!/bin/bash
# Author: L. Anantha Raman
# Designation: CTO
# Company: hexacube India
# Website: www.hexacube.in
# Phone: +91 9003314466
#
# Old Snapshot Deletion Starts
#
if [[ $(uname) == "Linux" ]]; then
  from_date=$(date -d "-29 days" "+%Y-%m-%d")
else
  from_date=$(date -v -29d "+%Y-%m-%d")
fi
gcloud compute snapshots list --filter="creationTimestamp<$from_date" --uri | while read SNAPSHOT_URI; do
   gcloud compute snapshots delete $SNAPSHOT_URI
done
#
# Old Snapshot Deletion Ends
#
# Snapshot Creation Starts
#
gcloud compute disks list --format='value(name,zone)'| while read DISK_NAME ZONE; do
  gcloud compute disks snapshot $DISK_NAME --snapshot-names autogcs-${DISK_NAME:0:31}-$(date "+%Y-%m-%d-%s") --zone $ZONE
done
#
# Snapshot Creation Ends
