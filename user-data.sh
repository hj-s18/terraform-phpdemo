#!/bin/bash

git clone -b gitclone https://github.com/hj-s18/phpdemo.git
mysql -u${db_username} -p${db_password} -h${db_url} ${db_name} < /phpdemo/create_table_items.sql

export DB_URL=${db_url}
sed -i "s/DB_IP/$DB_URL/g" /phpdemo/process_create.php

export DB_USER=${db_username}
sed -i "s/root/$DB_USER/g" /phpdemo/process_create.php

export DB_PASS=${db_password}
sed -i "s/Test123!/$DB_PASS/g" /phpdemo/process_create.php

cp /phpdemo/*.php /var/www/html
