#!/bin/bash

NAME=vqa-svc
TAG=latest
AWS_ECR=392385672822.dkr.ecr.us-east-1.amazonaws.com


# Keys:
SSH_PUBLIC=`cat ~/.ssh/id_rsa.pub`
SSH_PRIVATE=`cat ~/.ssh/id_rsa`

# Build, tag, and push docker image:
SOURCE_IMG=${NAME}:${TAG}
/usr/local/bin/docker build -t ${SOURCE_IMG} . --build-arg SSH_PRIVATE_KEY="${SSH_PRIVATE}" --build-arg SSH_PUBLIC_KEY="${SSH_PUBLIC}"
TARGET_IMG=${AWS_ECR}/${NAME}:${TAG}
/usr/local/bin/docker tag ${SOURCE_IMG} ${TARGET_IMG}
/usr/local/bin/docker push ${TARGET_IMG}

echo "done"
