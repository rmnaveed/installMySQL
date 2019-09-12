GRANT REPLICATION SLAVE ON *.* TO 'svc-mysql-repl'@'%';
GRANT REPLICATION CLIENT ON *.* TO 'svc-mysql-mon'@'%'; 
GRANT SELECT ON `mysql`.* TO 'svc-mysql-mon'@'%'; 
GRANT ALL PRIVILEGES ON *.* TO 'svc-mysql-backup'@'%'; 
GRANT SELECT, PROCESS, SHOW DATABASES, SUPER, REPLICATION CLIENT, CREATE USER ON *.* TO 'svc-mysql-agent'@'%' WITH GRANT OPTION;
GRANT INSERT, CREATE ON `mysql`.* TO 'svc-mysql-agent'@'%';
GRANT UPDATE ON `performance_schema`.`threads` TO 'svc-mysql-agent'@'%';
GRANT ALL PRIVILEGES ON *.* TO 'mysqladmin'@'%' WITH GRANT OPTION;

