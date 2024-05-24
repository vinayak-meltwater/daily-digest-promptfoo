#!/usr/bin/env bash

set -e

# Find out ECR hostname and set up credentials
# --------------------------------------------

AWS_ACCOUNT_ID=$(aws sts get-caller-identity --output text --query 'Account')
AWS_REGION=eu-west-1
ECR_REGISTRY=${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
aws ecr get-login-password --region=${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REGISTRY}

# Set name and tag for docker image
# ---------------------------------
ECR_REPOSITORY=${ECR_REGISTRY}/${DOCKER_IMAGE}
DOCKER_TAG=${DOCKER_TAG}
DOCKER_FULL_TAG=${ECR_REPOSITORY}:${DOCKER_TAG}

# Build and push image
# --------------------
DOCKER_BUILDKIT=1 docker build . \
  --build-arg="NPM_TOKEN=${NPM_TOKEN}" \
  -t ${DOCKER_FULL_TAG}

docker push ${DOCKER_FULL_TAG}