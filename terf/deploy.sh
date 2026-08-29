#!/bin/bash
set -e

# 1. get ECR login credentials
aws ecr get-login-password --region ap-northeast-1 | docker login --username AWS --password-stdin 951322695421.dkr.ecr.ap-northeast-1.amazonaws.com

# 2. build local Image (if not already built)
docker build -t my-app .

# 3. tag the Image with ECR repository URL
docker tag my-app:latest 951322695421.dkr.ecr.ap-northeast-1.amazonaws.com/my-app-repo:latest

# 4. push the Image to AWS ECR
docker push 951322695421.dkr.ecr.ap-northeast-1.amazonaws.com/my-app-repo:latest








# bash deploy.sh







# ACCOUNT_ID="32751428930113226327514289301421"
# REGION="ap-northeast-1"
# REPO_NAME="my-app-repo"
# ECR_URL="${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com"

# echo "=========================================="
# echo " [1/4] 登入 AWS ECR..."
# echo "=========================================="
# aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ECR_URL

# echo "=========================================="
# echo " [2/4] 打包本地 Docker Image..."
# echo "=========================================="
# docker build -t $REPO_NAME .

# echo "=========================================="
# echo " [3/4] 打上 ECR 標籤..."
# echo "=========================================="
# docker tag ${REPO_NAME}:latest ${ECR_URL}/${REPO_NAME}:latest

# echo "=========================================="
# echo " [4/4] 推送 Image 到 ECR..."
# echo "=========================================="
# docker push ${ECR_URL}/${REPO_NAME}:latest

# echo "=========================================="
# echo " 🎉 部署完成！Image 已順利推送到 ECR！"
# echo "=========================================="
