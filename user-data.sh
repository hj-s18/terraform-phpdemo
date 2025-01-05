#!/bin/bash

git clone -b gitclone https://github.com/hj-s18/terraform-practice.git                                          # GitHub 저장소의 특정 브랜치를 로컬로 클론 (클론한 파일은 phpdemo 라는 디렉토리에 저장됨)
mysql -u${db_username} -p${db_password} -h${db_url} ${db_name} < /terraform-practice/create_table_items.sql     # MySQL 데이터베이스에 연결하여 스키마 파일 실행
                                                                                                                  # -u : MySQL 사용자 이름 / -p : MySQL 비밀번호 / -h : 데이터베이스 서버 URL
                                                                                                                  # ${db_username}, ${db_password}, ${db_url} ${db_name} : 스크립트를 실행할 때 전달받은 환경 변수


                                                                                                                # 현재 셸 환경에서 사용할 환경 변수로 데이터베이스 관련 정보 설정

export DB_URL=${db_url}                                                                                         # DB_URL 변수 등록
export DB_USER=${db_username}                                                                                   # DB_USER 변수 등록
export DB_PASS=${db_password}                                                                                   # DB_PASS 변수 등록
export DB_NAME=${db_name}                                                                                       # DB_NAME 변수 등록


                                                                                                                # PHP 파일에서 미리 정의된 템플릿 값을 실제 데이터베이스 정보로 치환
                                                                                                                  # -i 옵션 : 파일을 직접 수정

sed -i "s/DB_IP/$DB_URL/g" /terraform-practice/process_create.php                                               # 파일 내 DB_IP를 DB_URL로 치환
sed -i "s/USERNAME/$DB_USER/g" /terraform-practice/process_create.php                                           # 파일 내 USERNAME를 DB_USER로 치환
sed -i "s/PASSWORD/$DB_PASS/g" /terraform-practice/process_create.php                                           # 파일 내 PASSWORD를 DB_PASS로 치환
sed -i "s/DBNAME/$DB_NAME/g" /terraform-practice/process_create.php                                             # 파일 내 DBNAME를 DB_NAME로 치환





cp /phpdemo/*.php /var/www/html                                                                                 # terraform-practice 디렉토리의 모든 .php 파일을 웹 서버의 루트 디렉토리 /var/www/html로 복사





:<<'END'
# /terraform-practice/process_create.php 파일

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
END
