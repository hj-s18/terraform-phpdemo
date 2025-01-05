# 참고 : MySQL 명령어에 비밀번호가 직접 노출되어있음 ⇒ 보안적으로 민감할 수 있음 ⇒ AWS IAM 인증이나 환경변수 파일 등을 사용하는 것이 안전함


#!/bin/bash                                                                                         # 셸 인터프리터 선언 : 이 스크립트가 Bash셸에서 실행된다는 것을 지정
git clone -b create-table https://github.com/hj-s18/phpdemo.git                                     # git 저장소 클론(복제) : 저장소가 현재 디렉토리 안에 phpdemo 폴더로 복제됨 (create-table 브랜치에 포함된 파일만 가져옴)
mysql -u${db_username} -p${db_password} -h${db_url} ${db_name} < /phpdemo/create_table_items.sql    # MySQL 서버에 연결하고, SQL 파일을 실행하여 데이터베이스 초기화 작업 수행하거나 테이블 등을 생성함 (테이블 생성하는 코드 들어있음)
                                                                                                      # -u${db_username} : MySQL 데이터베이스 사용자 이름 ⇒ Terraform에서 제공된 변수값(var.db_username)이 ${db_username}에 치환됨
                                                                                                      # -p${db_password} : MySQL 데이터베이스 비밀번호 ⇒ Terraform에서 제공된 변수값(var.db_password)이 ${db_password}에 치환됨
                                                                                                      # -h${db_url} : 데이터베이스 서버 주소(hostname) : RDS 인스턴스의 주소(aws_db_instance.phpdb.address)가 ${db_url}에 치환됨
                                                                                                      # ${db_name} : MySQL 데이터베이스 이름 ⇒ Terraform에서 제공된 변수값(var.db_name)이 ${db_name}에 치환됨
                                                                                                      # < 파일경로 : MySQL에 실행할 SQL 스크립트 파일 경로 지정


:<<'END'
# Terraform 코드에서 user_data 속성이 templatefile 함수로 설정되어있음

resource "aws_instance" "phpapp" {
  ami                    = "ami-0d8775cee2aefefb6"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]
  key_name               = "testweb"
  
  user_data              = templatefile("user-data.sh", {
    db_name = var.db_name
    db_username = var.db_username
    db_password = var.db_password
    db_url = aws_db_instance.phpdb.address
  })

  user_data_replace_on_change = true
}
END
