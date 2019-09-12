# installMySQL

Please download Ansible role installMySQL and install_mysql.yml playbook and follow the following instructions

Create two centos 7 hosts

Add ssh keys to your Ansible Machine / server.

Execute following command to create master-slave MySQL 8 environment.

ansible-playbook install_mysql.yml -e 'master_host=[master_host] slave_host=[slave host] '

Login to any machine to access mysql prompt.

Contact me for MySQL root passwords.
