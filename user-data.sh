#!/bin/bash
git clone -b gitclone https://github.com/hj-s18/terraform-phpdemo.git
mysql -u${db_username} -p${db_password} -h${db_url} ${db_name} < /terraform-phpdemo/create_table_items.sql
