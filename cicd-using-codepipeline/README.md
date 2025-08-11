# CICD sử dụng CodePipeline (hướng dẫn dành cho khóa DevOps)

### Yêu cầu:
- Đảm bảo rằng bạn đã build frontend & backend Docker Image sau đó push thành công lên ECR repository.
- Sử dụng bộ terraform được cung cấp sẵn trong thư mục "terraform" file hướng dẫn "command.sh" để triển khai stack.
- Truy cập và test hoạt động của ứng dụng.

### Các step thực hiện.
- Để cho đơn giản, các bạn tách source thành 2 repository trên Github như sau:
    - devops-final-assignment-1-frontend
    - devops-final-assignment-1-backend
### Tạo CICD pipeline cho Frontend
### Step 1: Chuẩn bị
- Tham khảo file thư mục: `frontend`
- File `buildspec.yaml`
    - Dòng 4, 5: Thay thế thành secretmanager name chứa Dockerhub username/password.
    - Dòng 10: Thay thế thành ECR repository của Frontend.
    - Dòng 14: Thay thế thành lệnh login to ECR.
- File `tasdef.json`
    - Dòng 3: Sửa thành task execution role tương ứng với môi trường của bạn.
    - Dòng 24: Sửa thành task definition family cho frontend (skip nếu bạn tạo resource = Terraform)
- File `appspec.yaml`
    - Dòng 11: Sửa thành ARN của task definition cho frontend.
- Copy cả 3 file `buildspec.yaml`, `tasdef.json`, `appspec.yaml` vào repository frontend (ở root level), commit, push lên Github.

### Step 2: Tạo CodeBuild cho Frontend.
- Truy cập vào CodeBuild, tạo mới một Build Project
- Project Name: `devops-assignment-1-frontend`
- Source 1 - Primary: 
    - chọn Github. *Có thể sẽ yêu cầu login vào Github nếu là lần đầu.
    - Chọn Repository tương ứng với frontend.
    - Branch nhập `master`
- Environment: 
    - Provisioning model: `On-Demand`
    - Environment image: `Managed Image`
    - Compute: EC2
    - Operating System: `Ubuntu`, Runtime: `Standard`, Image: `aws/codebuild/standard:7.0`, Image Version: `Always use latest image...`
    - Service role: Tạo mới một Service Role hoặc tái sử dụng lại Service Role cho CodeBuild từ các chương trước.
    - Click `Additional configuration`, kéo xuống chỗ `Privileged` và tick vào flag cho phép build docker image.
- Buildspec: chọn `Use buildspec file`, input `buildspec.yaml`
- Artifact: chọn `No artifact`
- Các setting khác để mặc định. 
- Nhấn nút Create Build Project.
- Build thử và troubleshoot lỗi nếu có.

### Step 3: Tạo CodePipeline cho Frontend
Lưu ý: Do bài assignment sử dụng phương án Rolling Update (mặc định của ECS) nên không cần sự tham gia của CodeDeploy.
- Truy cập vào CodePipeline.
- Chọn tạo một Pipeline mới
- Creation options: `Build custom pipeline`, nhấn Next
- Pipeline name: `devops-assignment-1-frontend`
- Execution mode: chọn `Queued (Pipeline type V2 required)`
- Service role: Chọn một role có sẵn hoặc tạo mới. Nhấn Next.
- Source provider: `GitHub (via GitHub App)`
- Connection: `CodePipeline`
- Repository name chọn: `devops-final-assignment-1-frontend`
- Default branch: `master`
- Output artifact format: `CodePipeline default`. Nhấn Next.
- Build provider chọn Other Build Provider, chọn CodeBuild, chọn CodeBuild application đã được tạo ra trước đó. Nhấn Next.
- Deploy provider: chọn `Amazon ECS`
- Cluster name: chọn cluster tương ứng.
- Service name: chọn service frontend.
- Image definitions file - optional: nhập `imagedefinitions.json`. Nhấn Next.
- Review và tạo CodePipeline.

### Step 5: Change code & Test việc release tự động. 
- Modify Source code & push lên github.
- Thử chạy CodePipeline (hoặc được trigger tự động)
- Kiểm tra Frontend được update.

### Tạo CICD pipeline cho Backend
### Step 1: Chuẩn bị
- Tham khảo file thư mục: `backend`
- File `buildspec.yaml`
    - Dòng 4, 5: Thay thế thành secretmanager name chứa Dockerhub username/password.
    - Dòng 10: Thay thế thành ECR repository của Backend.
    - Dòng 14: Thay thế thành lệnh login to ECR.
- File `tasdef.json`
    - Dòng 3: Sửa thành task execution role tương ứng với môi trường của bạn.
    - Dòng 24: Sửa thành task definition family cho backend (skip nếu bạn tạo resource = Terraform)
- File `appspec.yaml`
    - Dòng 11: Sửa thành ARN của task definition cho backend.
- Copy cả 3 file `buildspec.yaml`, `tasdef.json`, `appspec.yaml` vào repository backend (ở root level), commit, push lên Github.

### Step 2: Tạo CodeBuild cho Backend.
- Truy cập vào CodeBuild, tạo mới một Build Project
- Project Name: `devops-assignment-1-backend`
- Source 1 - Primary: 
    - chọn Github. *Có thể sẽ yêu cầu login vào Github nếu là lần đầu.
    - Chọn Repository tương ứng với backend.
    - Branch nhập `master`
- Environment: 
    - Provisioning model: `On-Demand`
    - Environment image: `Managed Image`
    - Compute: EC2
    - Operating System: `Ubuntu`, Runtime: `Standard`, Image: `aws/codebuild/standard:7.0`, Image Version: `Always use latest image...`
    - Service role: Tạo mới một Service Role hoặc tái sử dụng lại Service Role cho CodeBuild từ các chương trước.
    - Click `Additional configuration`, kéo xuống chỗ `Privileged` và tick vào flag cho phép build docker image.
- Buildspec: chọn `Use buildspec file`, input `buildspec.yaml`
- Artifact: chọn `No artifact`
- Các setting khác để mặc định. 
- Nhấn nút Create Build Project.
- Build thử và troubleshoot lỗi nếu có.

### Step 3: Tạo CodePipeline cho Backend
Lưu ý: Do bài assignment sử dụng phương án Rolling Update (mặc định của ECS) nên không cần sự tham gia của CodeDeploy.
- Truy cập vào CodePipeline.
- Chọn tạo một Pipeline mới
- Creation options: `Build custom pipeline`, nhấn Next
- Pipeline name: `devops-assignment-1-backend`
- Execution mode: chọn `Queued (Pipeline type V2 required)`
- Service role: Chọn một role có sẵn hoặc tạo mới. Nhấn Next.
- Source provider: `GitHub (via GitHub App)`
- Connection: `CodePipeline`
- Repository name chọn: `devops-final-assignment-1-backend`
- Default branch: `master`
- Output artifact format: `CodePipeline default`. Nhấn Next.
- Build provider chọn Other Build Provider, chọn CodeBuild, chọn CodeBuild application đã được tạo ra trước đó. Nhấn Next.
- Deploy provider: chọn `Amazon ECS`
- Cluster name: chọn cluster tương ứng.
- Service name: chọn service backend.
- Image definitions file - optional: nhập `imagedefinitions.json`. Nhấn Next.
- Review và tạo CodePipeline.

### Step 5: Change code & Test việc release tự động. 
- Modify Source code & push lên github.
- Thử chạy CodePipeline (hoặc được trigger tự động)
- Kiểm tra Backend được update.