#!/bin/bash

####################### VARIABLES #######################
#########################################################

todayutc=$(date '+%Y-%m-%d')
todayfile=$(date -d @$(( $(date +"%s") + 19800)) +"%Y-%m-%d-%H-%M")

##################### VARIABLES ENDS ####################
#########################################################

#---------------------------------------------------------------------------------------------------------------------------#

echo " "
echo "Snapshot backup process started at $todayfile"
echo " "
sleep 1

#---------------------------------------------------------------------------------------------------------------------------#

# loop through all disks within this project  and create a snapshot
gcloud compute disks list --format='value(name,zone)'| while read DISK_NAME ZONE; do
  gcloud compute disks snapshot $DISK_NAME --snapshot-names snap-${DISK_NAME:0:31}-$todayfile --zone $ZONE
done
#
# snapshots are incremental and dont need to be deleted, deleting snapshots will merge snapshots, so deleting doesn't loose anything
# having too many snapshots is unwiedly so this script deletes them after 60 days
#
if [[ $(uname) == "Linux" ]]; then
  from_date=$(date -d "-35 days" "+%Y-%m-%d")
else
  from_date=$(date -v -35d "+%Y-%m-%d")
fi
gcloud compute snapshots list --filter="creationTimestamp<$from_date" --regexp "(autogcs.*)" --uri | while read SNAPSHOT_URI; do
   gcloud compute snapshots delete $SNAPSHOT_URI
done
#
todayfileend=$(date -d @$(( $(date +"%s") + 19800)) +"%Y-%m-%d-%H-%M")
echo " "
echo "*****************************************************"
echo " "
echo "Snapshots List:"
echo " "
gcloud compute snapshots list
echo " "
echo "*****************************************************"
echo " "
echo "Snapshot backup process completed at $todayfileend"
echo " "
