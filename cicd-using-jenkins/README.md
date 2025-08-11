# CICD sử dụng Jenkins (hướng dẫn dành cho khóa DevOps)

### Yêu cầu:
- Đảm bảo rằng bạn đã build frontend & backend Docker Image sau đó push thành công lên ECR repository.
- Sử dụng bộ terraform được cung cấp sẵn trong thư mục "terraform" file hướng dẫn "command.sh" để triển khai stack.
- Truy cập và test hoạt động của ứng dụng.

### Các step thực hiện.
- Để cho đơn giản, các bạn tách source thành 2 repository trên Github như sau:
    - devops-final-assignment-1-frontend
    - devops-final-assignment-1-backend
- Chuẩn bị sẵn một Jenkins Server (chạy trên Ubuntu) đã cài đặt đầy đủ các công cụ cần thiết. Các bạn có thể tái sử dụng lại Jenkins server từ chương CICD Jenkins.

### Step 1: Tạo build job cho FE.
- Tham khảo file `frontend-job.groovy`
- kiểm tra và modify dòng 4 cho đúng với môi trường của bạn.
- Dòng 9, 10, 11  không thay đổi nếu bạn sd Terraform đã được cung cấp để tạo resources.
- Dòng 21: sửa thành lệnh login vào ECR repository của bạn.
- Copy nội dung trong file `frontend-job.groovy` vào project Frontend và đổi tên thành `Jenkinsfile`, commit, push lên Github.
- Truy cập vào jenkins, tạo một Job mới
    - Name: final-assignment-1-frontend
    - Type: Pipeline
    - Nhập mô tả (Optional)
    - Kéo xuống khu vực Pipeline, chọn Pipeline from SCM
    - SCM: Chọn Git
    - Repository URL nhập SSH url của Github repository.
    - Credential: Chọn credential vẫn thường sử dụng để checkout code từ repo private trên Github. *Xem lại Lab-7 chương CICD sử dụng Jenkins.
    - Branch to build: Để mặc định là */master
    - Script Path: để mặc định là `Jenkinsfile`
### Step 2: Change code & Test việc release tự động. 
- Modify source code Frontend repo.
- Chọn job build đã tạo ra và nhấn Build now
- Kiểm tra log của job chạy SUCCESS
- Kiểm tra trạng thái rolling Out của ECS Service `final-assignment-fe`
- Truy cập vào ứng dụng và kiểm tra thay đổi.
- Optional: cấu hình trigger tự động từ Github sử dụng Webhook
    - Trong repository trên Github, vào "Settings" > "Webhooks" > "Add webhook"
    - Set "Payload URL" là http://<your-jenkins-url>/github-webhook/  *LƯU Ý phải có dấu / ở cuối URL
    - Set "Content type" là application/json
    - Chọn các event mà bạn muốn trigger webhook. click "Let me select individual events" và chọn "Pushes" và "Pull request"
    - Click "Add webhook" để lưu thay đổi.

### Step 3: Tạo build project cho BE.
- Tham khảo file `backend-job.groovy`
- kiểm tra và modify dòng 4 cho đúng với môi trường của bạn.
- Dòng 9, 10, 11  không thay đổi nếu bạn sd Terraform đã được cung cấp để tạo resources.
- Dòng 21: sửa thành lệnh login vào ECR repository của bạn.
- Copy nội dung trong file `backend-job.groovy` vào project Backend và đổi tên thành `Jenkinsfile`, commit, push lên Github.
- Truy cập vào jenkins, tạo một Job mới
    - Name: final-assignment-1-backend
    - Type: Pipeline
    - Nhập mô tả (Optional)
    - Kéo xuống khu vực Pipeline, chọn Pipeline from SCM
    - SCM: Chọn Git
    - Repository URL nhập SSH url của Github repository.
    - Credential: Chọn credential vẫn thường sử dụng để checkout code từ repo private trên Github. *Xem lại Lab-7 chương CICD sử dụng Jenkins.
    - Branch to build: Để mặc định là */master
    - Script Path: để mặc định là `Jenkinsfile`

### Step 4: Change code & Test việc release tự động. 
- Modify source code Backend repo.
- Chọn job build đã tạo ra và nhấn Build now
- Kiểm tra log của job chạy SUCCESS
- Kiểm tra trạng thái rolling Out của ECS Service `final-assignment-be`
- Truy cập vào ứng dụng và kiểm tra thay đổi.
- Optional: cấu hình trigger tự động từ Github sử dụng Webhook
    - Trong repository trên Github, vào "Settings" > "Webhooks" > "Add webhook"
    - Set "Payload URL" là http://<your-jenkins-url>/github-webhook/  *LƯU Ý phải có dấu / ở cuối URL
    - Set "Content type" là application/json
    - Chọn các event mà bạn muốn trigger webhook. click "Let me select individual events" và chọn "Pushes" và "Pull request"
    - Click "Add webhook" để lưu thay đổi.