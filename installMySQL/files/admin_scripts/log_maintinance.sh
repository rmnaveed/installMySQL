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
ERRORLOG_ROTATION=60
#PSWRD='85ky8.$Ql'

#PATH=$PATH:$DEPLOYDIR/install/bin:/apps/mysql/install/bin

#CONNECTSTRING=" -u mysqladmin -p$PSWRD "

STATUS_SLOWLOG=$( mysql --login-path=dba -e "SHOW VARIABLES LIKE 'slow_query_log'\G"|grep -i "Value"| awk  '{print $2}')

if [ "$STATUS_SLOWLOG" = "ON" ]; then

SLOWLOG=$( mysql --login-path=dba -e "SHOW VARIABLES LIKE 'slow_query_log_file'\G"|grep -i "Value"| awk  '{print $2}')
SLOWLOG_DIR=`dirname "$SLOWLOG"`
SLOWLOG_FILE=`basename "$SLOWLOG"`


echo "Slow Log Rotation Required..." "Remove old logs based on rotation of [$LOG_ROTATION] days"
find $SLOWLOG_DIR/ -name "*aggregated*.gz" -mtime +$LOG_ROTATION -exec rm {} \; 2> /dev/null
NEWSLOWLOG_FILE=$SLOWLOG_FILE.${JOBTIMESTAMP}.log
SQLDUMPSLOWLOG_FILE=${THISHOST}.${MYSQL_PORT}.aggregated.${JOBTIMESTAMP}.log
#echo "slow query log file name is " $SLOWLOG_FILE
#echo "new file name is " $NEWSLOWLOG_FILE
#echo $SQLDUMPSLOWLOG_FILE
#echo mv $SLOWLOG_DIR/$SLOWLOG_FILE $SLOWLOG_DIR/$NEWSLOWLOG_FILE

echo "Creating Aggregated Slow Log File..."
mysqldumpslow $SLOWLOG_DIR/$SLOWLOG_FILE > $SLOWLOG_DIR/$SQLDUMPSLOWLOG_FILE
gzip $SLOWLOG_DIR/$SQLDUMPSLOWLOG_FILE

fi

ERROR_LOG=$( mysql --login-path=dba -e "SHOW VARIABLES LIKE 'log_error'\G"|grep -i "Value"| awk  '{print $2}')
ERRORLOG_DIR=`dirname "$ERROR_LOG"`
ERRORLOG_FILE=`basename "$ERROR_LOG"`
ERROR_LOG_SIZE=`ls -ltr "$ERROR_LOG"|awk -F " " '{print $5}'`
 
echo $ERROR_LOG
echo $ERRORLOG_DIR
echo $ERRORLOG_FILE
echo $ERROR_LOG_SIZE

ARCHIVED_ERRORLG=$ERRORLOG_FILE.${JOBTIMESTAMP}.log



echo "Error Log Rotation Required..." "Remove old logs based on rotation of [$ERRORLOG_ROTATION] days"
find $SLOWLOG_DIR/ -name "mysql-error*.gz" -mtime +$ERRORLOG_ROTATION -exec rm {} \; 2> /dev/null

if [ "$ERROR_LOG_SIZE" -gt 1048576 ]; then 

mv $ERROR_LOG $ERRORLOG_DIR/$ARCHIVED_ERRORLG
gzip $ERRORLOG_DIR/$ARCHIVED_ERRORLG

fi

mysql --login-path=dba -e " flush logs  "





