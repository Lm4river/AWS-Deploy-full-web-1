## Bộ terraform template này sẽ tạo ra full resource trên AWS bao gồm:
- Networking, VPC, Subnet, Security Group.
- Application Load Balancer, TargetGroup, Listener
- Ecs Cluster
- ECS Service FE
- ECS Service BE
- Document DB - MongoEngine
- SecretManager chứa username, password của MongoDB.
### Các bước thực hiện
#### Step 1: Build docker image cho FE/BE và push lên ECR repository.
1. Tạo sẵn 2 repository trên aws ECR ví dụ
    - devops-final-assignment-frontend
    - devops-final-assignment-backend
2. Build Frontend và push lên ECR
3. Build Backend và push lên ECR

#### Step 3 triển khai Terraform:
- Thay thế URI của Frontend, Backend vào file `singapore-dev/terraform.tfvars` dòng số 6, 7.
- ```cd singapore-dev```
- ```terraform init```
- ```terraform plan --var-file terraform.tfvars```
- ```terraform apply --var-file terraform.tfvars```

#### Step 4 Kiểm tra các resource được tạo ra & thử truy cập ALB.
- Truy cập ứng dụng thông qua ALB's DNS Vd:
```http://udemy-devops-alb-1794027343.ap-southeast-1.elb.amazonaws.com```
- Thử add một vài user, xóa user.

#### Step 5: Cấu hình CICD cho repo Frontend & Backend 
Các bạn có thể tạo 2 repository trên Github từ 2 thư mục sau cho dễ config
- react-student-management
- spring-boot-student-app-api

#### Step 6: Xóa toàn bộ resource đã tạo ra.
- ```terraform destroy --var-file terraform.tfvars```


