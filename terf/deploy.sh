#!/bin/bash
set -e

TAG=$(date +%Y%m%d%H%M%S)
REGION="ap-northeast-1"
ACCOUNT_ID="951322695421"
ECR_URL="${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com/my-app-repo"

echo "=== 1. Login ECR ==="
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ECR_URL

echo "=== 2. Build Docker Image ==="
docker build -t my-app-repo:$TAG .
docker tag my-app-repo:$TAG $ECR_URL:$TAG
docker tag my-app-repo:$TAG $ECR_URL:latest

echo "=== 3. Push to ECR ==="
docker push $ECR_URL:$TAG
docker push $ECR_URL:latest

echo "=== 4. Force ECS Update ==="
aws ecs update-service --cluster my-app-cluster --service my-ecs-service --force-new-deployment

echo "=== Deployment Triggered Successfully ==="