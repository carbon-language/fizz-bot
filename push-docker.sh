#!/bin/sh

usage() {
  echo "Usage: push-docker.sh [DOCKERHUBUSER]"
  echo
  echo "  Example usage: ./push-docker.sh danakj"
  echo
  echo "  Ensure you are logged into docker hub with that user via `docker login`"
  exit 1
}

USER=$1
if [[ "$USER" == "" ]]; then
  usage
fi

sudo docker tag fizz-bot:latest $USER/fizz-bot:latest || exit 1
sudo docker push $USER/fizz-bot:latest

