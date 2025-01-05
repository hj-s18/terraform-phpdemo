#! /bin/bash

sudo yum install git -y                                           # git 설치
sudo yum install mysql -y                                         # mysql 설치 ⇒ MySQL 서버에 연결해 데이터베이스를 관리할 수 있도록 해줌
sudo amazon-linux-extras install epel -y                          # EPEL(Extra Packages for Enterprise Linux) 리포지토리 추가

curl -O http://rpms.remirepo.net/enterprise/remi-release-7.rpm    # Remi Repository (PHP와 관련된 최신 버전 패키지를 제공하는 추가 리포지토리) 추가
sudo rpm -Uvh remi-release-7.rpm

sudo yum install -y yum-utils                                     # yum-utils 설치 : yum을 더 효과적으로 관리할 수 있는 도구 (例: 리포지토리 관리, 패키지 캐시 정리 등)

sudo yum-config-manager --enable remi-php72                       # Remi 리포지토리 (최신 PHP 패키지를 설치하기 위한 리포지토리) 활성화
sudo yum install -y php php-common php-mysqli                     # PHP 설치 (php-common: PHP의 기본 구성 요소 / php-mysqli: MySQL 데이터베이스와 PHP를 연동하기 위한 PHP 확장 모듈)

sudo systemctl start httpd                                        # Apache 웹 서버 시작
sudo systemctl enable httpd                                       # Apache 웹 서버 부팅 시 자동 실행 설정
