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
    ```
    
    ```bash
    [ec2-user@퍼블릭IP주소 ~]$ sudo yum install mysql
    Loaded plugins: extras_suggestions, langpacks, priorities, update-motd
    ...[생략]...
    Installed:
      mariadb.x86_64 1:5.5.68-1.amzn2.0.1
    
    Complete!
    ```
    
    ```bash
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
