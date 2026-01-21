#!/bin/sh

usage() {
  echo "Usage: push-docker.sh [DOCKERHUBUSER]"
  echo ""
  echo "  Example usage: ./push-docker.sh danakj [TAG]"
  echo ""
  echo "  TAG    The tag to use when pushing. Default: 'latest'."
  echo ""
  echo "  Ensure you are logged into docker hub with that user via 'docker login'"
  exit 1
}

USER=$1
if [[ "$USER" == "" ]]; then
  usage
fi

TAG=$2
if [[ "$TAG" == "" ]]; then
  TAG=latest
fi

sudo docker tag fizz-bot:latest $USER/fizz-bot:$TAG || exit 1
sudo docker push $USER/fizz-bot:$TAG

