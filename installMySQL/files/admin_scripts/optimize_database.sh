#!/bin/bash



#Generate database table list for Optimising database

mysql  --login-path=dba -Ns -e "select concat('OPTIMIZE NO_WRITE_TO_BINLOG TABLE ',table_schema,'.',table_name,';') from information_schema.tables where table_schema not in ('information_schema','mysql','performance_schema','sys')" >/apps/mysql/admin_scripts/optimiselist.info

#Optimising databases
cat /apps/mysql/admin_scripts/optimiselist.info | while read MYTABLE
do
    echo "Optimizing database ... ${MYTABLE} @ $(date)"
    mysql --login-path=dba -e "${MYTABLE}"
done

