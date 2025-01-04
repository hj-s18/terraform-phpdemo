resource "aws_instance" "phpapp" {                                  # AWS에서 EC2 인스턴스 생성 (phpapp : 이 리소스의 내부 참조 이름)
  ami                    = "ami-0d8775cee2aefefb6"                  # EC2 인스턴스를 생성할 때 사용할 AMI(Amazon Machine Image) ID
  instance_type          = "t3.micro"                               # 인스턴스 스펙으로 t3.micro 사용
  vpc_security_group_ids = [aws_security_group.instance.id]         # 인스턴스에 연결할 VPC 보안 그룹의 ID 목록 : aws_security_group.instance.id 값을 참조하여 설정
  key_name               = "testweb"                                # SSH 연결에 사용할 키페어 이름

  user_data              = templatefile("user-data.sh", {           # EC2 인스턴스 초기화 시 실행될 사용자 데이터 스크립트
                                                                    # user-data.sh 파일을 템플릿으로 사용하며, 변수 값들을 전달하여 처리
    db_name = var.db_name                                           # 데이터베이스 이름
    db_username = var.db_username                                   # 사용자
    db_password = var.db_password                                   # 비밀번호
    db_url = aws_db_instance.phpdb.address                          # RDS 데이터베이스 주소 : aws_db_instance.phpdb.address 참조
  })

  user_data_replace_on_change = true                                # user_data 내용이 변경될 경우 EC2 인스턴스를 교체(replace) 하도록 설정 (기존 인스턴스 삭제하고 새로 생성)
}





resource "aws_security_group" "instance" {                          # VPC의 보안 그룹 생성 (instance : 이 리소스의 내부 참조 이름)
  name = "phpapp-sg"                                                # 보안 그룹의 이름 지정


  ingress {                                                         # Ingress Rules : 들어오는 트래픽 허용 규칙
    from_port   = 22                                                # 22번 포트 허용 (SSH 트래픽)
    to_port     = 22
    protocol    = "tcp"                                             # TCP 프로토콜 사용
    cidr_blocks = ["0.0.0.0/0"]                                     # 모든 IP에서 접근 허용
  }
  ingress {                                                         # Ingress Rules : 들어오는 트래픽 허용 규칙
    from_port   = 80                                                # 80번 포트 허용 (HTTP 트래픽)
    to_port     = 80
    protocol    = "tcp"                                             # TCP 프로토콜 허용
    cidr_blocks = ["0.0.0.0/0"]                                     # 모든 IP에서 접근 허용
  }

  egress {                                                          # Egress Rules : 나가는 트래픽 허용 규칙
    from_port   = 0                                                 # 모든 포트 허용
    to_port     = 0
    protocol    = "-1"                                              # 모든 프로토콜 허용
    cidr_blocks = ["0.0.0.0/0"]                                     # 모든 IP를 대상으로 트래픽 허용
  }

}





output "testip" {                                                   # EC2 인스턴스의 Public IP 출력
  value       = aws_instance.phpapp.public_ip                       # 생성된 EC2 인스턴스의 Public IP 주소 반환
  description = "aws instance IP"                                   # 설명 : aws 인스턴스 IP
}
