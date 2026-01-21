#!/bin/sh

if ! test -e $PWD/run.sh; then
  echo "Run this from the fizz bot's root directory."
  exit 1
fi

usage() {
  echo "Usage: run-docker.sh prod|staging [IMAGE]"
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

echo "Using config $FIZZ_CONFIG_DIR/fizz.toml"
docker run -ti --rm \
  -v${CONFIG}:/config \
  -e DISCORD_TOKEN=${DISCORD_TOKEN} \
  ${IMAGE}

