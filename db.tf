resource "aws_db_instance" "phpdb" {                      # AWS RDS에서 MySQL 데이터베이스 인스턴스 생성 (phpdb : 이 리소스의 내부 참조 이름)
  identifier_prefix      = "terraform-mysql"              # RDS 인스턴스 이름 앞에 붙는 접두사 ⇒ terraform-mysql-랜덤문자열 형태로 이름이 생성될 것임
  engine                 = "mysql"                        # MySQL 데이터베이스 엔진 사용
  engine_version         = "5.7"                          # 데이터베이스 엔진 버전 지정 (버전 지정 안 하면 MySQL 8.0으로 설치됨 ⇒ 5.7과 호환성 문제 있음)
  allocated_storage      = 10                             # 데이터베이스 디스크 크기 : 10GB
  instance_class         = "db.t3.micro"                  # RDS 인스턴스 사양 : db.t3.micro
  skip_final_snapshot    = true                           # 데이터베이스 삭제 시 최종 백업(snapshot) 건너뜀

  vpc_security_group_ids = [aws_security_group.db.id]     # aws_security_group.db 보안 그룹이 연결됨 ⇒ 이 보안그룹에서 허용하는 트래픽만 데이터베이스에 접근 가능

  db_name  = var.db_name                                  # 데이터베이스 이름 지정 : 값은 변수 var.db_name에서 가져옴
  username = var.db_username                              # 데이터베이스 사용자 이름 : var.db_username 변수로 정의된 값 사용
  password = var.db_password                              # 데이터베이스 비밀번호 : var.db_password 변수로 정의된 값 사용
}





resource "aws_security_group" "db" {                      # 보안 그룹(aws_security_group.db) 설정
  name = "phpdb-sg"                                       # 보안 그룹 이름 : phpdb-sg

  ingress {                                               # Ingress Rules : 들어오는 트래픽 허용 규칙
    from_port       = 3306                                # 3306번 포트 허용 (MySQL 기본 포트)
    to_port         = 3306
    protocol        = "tcp"                               # TCP 프로토콜 사용
    security_groups = [aws_security_group.instance.id]    # aws_security_group.instance에서의 트래픽만 허용
  }                                                         # main.tf 파일의 EC2 인스턴스(aws_instance.phpapp)에 적용된 보안 그룹(aws_security_group.instance) 참조 ⇒ EC2 → RDS 간 통신만 허용

  egress {                                                # Egress Rules : 나가는 트래픽 허용 규칙
    from_port   = 0                                       # 모든 포트 허용
    to_port     = 0
    protocol    = "-1"                                    # 모든 프로토콜 허용
    cidr_blocks = ["0.0.0.0/0"]                           # 모든 IP를 대상으로 트래픽 허용
  }
}





variable "db_name" {                                      # 데이터베이스 이름 정의
  description = "The name for the database"               # 이 변수에 대한 설명
  type        = string                                    # 변수 타입 : 문자열
  sensitive   = true                                      # 민감한 정보로 표시 (출력 시 숨김 처리)
  default     = "webtest"                                 # 기본 값으로 webtest 사용
}

variable "db_username" {                                  # 데이터베이스 사용자 이름 정의
  description = "The username for the database"           # 이 변수에 대한 설명
  type        = string                                    # 변수 타입 : 문자열
  sensitive   = true                                      # 민감한 정보로 표시 (출력 시 숨김 처리)
  default     = "testuser"                                # 기본 값으로 testuser 사용
}

variable "db_password" {                                  # 데이터베이스 비밀번호 정의
  description = "The password for the database"           # 이 변수에 대한 설명
  type        = string                                    # 변수 타입 : 문자열
  sensitive   = true                                      # 민감한 정보로 표시 (출력 시 숨김 처리)
  default     = "testpass"                                # 기본 값으로 testpass 사용
}





output "address" {                                              # 데이터베이스 엔드포인트 주소 출력
  value       = aws_db_instance.phpdb.address                   # phpdb RDS 인스턴스의 주소를 참조함
  description = "Connect to the database at this endpoint"      # 설명 : 이 주소에서 데이터베이스에 연결할 수 있음
}

output "port" {                                                 # 데이터베이스가 사용하는 포트 출력
  value       = aws_db_instance.phpdb.port                      # phpdb RDS 인스턴스의 포트번호 출력 (MySQL의 기본 포트는 3306임)
  description = "The port the database is listening on"         # 설명 : 데이터베이스가 수신하는 포트
}

output "endpoint" {                                             # 데이터베이스의 주소와 포트를 결합한 완전한 엔드포인트 출력
  value       = aws_db_instance.phpdb.endpoint                  # phpdb RDS 인스턴스의 엔드포인트 출력
  description = "The endpoint of database"                      # 설명 : 데이터베이스의 엔드포인트
}
