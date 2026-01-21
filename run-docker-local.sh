#!/bin/sh

if ! test -e $PWD/run.sh; then
  echo "Run this from the fizz bot's root directory."
  exit 1
fi

usage() {
  echo "Usage: run-docker-local.sh prod|staging [IMAGE]"
  echo
  echo "  Image is probably 'fizz-bot:latest', if you built it with"
  echo "  build-docker.sh."
  exit 1
}

MODE=$1
if [[ "$MODE" == "prod" ]]; then
  echo "PROD mode"
  export CONFIG=$PWD/prod
  export DISCORD_TOKEN=`sh prod/SECRETS`
elif [[ "$MODE" == "staging" ]]; then
  echo "STAGING mode"
  export CONFIG=$PWD/staging
  export DISCORD_TOKEN=`sh staging/SECRETS`
else
  echo "Specify prod or staging mode."
  usage
fi

IMAGE=$2
if [[ "$IMAGE" == "" ]]; then
  echo "Specific a docker image."
  usage
fi

echo "Using config ${CONFIG}/fizz.toml"
docker run -ti --rm \
  -v${CONFIG}:/config \
  -e DISCORD_TOKEN=${DISCORD_TOKEN} \
  ${IMAGE}

