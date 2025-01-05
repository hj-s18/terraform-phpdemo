# php 어플리케이션 실행하기

<br>

### EC2 인스턴스에 php 어플리케이션 실행에 필요한 도구들 설치 (코드 잘 작동하는지 확인용)
앞서 테스트용으로 사용했던 EC2 인스턴스(2.Test-EC2-instance)에 php 어플리케이션 실행에 필요한 도구들 추가로 설치

```bash
[ec2-user@프라이빗IP ~]$ vi webserver.sh
[ec2-user@프라이빗IP ~]$ cat webserver.sh
#! /bin/bash

curl -O http://rpms.remirepo.net/enterprise/remi-release-7.rpm
sudo rpm -Uvh remi-release-7.rpm

sudo yum install -y yum-utils
sudo yum-config-manager --enable remi-php72
sudo yum install -y php php-common php-mysqli

sudo systemctl start httpd
sudo systemctl enable httpd

[ec2-user@프라이빗IP ~]$ sh webserver.sh

...[생략]...

Installed:
  php.x86_64 0:5.4.16-46.amzn2.0.5                                  php-common.x86_64 0:5.4.16-46.amzn2.0.5                                  php-mysqlnd.x86_64 0:5.4.16-46.amzn2.0.5

Dependency Installed:
  apr.x86_64 0:1.7.2-1.amzn2.0.1                apr-util.x86_64 0:1.6.3-1.amzn2.0.1                      apr-util-bdb.x86_64 0:1.6.3-1.amzn2.0.1             generic-logos-httpd.noarch 0:18.0.0-4.amzn2
  httpd.x86_64 0:2.4.62-1.amzn2.0.2             httpd-filesystem.noarch 0:2.4.62-1.amzn2.0.2             httpd-tools.x86_64 0:2.4.62-1.amzn2.0.2             libzip010-compat.x86_64 0:0.10.1-9.amzn2.0.5
  mailcap.noarch 0:2.1.41-2.amzn2               mod_http2.x86_64 0:1.15.19-1.amzn2.0.2                   php-cli.x86_64 0:5.4.16-46.amzn2.0.5                php-pdo.x86_64 0:5.4.16-46.amzn2.0.5

Complete!
```

<br>
<br>
 
## 콘솔에서 이미지 생성하기
 
<br>
 
### 콘솔에서 EC2 인스턴스 만들기

1. 콘솔에서 Amazon Linux 2 AMI 이미지 사용하여 인스턴스 생성
2. MobaXterm 으로 접속해서 필요한 도구들 설치
3. 콘솔에서 인스턴스 중지 후 이미지로 만들기
 
 <br>
 
##### 필요한 도구들 설치

```bash
sudo amazon-linux-extras install epel -y
sudo yum install -y mysql git yum-utils

curl -O http://rpms.remirepo.net/enterprise/remi-release-7.rpm
sudo rpm -Uvh remi-release-7.rpm
sudo yum-config-manager --enable remi-php72
sudo yum install -y php php-common php-mysqli

sudo systemctl start httpd
sudo systemctl enable httpd
```

<br>
 
##### 참고 : 필요한 도구들 설치하는 코드들 풀어쓴 것

```bash
sudo yum install git
sudo yum install mysql
sudo amazon-linux-extras install epel

curl -O http://rpms.remirepo.net/enterprise/remi-release-7.rpm
sudo rpm -Uvh remi-release-7.rpm

sudo yum install -y yum-utils
sudo yum-config-manager --enable remi-php72
sudo yum install -y php php-common php-mysqli

sudo systemctl start httpd
sudo systemctl enable httpd
```

<br>
 
##### 참고 : 캐시 날리는 코드 마지막에 해주면 좋음 : sudo yum clean all

```bash
[ec2-user@프라이빗IP ~]$ sudo yum clean all
Loaded plugins: extras_suggestions, langpacks, priorities, update-motd
Cleaning repos: amzn2-core amzn2extra-docker amzn2extra-epel amzn2extra-kernel-5.10 epel remi-php72 remi-safe
Cleaning up everything
Maybe you want: rm -rf /var/cache/yum, to also free up space taken by orphaned data from disabled or removed repos
```

<br>
 
