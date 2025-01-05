# user-data.sh, /phpdemo/process_create.php 파일 수정

### 1

##### user-data.sh

```bash
#!/bin/bash

git clone -b gitclone https://github.com/hj-s18/terraform-practice.git
mysql -u${db_username} -p${db_password} -h${db_url} ${db_name} < /terraform-practice/create_table_items.sql

export DB_URL=${db_url}
export DB_USER=${db_username}
export DB_PASS=${db_password}
export DB_NAME=${db_name}

sed -i "s/DB_IP/$DB_URL/g" /terraform-practice/process_create.php
sed -i "s/USERNAME/$DB_USER/g" /terraform-practice/process_create.php
sed -i "s/PASSWORD/$DB_PASS/g" /terraform-practice/process_create.php
sed -i "s/DBNAME/$DB_NAME/g" /terraform-practice/process_create.php

cp /terraform-practice/*.php /var/www/html
```

<br>

##### /phpdemo/process_create.php

```bash
<?php

$conn = mysqli_connect("DB_IP","USERNAME","PASSWORD","DBNAME",3306);

$sql = "insert into items (title, description, created) value ('{$_POST['title']}','{$_POST['description']}', now())";

mysqli_query($conn,$sql);
if ($result=== false){
    echo 'error occured.';
    error_log(mysqli_error($conn));
}
echo 'Succeed. <a href="index.php"> back</a>';

?>
```
 
 <br>
 <br>
 
### 2

##### user-data.sh

```bash
#!/bin/bash

git clone -b gitclone https://github.com/hj-s18/terraform-practice.git
mysql -u${db_username} -p${db_password} -h${db_url} ${db_name} < /terraform-practice/create_table_items.sql

export DB_URL=${db_url}
export DB_USER=${db_username}
export DB_PASS=${db_password}
export DB_NAME=${db_name}

cp /terraform-practice/*.php /var/www/html
```

<br>

##### /phpdemo/process_create.php
 
```bash
<?php

$conn = mysqli_connect("$DB_URL","$DB_USER","$DB_PASS","$DB_NAME",3306);

$sql = "insert into items (title, description, created) value ('{$_POST['title']}','{$_POST['description']}', now())";

mysqli_query($conn,$sql);
if ($result=== false){
    echo 'error occured.';
    error_log(mysqli_error($conn));
}
echo 'Succeed. <a href="index.php"> back</a>';

?>
```
 
 <br>
 <br>
 
### 3

##### user-data.sh

```bash
#!/bin/bash

git clone -b gitclone https://github.com/hj-s18/terraform-practice.git
mysql -u${db_username} -p${db_password} -h${db_url} ${db_name} < /terraform-practice/create_table_items.sql

cp /terraform-practice/*.php /var/www/html
```

<br>

##### /phpdemo/process_create.php
 
```bash
<?php

$conn = mysqli_connect("${db_url}","${db_username}","${db_password}","${db_name}",3306);

$sql = "insert into items (title, description, created) value ('{$_POST['title']}','{$_POST['description']}', now())";

mysqli_query($conn,$sql);
if ($result=== false){
    echo 'error occured.';
    error_log(mysqli_error($conn));
}
echo 'Succeed. <a href="index.php"> back</a>';

?>
```
