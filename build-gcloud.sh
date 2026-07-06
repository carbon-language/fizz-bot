#!/bin/sh
set -e

usage() {
  echo "Usage: build-gcloud.sh [TAG]"
  echo ""
  echo "  TAG    The tag to use for the built image in Google Cloud. Default: 'latest'."
  exit 1
}

TAG=$1
if [ "$TAG" = "--help" -o "$TAG" = "-h" ]; then
  usage
fi

if [ "$TAG" = "" ]; then
  TAG=latest
fi

gcloud --project=carbon-language builds submit \
  --config=cloudbuild.yaml \
  --substitutions=_TAG="$TAG" \
  .