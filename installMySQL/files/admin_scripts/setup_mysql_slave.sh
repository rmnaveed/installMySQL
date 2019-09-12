#!/bin/bash

MASTER_CONNECTION_STRING=' --login-path=bup -h  '$1

MASTER_BINLOG_FILE=$(mysql  $MASTER_CONNECTION_STRING -s -N -e "show master status" |awk -F " " '{print  $1}')
MASTER_BINLOG_POS=$(mysql  $MASTER_CONNECTION_STRING -s -N -e "show master status" |awk -F " " '{print  $2}')


sed 's/server-id=1/server-id=2/g' /etc/my.cnf > /apps/mysql/my.cnf.temp
mv  /apps/mysql/my.cnf.temp /apps/mysql/my.cnf
echo $MASTER_BINLOG_FILE
echo $MASTER_BINLOG_POS

CHANGE_MASTER_STATEMENT="CHANGE MASTER TO MASTER_HOST ='"$1"', MASTER_PORT=3306, MASTER_USER='svc-mysql-repl', MASTER_PASSWORD='Sky11Rep', MASTER_LOG_FILE='"$MASTER_BINLOG_FILE"',MASTER_LOG_POS="$MASTER_BINLOG_POS
echo $CHANGE_MASTER_STATEMENT

mysql --login-path=dba -e " reset slave all; $CHANGE_MASTER_STATEMENT ;start slave;"
