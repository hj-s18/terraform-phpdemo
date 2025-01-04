### 콘솔에서 직접 EC2 인스턴스 만들기

Amazon Linux2 AMI 사용하기 <br>
인바운드 규칙으로 22, 80 포트 열어주기

<br>

### MobaXterm에서 인스턴스로 접속하기

<br>

### MySQL 설치

```bash
[ec2-user@퍼블릭IP주소 ~]$ sudo yum update
Loaded plugins: extras_suggestions, langpacks, priorities, update-motd
amzn2-core                                                                               | 3.6 kB  00:00:00
No packages marked for update

[ec2-user@퍼블릭IP주소 ~]$ sudo yum install mysql
...[생략]...
Installed:
  mariadb.x86_64 1:5.5.68-1.amzn2.0.1

Complete!
```

<br>

### RDS로 접속 시도 → 실패

mysql -u<데이터베이스 사용자 이름> -p<데이터베이스 비밀번호> -h<데이터베이스 엔드포인트> -P<포트> <데이터베이스 이름>

```bash
[ec2-user@퍼블릭IP주소 ~]$ mysql -utestuser -ptestpass -h<데이터베이스 엔드포인트> -P3306 webtest
ERROR 2005 (HY000): Unknown MySQL server host '<데이터베이스 엔드포인트>:3306' (2)
```

<br>

### 참고 : 데이터베이스 엔드포인트 확인하기

```bash
[devops@ansible-controller phpdemo]$ terraform output endpoint
"terraform-mysql20250103011832219800000001.c0k8gjmf4fb9.us-east-2.rds.amazonaws.com:3306"
[devops@ansible-controller phpdemo]$ terraform output address
"terraform-mysql20250103011832219800000001.c0k8gjmf4fb9.us-east-2.rds.amazonaws.com"
```

<br>

### epel repository 설치

Amazon Linux 추가 패키지 관리 도구 사용해서 Amazon Linux 2 에서 더 적합한 명령어로 설치함

EPEL 패키지 직접 설치해도 됨 : **yum install epel-release -y**

```bash
[ec2-user@퍼블릭IP주소 ~]$ sudo amazon-linux-extras install epel
Installing epel-release
...[생략]...
Installed:
  epel-release.noarch 0:7-11

Complete!
...[생략]...
```

<br>

### RDS로 접속 시도 → 실패

```bash
[ec2-user@퍼블릭IP주소 ~]$ mysql -utestuser -ptestpass -h<데이터베이스 엔드포인트> -P3306 webtest
ERROR 2005 (HY000): Unknown MySQL server host '<데이터베이스 엔드포인트>:3306' (2)
```

<br>

### database 보안그룹에 인스턴스에서 들어오는 트래픽 허용해주기
 
콘솔에서 새로운 보안그룹 생성 후 RDS에 추가하기 <br>
보안그룹 만들 때, 인바운드 유형 모든 트래픽으로 해도 되고, mysql(3306)으로 해도 됨 <br>
아웃바운드도 3306만 열어도 좋은데, 나중에 업데이트 요청 등을 보낼수도 있으므로 모든 트래픽으로 열어두자!

<br>

### RDS로 접속 → webtest 라는 데이터베이스 생성되어있는 것 확인
 
```bash
[ec2-user@퍼블릭IP주소 ~]$ mysql -utestuser -ptestpass -h<데이터베이스 엔드포인트> -P3306 webtest
Welcome to the MariaDB monitor.
...[생략]...

MySQL [webtest]> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
| webtest            |
+--------------------+
5 rows in set (0.00 sec)

MySQL [webtest]> show tables;
Empty set (0.00 sec)
```

<br>

### table 생성하기

