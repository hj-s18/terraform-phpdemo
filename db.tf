                                                    # MySQL RDS 인스턴스 생성 (aws_db_instance)

resource "aws_db_instance" "phpdb" {                # AWS 의 RDS(Relational Database Service)에서 MySQL 데이터베이스 인스턴스 생성
                                                    # phpdb : 이 데이터베이스 리소스에 대한 내부 참조 이름
  identifier_prefix   = "terraform-mysql"           # RDS 인스턴스 이름 앞에 붙는 접두사 ⇒ terraform-mysql-랜덤문자열 형태로 이름이 생성될 것임
  engine              = "mysql"                     # MySQL 데이터베이스 엔진 사용
  allocated_storage   = 10                          # 데이터베이스의 디스크 크기를 10GB로 설정
  instance_class      = "db.t3.micro"               # RDS 인스턴스의 사양을 db.t3.micro로 사용 (저비용 옵션)
  skip_final_snapshot = true                        # true : 데이터베이스 삭제 시 최종 백업(snapshot)을 건너뜀
  db_name             = var.db_name                 # 데이터베이스 이름 지정 : 값은 변수 var.db_name에서 가져옴
  username            = var.db_username             # 데이터베이스 사용자 이름 : var.db_username 변수로 정의된 값 사용
  password            = var.db_password             # 데이터베이스 비밀번호 : var.db_username 변수로 정의된 값 사용
}



                                                    # 변수 정의 → 데이터베이스 이름, 사용자 이름, 비밀번호를 변수로 관리

variable "db_name" {                                # 데이터베이스 이름 정의
  description = "The name for the database"         # 이 변수에 대한 설명
  type        = string                              # 변수 타입 : 문자열
  sensitive   = true                                # 민감한 정보로 표시 (출력 시 숨김 처리)
  default     = "webtest"                           # 기본 값으로 webtest 사용
}

variable "db_username" {                            # 데이터베이스 사용자 이름 정의
  description = "The username for the database"     # 이 변수에 대한 설명
  type        = string                              # 변수 타입 : 문자열
  sensitive   = true                                # 민감한 정보로 표시 (출력 시 숨김 처리)
  default     = "testuser"                          # 기본 값으로 testuser 사용
}

variable "db_password" {                            # 데이터베이스 비밀번호 정의
  description = "The password for the database"     # 이 변수에 대한 설명
  type        = string                              # 변수 타입 : 문자열
  sensitive   = true                                # 민감한 정보로 표시 (출력 시 숨김 처리)
  default     = "testpass"                          # 기본 값으로 testpass 사용
}



                                                                # 생성된 데이터베이스의 주소, 포트, 엔드포인트 출력


output "address" {                                              # 데이터베이스 엔드포인트 주소 출력
  value       = aws_db_instance.phpdb.address                   # phpdb RDS 인스턴스의 주소를 참조함
  description = "Connect to the database at this endpoint"      # 설명 : 이 주소에서 데이터베이스에 연결할 수 있음
}

output "port" {                                                 # 데이터베이스가 사용하는 포트 출력
  value       = aws_db_instance.phpdb.port                      # phpdb RDS 인스턴스의 포트번호 출력 (MySQL의 기본 포트는 3306임)
  description = "The port the database is listening on"         # 설명 : 데이터베이스가 수신하는 포트
}

# address:port = endpoint
output "endpoint" {                                             # 데이터베이스의 주소와 포트를 결합한 완전한 엔드포인트 출력
  value       = aws_db_instance.phpdb.endpoint                  # phpdb RDS 인스턴스의 엔드포인트 출력
  description = "The endpoint of database"                      # 설명 : 데이터베이스의 엔드포인트
}
