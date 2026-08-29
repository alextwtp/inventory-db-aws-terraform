#!/bin/bash
set -e

# 1. 登入 AWS ECR
aws ecr get-login-password --region ap-northeast-1 | docker login --username AWS --password-stdin 951322695421.dkr.ecr.ap-northeast-1.amazonaws.com

# 2. 打包 Docker 鏡像
docker build -t my-app-repo .

# 3. 標籤與推送至 ECR
docker tag my-app-repo:latest 951322695421.dkr.ecr.ap-northeast-1.amazonaws.com/my-app-repo:latest
docker push 951322695421.dkr.ecr.ap-northeast-1.amazonaws.com/my-app-repo:latest

# 4. 自動觸發 ECS 重新部署 (不用再上 Console 手動點！)
aws ecs update-service --cluster my-app-cluster --service my-ecs-service --force-new-deployment

echo "Deployment submitted successfully!"
