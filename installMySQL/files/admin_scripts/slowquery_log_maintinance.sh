#!/bin/bash

#************************************************************************#
# Auther = Raja M Naveed                                                 #
# Details= Script to tidy up slow log direcotry                          #
#                                                                        #
#************************************************************************
THISHOST=$(hostname -s)
MYSQL_PORT=3306
JOBTIMESTAMP=`date +%Y%m%d%H%M`
LOG_ROTATION=7
#PSWRD='85ky8.$Ql'

#PATH=$PATH:$DEPLOYDIR/install/bin:/apps/mysql/install/bin

#CONNECTSTRING=" -u mysqladmin -p$PSWRD "

SLOWLOG=$( mysql --login-path=dba -e "SHOW VARIABLES LIKE 'slow_query_log_file'\G"|grep -i "Value"| awk  '{print $2}')
SLOWLOG_DIR=`dirname "$SLOWLOG"`
SLOWLOG_FILE=`basename "$SLOWLOG"`
echo " slow query log =="$SLOWLOG
echo " slow query log directory="$SLOWLOG_DIR
echo " slow query log file ="$SLOWLOG_FILE

echo "Slow Log Rotation Required..." "Remove old logs based on rotation of [$LOG_ROTATION] days"
#find $SLOWLOG_DIR/ -name "*slow*.gz" -mtime +$LOG_ROTATION -exec rm {} \; 2> /dev/null
#find $SLOWLOG_DIR/ -name "*aggregated*.gz" -mtime +$LOG_ROTATION -exec rm {} \; 2> /dev/null
NEWSLOWLOG_FILE=$SLOWLOG_FILE.${JOBTIMESTAMP}.log
SQLDUMPSLOWLOG_FILE=${THISHOST}.${MYSQL_PORT}.aggregated.${JOBTIMESTAMP}.log
echo "new file name is " $NEWSLOWLOG_FILE
echo $SQLDUMPSLOWLOG_FILE
echo mv $SLOWLOG_DIR/$SLOWLOG_FILE $SLOWLOG_DIR/$NEWSLOWLOG_FILE

echo "Creating Aggregated Slow Log File..."
mysqldumpslow $SLOWLOG_DIR/$NEWSLOWLOG_FILE > $SLOWLOG_DIR/$SQLDUMPSLOWLOG_FILE
gzip $SLOWLOG_DIR/$NEWSLOWLOG_FILE
gzip $SLOWLOG_DIR/$SQLDUMPSLOWLOG_FILE
