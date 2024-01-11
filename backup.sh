#!/bin/bash

# This checks if the number of arguments is correct
# If the number of arguments is incorrect ( $# != 2) print error message and exit
if [[ $# != 2 ]]
then
  echo "backup.sh target_directory_name destination_directory_name"
  exit
fi

# This checks if argument 1 and argument 2 are valid directory paths
if [[ ! -d $1 ]] || [[ ! -d $2 ]]
then
  echo "Invalid directory path provided"
  exit
fi

# [TASK 1]
targetDirectory=$1
destinationDirectory=$2

# [TASK 2]
# confirm to user their selected directories
echo "Confirming that the Target directory is: $1"
echo "Confirming that the Destination directory is: $2"

# [TASK 3]
# Get the current time in seconds
# use '' instead of $() per example
currentTS=`date +%s`

# [TASK 4]
# make the backup file name
# will add the current time stamp to it
backupFileName="backup-$currentTS.tar.gz"

# We're going to:
  # 1: Go into the target directory
  # 2: Create the backup file
  # 3: Move the backup file to the destination directory

# To make things easier, we will define some useful variables...

# [TASK 5]
# Save directory where we started
# pwd to get the present workign directory and save it
origAbsPath=`pwd`  

# [TASK 6]
# Get the full path to the destination directory
# cd to the destination location stored as var $2
# use pwd to get path and save it
cd $2 
destDirAbsPath=`pwd` #store the new complete path using pwd

# [TASK 7]
# move to the target directory
cd $origAbsPath # change dir back to the strarting location
cd $targetDirectory  # now change to the target location 

# [TASK 8]
# current time stamp is in seconds
# to get yesterday's time, subtract 1 day's worth of seconds
# 24 hrs in a day * 60 min/day * 60 sec/min = sec/day
# currentTS - that math $((math)) = yesterdayTS
yesterdayTS=$(($currentTS - 24 * 60 * 60)) 
 
# make an array called toBackup
declare -a toBackup

# Going to make a list of files to backup: 
# Get a list of files and directories in the current folder
# can use 'ls' to list the directories and folders
# Then, look to see if any file was modified since the day before
# can use a for loop to iterate over the files in the ls list
# 'date -r $file +%s' will give the modification date for the file provided to the date command
# if the file mod time is larger than yesterday's time stamp, 
# then, add the file to the arry list toBackup 

for file in $(ls) # [TASK 9]
do
  # [TASK 10]
  if ((`date -r $file +%s` > $yesterdayTS))
  then
    # [TASK 11]
    toBackup+=($file)
  fi
done

# [TASK 12]
# compress and archive the files in the list just created
# tar -c create -z gzip -v verbose -f to file <output name> <input list>
tar -czvf $backupFileName ${toBackup[@]}

# [TASK 13]
# backup was created in current working directory
# move it to the destination location
mv $backupFileName $destDirAbsPath

# Congratulations! You completed the final project for this course!
