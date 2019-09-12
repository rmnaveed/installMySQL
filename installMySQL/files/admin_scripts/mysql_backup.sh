#!/bin/bash
#
# For full usage instructions see https://confluence.dev.bbc.co.uk/display/ops3/MySQLMaintenance+Script 
# Now includes GPG 5.6 or 5.5 capability
#
#
# 1. Read Parameters
# -------------------------------------


MYVERSION="MySQLMaintenance v4.4"
THISHOST=$(hostname -s)
JOBTIMESTAMP=`date +%Y%m%d%H%M`
MEB_JOBTIMESTAMP=`date +%Y-%m-%d_%H-%M`
WHEREAMI=`dirname $0`
TODAY=`date "+%A"`
#
PRODUCT_OWNER='MySQL'
PRODUCT="Database"

echo " backup starting at " `date`

# ------------------------------------

if [ -z $1 ]; then
     echo "Usage: $0 <config_file>"
     exit 1
fi

CONFIG_FILE=${WHEREAMI}/${1}

if [ ! -r $CONFIG_FILE ]; then
     echo "Can't read $CONFIG_FILE"
     exit 1
fi

. $CONFIG_FILE

MYSQL_BACKUPFILE=$MYSQL_BACKUPDIR/bkupFullDB.dmp.${JOBTIMESTAMP}.gz


mysqldump $CONNECTSTRING --all-databases  --triggers --events  --master-data=2 --quick --single-transaction --routines | gzip > $MYSQL_BACKUPFILE


#Delete old backup files
    echo "Deleting old backup files for database ${MYDATABASE}"
    
find /apps/mysql/backup -name "bkupFullDB.dmp.*.gz" -mtime +${BACKUP_RETENTION} -print | while read file_name
    do
        rm $file_name
        echo "Backup file $file_name deleted @ $(date)"
    done




echo "finishing at " `date`




