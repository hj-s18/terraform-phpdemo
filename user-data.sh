#!/bin/bash
git clone -b create-table https://github.com/hj-s18/phpdemo.git
mysql -u${db_username} -p${db_password} -h${db_url} ${db_name} < /phpdemo/create_table_items.sql
