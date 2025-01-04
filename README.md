# RDS 서비스로 데이터베이스 구성
### provider.tf, db.tf 작성하기

<br>
 
### **terraform init** → **terraform apply**

```bash
[devops@ansible-controller phpdemo]$ terraform init
Initializing the backend...
Initializing provider plugins...
- Finding latest version of hashicorp/aws...
- Installing hashicorp/aws v5.82.2...
- Installed hashicorp/aws v5.82.2 (signed by HashiCorp)
Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```
 
```bash
[devops@ansible-controller phpdemo]$ ls -al
total 20
drwxr-xr-x.  3 devops devops   98 Jan  3 10:08 .
drwx------. 11 devops devops 4096 Jan  3 09:20 ..
-rw-r--r--.  1 devops devops 1140 Jan  3 10:05 db.tf
-rw-r--r--.  1 devops devops   18 Jan  3 10:04 provider.tf
drwxr-xr-x.  3 devops devops   23 Jan  3 10:08 .terraform
-rw-r--r--.  1 devops devops 1377 Jan  3 10:08 .terraform.lock.hcl
```
 
```bash
[devops@ansible-controller phpdemo]$ tfa

...[생략]...

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

Outputs:

address = "terraform-mysql[생략].us-east-2.rds.amazonaws.com"
endpoint = "terraform-mysql[생략].us-east-2.rds.amazonaws.com:3306"
port = 3306
```

<br>

### 콘솔에서 만들어진 RDS 확인하기
![image](https://github.com/user-attachments/assets/d4980dc2-8576-4b68-a079-a0d0759bd294)
