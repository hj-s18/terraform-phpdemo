# 실전 테라폼 활용 실습
1. 데이터베이스 올리기 (데이터베이스 구성 → 데이터베이스 올리기)
2. 데이터 이전 (database migration)
   직접 데이터 이전하는 과정 거쳐서 코드 작성하기
   mysql -uUSER -pPASSWORD -hADDRESS (-PPORT) DB_NAME 
   입력해서 mysql과 커넥션 잘 되면, 빠져나와서 
   mysql -uUSER -pPASSWORD -hADDRESS (-PPORT) DB_NAME < createdb.sql
   입력해서 item table 생성 후 다시 들어가서 테이블 잘 생성되었는지 확인하기
   => 여기까지 코드로 작성, AWS 콘솔로 EC2 인스턴스 (이미지 Amazon Linux 2 AMI (HVM) - Kernel 5.10, SSD Volume Type 사용하기) 만든 후, mysql, git 설치 후 이미지로 만들기
   => 다시 데이터베이스 올리기

4. php 어플리케이션을 실행한다.
5. 데이터를 Insert 한다.

![image](https://github.com/user-attachments/assets/39f3500d-c492-49d4-880a-ca8dc25d0a57)
