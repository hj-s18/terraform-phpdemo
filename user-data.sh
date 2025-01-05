#!/bin/bash
git clone -b gitclone https://github.com/hj-s18/terraform-practice.git
mysql -u${db_username} -p${db_password} -h${db_url} ${db_name} < /terraform-practice/create_table_items.sql
