#!/bin/bash
git clone -b terraform https://github.com/uvelyster/cloud-demo.git
mysql -u${db_username} -p${db_password} -h${db_url} ${db_name} < /cloud-demo/create_db_webtest.sql