![image](https://github.com/user-attachments/assets/aca26b9b-f11a-48f8-892b-88a04a50e8fc)

  
```bash
[ec2-user@퍼블릭IP주소 ~]$ sudo yum install git
Loaded plugins: extras_suggestions, langpacks, priorities, update-motd
Resolving Dependencies

...[생략]...

Installed:
  git.x86_64 0:2.40.1-1.amzn2.0.3

Dependency Installed:
  git-core.x86_64 0:2.40.1-1.amzn2.0.3    git-core-doc.noarch 0:2.40.1-1.amzn2.0.3    perl-Error.noarch 1:0.17020-2.amzn2    perl-Git.noarch 0:2.40.1-1.amzn2.0.3    perl-TermReadKey.x86_64 0:2.30-20.amzn2.0.2

Complete!

[ec2-user@퍼블릭IP주소 ~]$ git clone -b create-table https://github.com/hj-s18/phpdemo.git
Cloning into 'phpdemo'...
...[생략]...

[ec2-user@퍼블릭IP주소 ~]$ ls
phpdemo
```
 
```bash
[ec2-user@퍼블릭IP주소 ~]$ cd cloud-demo/
[ec2-user@퍼블릭IP주소 phpdemo]$ ls
create_db_webtest.sql
[ec2-user@퍼블릭IP주소 phpdemo]$ cat create_db_webtest.sql
create table items ( id int(11) not null auto_increment, title varchar(45) not null, description text, created datetime not null, primary key(id) );
```
 
```bash
[ec2-user@퍼블릭IP주소 phpdemo]$ mysql -utestuser -ptestpass -h<데이터베이스 엔드포인트> -P3306 webtest < create_db_webtest.sql
[ec2-user@퍼블릭IP주소 phpdemo]$ mysql -utestuser -ptestpass -h<데이터베이스 엔드포인트> -P3306 webtest
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Welcome to the MariaDB monitor.
...[생략]...

MySQL [webtest]> show tables;
+-------------------+
| Tables_in_webtest |
+-------------------+
| items             |
+-------------------+
1 row in set (0.00 sec)

MySQL [webtest]> select * from items;
Empty set (0.00 sec)
```

<br>

### 가상머신 만들 때 생각해야 할 것

가상머신이 만들어질 때 설치되게 할 것인지 또는 이미지로 미리 만들어놓을지 선택 <br>
mysql과 git은 버전 변경될 가능성이 낮음 ⇒ 이미지로 만들어도 됨 <br>
create ami image with mysql, git pkg → instance provision 방법을 사용하자!

<br>

### 콘솔에서 EC2 인스턴스 만들어서 mysql, git pkg 설치 후 이미지로 만들기

1. 콘솔에서 Amazon Linux 2 AMI 이미지 사용하여 인스턴스 생성

2. MobaXterm 으로 접속해서 mysql, git 설치

```bash
[ec2-user@퍼블릭IP주소 ~]$ sudo yum install git
Loaded plugins: extras_suggestions, langpacks, priorities, update-motd
...[생략]...
Installed:
  git.x86_64 0:2.40.1-1.amzn2.0.3

Dependency Installed:
  git-core.x86_64 0:2.40.1-1.amzn2.0.3    git-core-doc.noarch 0:2.40.1-1.amzn2.0.3    perl-Error.noarch 1:0.17020-2.amzn2    perl-Git.noarch 0:2.40.1-1.amzn2.0.3    perl-TermReadKey.x86_64 0:2.30-20.amzn2.0.2

Complete!

[ec2-user@퍼블릭IP주소 ~]$ sudo yum install mysql
Loaded plugins: extras_suggestions, langpacks, priorities, update-motd
...[생략]...
Installed:
  mariadb.x86_64 1:5.5.68-1.amzn2.0.1

Complete!

[ec2-user@퍼블릭IP주소 ~]$ sudo amazon-linux-extras install epel
Installing epel-release
Loaded plugins: extras_suggestions, langpacks, priorities, update-motd
...[생략]...
Installed:
  epel-release.noarch 0:7-11

Complete!

...[생략]...
```

3. 콘솔에서 인스턴스 중지 후 이미지로 만들기