### 콘솔에서 만든 이미지 ID 확인하기
![image](https://github.com/user-attachments/assets/a17f4873-742e-4f34-877b-b8c9e6017097)
 
<br>
<br>
 
## 만든 이미지 사용해서 EC2 인스턴스와 RDS 인스턴스 연결하기
 
<br>
 
### process_create.php 파일 수정해서 사용하자.

```bash
[ec2-user@프라이빗IP phpdemo]$ cat process_create.php
<?php

$conn = mysqli_connect("DB_IP","USERNAME","PASSWORD","DBNAME",3306);

$sql = "insert into items (title, description, created) value ('{$_POST['title']}','{$_POST['description']}', now())";

mysqli_query($conn,$sql);
if ($result=== false){
    echo 'error occured.';
    error_log(mysqli_error($conn));
}
echo 'Succeed. <a href="index.php"> back</a>';
```

<br>
 
##### 참고 : 변수 바꾸기 : sed 's/DB IP/${db_url}/g' process_create.php

```bash
[ec2-user@ip-172-31-21-7 cloud-demo]$ cat process_create.php
<?php

$conn = mysqli_connect("DB_IP","USERNAME","PASSWORD","DBNAME",3306);

$sql = "insert into items (title, description, created) value ('{$_POST['title']}','{$_POST['description']}', now())";

mysqli_query($conn,$sql);
if ($result=== false){
    echo 'error occured.';
    error_log(mysqli_error($conn));
}
echo 'Succeed. <a href="index.php"> back</a>';
```

```bash
[ec2-user@ip-172-31-21-7 cloud-demo]$ sed 's/DB_IP/${db_url}/g' process_create.php
<?php

$conn = mysqli_connect("${db_url}","USERNAME","PASSWORD","DBNAME",3306);

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
 
### 파일들 수정해주기
 
db.tf, main.tf, provider.tf, user-data.sh 코드 수정하기
 
```bash
[devops@ansible-controller phpdemo]$ ls
db.tf  main.tf  provider.tf  terraform.tfstate  terraform.tfstate.backup  user-data.sh
```

<br>
 
### terraform apply -auto-approve

```bash
[devops@ansible-controller phpdemo]$ terraform apply -auto-approve

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_db_instance.phpdb will be created
  + resource "aws_db_instance" "phpdb" {
			...[생략]...
    }

  # aws_instance.phpapp will be created
  + resource "aws_instance" "phpapp" {
			...[생략]...
    }

  # aws_security_group.db will be created
  + resource "aws_security_group" "db" {
      ...[생략]...
    }

  # aws_security_group.instance will be created
  + resource "aws_security_group" "instance" {
      ...[생략]...
    }

Plan: 4 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + address  = (known after apply)
  + endpoint = (known after apply)
  + port     = (known after apply)
  + testip   = (known after apply)
aws_security_group.instance: Creating...
aws_security_group.instance: Creation complete after 4s [id=sg-02b57b2119d117637]
aws_security_group.db: Creating...
aws_security_group.db: Creation complete after 4s [id=sg-0f19df8f20deeacd3]
aws_db_instance.phpdb: Creating...
aws_db_instance.phpdb: Creation complete after 3m17s [id=db-5YVPEAU2P7RPKJWC4YXWBW3IPQ]
aws_instance.phpapp: Creating...
aws_instance.phpapp: Creation complete after 15s [id=i-0c54cd758cb3dad77]

Apply complete! Resources: 4 added, 0 changed, 0 destroyed.

Outputs:

address = "terraform-mysql[생략].us-east-2.rds.amazonaws.com"
endpoint = "terraform-mysql[생략].us-east-2.rds.amazonaws.com:3306"
port = 3306
testip = "퍼블릭 IP 주소"
```

<br>
 
### 웹페이지 잘 뜸
![image](https://github.com/user-attachments/assets/4fcebda5-c592-4818-beca-abedff6eef15)
 
<br>
<br>
 
## 잘 작동하는지 확인하기
 
<br>

### db 넣기
 
![image](https://github.com/user-attachments/assets/371d13f6-79fd-48d4-a263-1299979732a8)

![image](https://github.com/user-attachments/assets/6e7b7eec-0506-4ec8-a3a1-198320e6a292)

![image](https://github.com/user-attachments/assets/d82e7363-6b58-4656-8e9b-29e71e68f489)
 
<br>
 
### db 잘 들어간 것 확인

```bash
Authenticating with public key "Imported-Openssh-Key"
    ┌──────────────────────────────────────────────────────────────────────┐
    │                 • MobaXterm Personal Edition v24.3 •                 │
    │               (SSH client, X server and network tools)               │
    │                                                                      │
    │ ⮞ SSH session to ec2-user@퍼블릭 IP 주소                             │
    │   • Direct SSH      :  ✓                                             │
    │   • SSH compression :  ✓                                             │
    │   • SSH-browser     :  ✓                                             │
    │   • X11-forwarding  :  ✗  (disabled or not supported by server)      │
    │                                                                      │
    │ ⮞ For more info, ctrl+click on help or visit our website.            │
    └──────────────────────────────────────────────────────────────────────┘

[ec2-user@프라이빗IP ~]$ cd /
[ec2-user@프라이빗IP /]$ ls
bin  boot  phpdemo  dev  etc  home  lib  lib64  local  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var
[ec2-user@프라이빗IP /]$ mysql -utestuser -ptestpass -hterraform-mysql[생략].us-east-2.rds.amazonaws.com webtest

MySQL [webtest]> show tables;
+-------------------+
| Tables_in_webtest |
+-------------------+
| items             |
+-------------------+
1 row in set (0.00 sec)

MySQL [webtest]> select * from items;
+----+----------+-------------+---------------------+
| id | title    | description | created             |
+----+----------+-------------+---------------------+
|  1 | test1234 | test4567    | 2025-01-03 07:25:29 |
+----+----------+-------------+---------------------+
1 row in set (0.00 sec)
```
 
