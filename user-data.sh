#!/bin/bash

git clone -b gitclone https://github.com/hj-s18/terraform-phpdemo.git
mysql -u${db_username} -p${db_password} -h${db_url} ${db_name} < /terraform-phpdemo/create_table_items.sql

export DB_URL=${db_url}
export DB_USER=${db_username}
export DB_PASS=${db_password}
export DB_NAME=${db_name}

sed -i "s/DB_IP/$DB_URL/g" /terraform-phpdemo/process_create.php
sed -i "s/USERNAME/$DB_USER/g" /terraform-phpdemo/process_create.php
sed -i "s/PASSWORD/$DB_PASS/g" /terraform-phpdemo/process_create.php
sed -i "s/DBNAME/$DB_NAME/g" /terraform-phpdemo/process_create.php

cp /terraform-phpdemo/*.php /var/www/html
